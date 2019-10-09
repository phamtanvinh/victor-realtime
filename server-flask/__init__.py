import threading
from flask import Flask
from flask_socketio import SocketIO


app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins='*')

counter = 0
timer = 0


@app.route('/', strict_slashes=False)
def index():
    return 'Hello there'


@socketio.on('click')
def handleClick(data):
    print(data)

def handle_stream():
    global timer
    timer += 1
    threading.Timer(1000, handle_stream).start()
    return timer


@socketio.on('connect')
def handle_connect():
    global counter
    counter += 1
    print(f'{counter} New client connected')
    socketio.emit('stream', handle_stream())
    # socketio.send('stream', '???')
