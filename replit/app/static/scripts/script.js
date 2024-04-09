var socket = io.connect(location.origin);
var awaitingArchitectureConfirmation = false; // Flag for architecture confirmation
var awaitingImprovementConfirmation = false; // New flag for improvement confirmation
var awaitingResponse = false; // Flag for any server response
var awaitingTerraformConfirmation = false;
var awaitingImprovementsConfirmation = false;

document.addEventListener('DOMContentLoaded', (event) => {
    const sendButton = document.getElementById('send-button');
    const messageInput = document.getElementById('message-input');
    const messageContainer = document.getElementById('message-container');

    const appendMessage = (message, isUserMessage = false) => {
        const messageElement = document.createElement('div');
        messageElement.textContent = message;
        if (isUserMessage) {
            messageElement.classList.add('user-message');
        } else {
            messageElement.classList.add('bot-response');
        }
        messageContainer.appendChild(messageElement);
        messageContainer.scrollTop = messageContainer.scrollHeight;
    };

    const sendMessage = () => {
        if (awaitingResponse) return;
        const message = messageInput.value.trim();
        if (message) {
            appendMessage(message, true);
            messageInput.disabled = true;
            sendButton.disabled = true;
            awaitingResponse = true;

            if (awaitingArchitectureConfirmation) {
                sendArchitectureConfirmation(message);
            } else if (awaitingImprovementConfirmation) {
                sendImprovementConfirmation(message); // Handle sending improvement confirmations
            } else if (awaitingTerraformConfirmation) {
                sendTerraformConfirmation(message);
            } else {
                socket.emit('message', message);
            }

            messageInput.value = '';
        }
    };

    sendButton.onclick = sendMessage;

    messageInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            sendMessage();
        }
    });

    socket.on('message_response', (data) => {
        appendMessage(data.response);
        messageInput.disabled = false;
        sendButton.disabled = false;
        awaitingResponse = false;

        if (data.response.includes("Do you confirm this architecture?")) {
            awaitingArchitectureConfirmation = true;
        } else if (data.response.includes("Do you confirm these improvements?")) {
            awaitingImprovementConfirmation = true; // Prepare for improvement confirmation
        } else if (data.response.includes("Do you confirm this Terraform code?")) {
            awaitingTerraformConfirmation = true;
    });
});

function sendArchitectureConfirmation(confirmation) {
    socket.emit('architecture_confirmation', {confirmation: confirmation});
    awaitingArchitectureConfirmation = false;
}

function sendImprovementConfirmation(confirmation) {
    socket.emit('improvement_confirmation', {confirmation: confirmation});
    awaitingImprovementConfirmation = false; // Reset the flag after sending
}

function sendTerraformConfirmation(confirmation) {
    socket.emit('terraform_confirmation', {confirmation: confirmation});
    awaitingTerraformConfirmation = false; // Reset the flag after sending
}
