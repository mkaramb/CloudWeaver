# __init__.py

from flask import Flask, render_template
from flask_socketio import SocketIO
from .sockets.chat_sockets import handle_connect, handle_message, handle_architecture_confirmation, handle_terraform_confirmation

def register_sockets(socketio):
    socketio.on_event('connect', handle_connect)
    socketio.on_event('message', handle_message)
    socketio.on_event('architecture_confirmation', handle_architecture_confirmation)
    socketio.on_event('terraform_confirmation', handle_terraform_confirmation)

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'secret!'
    socketio = SocketIO(app)

    register_sockets(socketio)

    @app.route('/')
    def index():
        return render_template('chat.html')

    return app, socketio
