# sockets/chat_sockets.py

from flask_socketio import SocketIO, emit
from flask import request
from ..services.chat_service import generate_architecture, generate_terraform_code, suggest_improvements

user_states = {}
user_architectures = {}
terraform_code = {}
architecture_improvements = {}

@socketio.on('connect')
def handle_connect():
  print("Client connected")
  # Initialize user state
  request_sid = request.sid
  user_states[request_sid] = 'awaiting_project_description'
  emit('message_response', {'response': "Please provide your project description."})

@socketio.on('message')
def handle_message(message):
  request_sid = request.sid
  if request_sid not in user_states:
    print(f"User state for SID {request_sid} not found.")
    return
  try:
    if user_states[request_sid] == 'awaiting_project_description':
      project_description = message
      architecture = generate_architecture(project_description)
      print("got to this step 1")
      user_architectures[request_sid] = architecture
      response_text = f"Architecture generated successfully: {architecture}. Do you confirm this architecture? (Reply 'yes' to confirm or provide feedback.)"
      emit('message_response', {'response': response_text})
      user_states[request_sid] = 'awaiting_architecture_confirmation'
  except Exception as e:
    print(f"Error processing message: {e}")
    emit('message_response', {'response': "Error processing your request."})

@socketio.on('architecture_confirmation')
def handle_architecture_confirmation(data):
  print("got to this step 2")
  request_sid = request.sid
  confirmation = data.get('confirmation', '').lower()

  if request_sid in user_states and user_states[request_sid] == 'awaiting_architecture_confirmation':
      if confirmation == 'yes':
          final_architecture = user_architectures.get(request_sid, 'No architecture found')
          emit('message_response', {'response': f"Architecture confirmed: {final_architecture}"})
          improvements = suggest_improvements(final_architecture)
          architecture_improvements[request_sid] = improvements
          response_text = f"Suggested improvements: {improvements}. Do you confirm these improvements? (Reply 'yes' to confirm or provide feedback.)"
          terraform_code_generated = generate_terraform_code(final_architecture)
          terraform_code[request_sid] = terraform_code_generated
          response_text = f"Terraform code generated successfully: {terraform_code_generated}. Do you confirm this code? (Reply 'yes' to confirm or provide feedback.)"

          emit('message_response', {'response': response_text})
          user_states[request_sid] = 'awaiting_terraform_code_confirmation'
          # user_states[request_sid] = 'awaiting_improvement_confirmation'
      else:
          feedback = data.get('feedback', '')
          emit('message_response', {'response': f"Feedback received: {feedback}. Generating improvements..."})
          # Logic to process feedback and suggest improvements should go here
          user_states[request_sid] = 'awaiting_improvement_confirmation'

@socketio.on('terraform_confirmation')
def handle_terraform_confirmation(data):
    print("got to this step 4")
    request_sid = request.sid
    confirmation = data.get('confirmation', '').lower()
    if request_sid in user_states and user_states[request_sid] == 'awaiting_terraform_confirmation':
      if confirmation == 'yes':
        user_states[request_sid] = 'project_complete'
        print(user_states)
        emit('message_response', {'response': "Project completed."})

@socketio.on('improvement_confirmation')
def handle_improvement_confirmation(data):
  print("got to this step 3")
  request_sid = request.sid
  confirmation = data.get('confirmation', '').lower()

  if request_sid in user_states and user_states[request_sid] == 'awaiting_improvement_confirmation':
      if confirmation == 'yes':
          final_architecture = user_architectures.get(request_sid, 'No architecture found')
          improvements = architecture_improvements.get(request_sid, 'No improvements found')
          final_architecture += "\n\nIncorporated Improvements:\n" + improvements
          user_architectures[request_sid] = final_architecture
          # Assuming you want to emit the final architecture after incorporating improvements
          emit('final_architecture', {'architecture': final_architecture})
      else:
          feedback = data.get('feedback', '')
          emit('message_response', {'response': f"Feedback received: {feedback}. Generating improvements..."})
          # Logic to process feedback and suggest improvements should go here
          user_states[request_sid] = 'awaiting_improvement_confirmation'
