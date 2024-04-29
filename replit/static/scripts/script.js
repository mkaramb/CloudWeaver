document.addEventListener('DOMContentLoaded', (event) => {
    const sendButton = document.getElementById('send-button');
    const messageInput = document.getElementById('message-input');
    const messageContainer = document.getElementById('message-container');
    const converter = new showdown.Converter();
    
    let currentState = 'initial';
    let architecture = '';
    let terraformCode = '';
    let improvements = '';
    let feedback = "Initial Feedback (None)";

    function appendMessage(message, isUserMessage = false, isMarkdown = false) {
        const messageElement = document.createElement('div');
        if (isMarkdown) {
          messageElement.innerHTML = converter.makeHtml(message);
        } else {
          messageElement.textContent = message;
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
                case 'initial':
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
                case 'awaiting_terraform_confirmation':
                    endpoint = '/confirm_terraform_code';
                    payload.terraformCode = terraformCode;
                    break;
                case 'offer_download':
                    endpoint = '/download_terraform';
                    payload.terraformCode = terraformCode; 
                    break;
                case 'Completed':
                    endpoint = '/generate_architecture'
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
                  if (currentState === 'initial' || currentState === 'awaiting_architecture_confirmation') {
                      appendMessage(data.response, false, true);
                  } else {
                      appendMessage(data.response, false, false);
                  }
                  if (data.prompt) {
                      appendMessage(data.prompt, false);
                  }
                  currentState = data.nextState;
                  architecture = data.architecture || architecture;
                  improvements = data.improvements || improvements;
                  terraformCode = data.terraformCode || terraformCode;
                  feedback = data.feedback || feedback;
                  if (currentState === 'offer_download') {
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
                body: JSON.stringify({message: 'yes', terraformCode: currentTerraformCode})
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
        const actionsContainer = document.getElementById('actions-container'); 
        actionsContainer.appendChild(downloadButton); 
    }


    sendButton.onclick = sendMessage;

    messageInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            sendMessage();
        }
    });
});
