# app/routes/main_routes.py
from flask import Blueprint, render_template  # Import render_template
from flask_socketio import SocketIO
main = Blueprint('main', __name__)

@main.route('/')
def index():
    return render_template('index.html')