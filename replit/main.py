from flask import Flask, render_template, request, jsonify
from flask_socketio import SocketIO, send, emit

if __name__ == '__main__':
# Increase Gunicorn timeout to 60 seconds
  socketio.run(app, debug=True, log_output=True, log_level=logging.DEBUG, worker_class="gevent", timeout=60)