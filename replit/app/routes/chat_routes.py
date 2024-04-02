# app/routes/chat_routes.py
from flask import Blueprint, request, render_template
from flask_socketio import join_room, leave_room, emit, SocketIO
from ..services.chat_service import test_ai, chat_service_func

chat_bp = Blueprint('chat', __name__)
socketio = SocketIO()

# @socketio.on('connect')
# def handle_connect():
#   print('Client connected')

# @socketio.on('disconnect')
# def handle_disconnect():
#   print('Client disconnected')

# @socketio.on('send_message')
# def handle_message(data):
#   user_input = data['message']
#   response = chat_service_func_test(user_input)
#   emit('receive_message', {'message': response})

@chat_bp.route('/test-ai', methods=['GET'])
def test_ai_route():
  return test_ai()

@chat_bp.route('/chat', methods=['GET'])
def chat_route():
  return chat_service_func();

# Initialize the Flask app with SocketIO
def init_app(app):
  socketio.init_app(app)

  return app