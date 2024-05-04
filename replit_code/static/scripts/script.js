var isNavOpen = false; // Variable to track if sidebar is open

function toggleNav() {
    if (!isNavOpen) {
        openNav();
    } else {
        closeNav();
    }
}

function openNav() {
    document.getElementById("mySidenav").style.width = "250px";
    isNavOpen = true;
}

function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
    isNavOpen = false;
}
function toggleRightNav() {
    document.getElementById("myRightNav").style.width = "250px";
}

function closeRightNav() {
    document.getElementById("myRightNav").style.width = "0";
}

document.addEventListener('DOMContentLoaded', (event) => {
const sendButton = document.getElementById('send-button');
const messageInput = document.getElementById('message-input');
const messageContainer = document.getElementById('message-container');
const sendContainer = document.getElementById('send-container');
const newProjectButton = document.getElementById('new-project-button');
const previousTerraformButton = document.getElementById('previous-terraform-button');
const chatContainer = document.getElementById('chat-container');
const startupContainer = document.getElementById('startup-container');

const converter = new showdown.Converter();
let currentState = 'initial';
let architecture = '';
let terraformCode = '';
let improvements = '';
let feedback = "Initial Feedback (None)";
let terraformFeedback = '';

newProjectButton.onclick = () => {
    currentState = 'generate_architecture';
    chatContainer.style.display = 'flex'; // Show the chat container
    startupContainer.style.display = 'none'; // Hide the startup container
};

previousTerraformButton.onclick = () => {
    currentState = 'revise_terraform';
    chatContainer.style.display = 'flex'; // Show the chat container
    startupContainer.style.display = 'none'; // Hide the startup container
};

function appendMessage(message, isUserMessage = false, isMarkdown = false) {
    const messageElement = document.createElement('div');
    if (isMarkdown) {
        messageElement.innerHTML = converter.makeHtml(message);
    } else {
        messageElement.textContent = message;
    }

    if (isUserMessage) {
        const imageElement = document.createElement('img');
        imageElement.src = '/static/assets/bluecloud.png';
        imageElement.className = 'user-image';
        messageContainer.appendChild(imageElement);
    }
  
    messageElement.className = isUserMessage ? 'user-message' : 'bot-response';
    messageContainer.appendChild(messageElement);
    messageContainer.scrollTop = messageContainer.scrollHeight;
}
    function sendMessage(overrideMessage = null) {
        const message = overrideMessage || messageInput.value.trim();
        if (message) {
            appendMessage(message, true);
            messageInput.disabled = true;
            sendButton.disabled = true;

            let endpoint = '';
            let payload = { message: message, architecture: architecture };

            switch (currentState) {
                case 'generate_architecture':
                    endpoint = '/generate_architecture';
                    payload.feedback = feedback;
                    break;
                case 'awaiting_architecture_confirmation':
                    endpoint = '/confirm_architecture';
                    break;
                case 'generate_improvements_confirmation':
                    endpoint = '/generate_improvements_confirmation';
                    break;
                case 'generate_improvements':
                    endpoint = '/generate_improvements';
                    break;
                case 'confirm_improvements':
                    endpoint = '/confirm_improvements';
                    break;
                case 'generate_terraform_code':
                    endpoint = '/generate_terraform';
                    payload.improvements = improvements;
                    payload.terraformCode = terraformCode;
                    break;
                case 'collecting_feedback':
                    endpoint = '/process_feedback';
                    payload.feedback = feedback;
                    break;
                case 'collecting_terraform_feedback':
                    endpoint = '/process_terraform_feedback';
                    payload.terraformFeedback = terraformFeedback;
                    payload.terraformCode = terraformCode;
                    break;
                case 'awaiting_terraform_confirmation':
                    endpoint = '/confirm_terraform_code';
                    payload.terraformCode = terraformCode;
                    break;
                case 'offer_download':
                    endpoint = '/download_terraform';
                    payload.terraformCode = terraformCode; 
                    break;
                case 'Completed':
                    endpoint = 'completed';
                    break;
                default:
                    appendMessage("Error: Invalid application state.", false);
                    return;
            }

            fetch(endpoint, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(payload)
            })
            .then(response => response.json())
            .then(data => {
                if(currentState === 'generate_architecture' || currentState === 'generate_improvements' || currentState === 'collecting_feedback' || currentState === 'generate_terraform_code' || currentState === 'awaiting_terraform_confirmation') {
                    appendMessage(data.response, false, true);
                } else { 
                appendMessage(data.response, false, data.isMarkdown || false);
                } if (data.prompt) {
                    appendMessage(data.prompt, false);
                }
                currentState = data.nextState;
                architecture = data.architecture || architecture;
                improvements = data.improvements || improvements;
                terraformCode = data.terraformCode || terraformCode;
                feedback = data.feedback || feedback;
                terraformFeedback = data.terraformFeedback || terraformFeedback;

                if (currentState === 'offer_download') {
                    appendMessage("Click the button below to download the Terraform code.", false);
                    showDownloadOption();
                }
                messageInput.disabled = false;
                sendButton.disabled = false;
                messageInput.value = '';
            })
            .catch(error => {
                console.error('Error:', error);
                appendMessage("Failed to send message.", false);
                messageInput.disabled = false;
                sendButton.disabled = false;
            });
        }
    }

    function showDownloadOption() {
        const downloadButton = document.createElement('button');
        downloadButton.innerText = 'Download Terraform Code';
        downloadButton.className = 'download-button'; 
        downloadButton.onclick = function() {
            fetch('/download_terraform', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({message: 'yes', terraformCode: terraformCode})
            }).then(response => {
                if (response.ok) {
                    response.blob().then(blob => {
                        const url = window.URL.createObjectURL(blob);
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = "terraform_configuration.tf";
                        document.body.appendChild(a);
                        a.click();
                        a.remove();
                    });
                }
            });
        };
        appendMessage("", false); // Append an empty bot message to ensure alignment
        const messageElement = document.createElement('div');
        messageElement.appendChild(downloadButton);
        messageElement.className = 'bot-response';
        messageContainer.appendChild(messageElement);
        messageContainer.scrollTop = messageContainer.scrollHeight;
    }

    
  sendButton.addEventListener('click', function(event) {
      event.preventDefault();  // Prevent default form submission
      sendMessage();
  });

  messageInput.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') {
          e.preventDefault();  // Prevent form submission
          sendMessage();
        }
    });
});