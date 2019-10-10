import threading
import sched
import time
import datetime
from flask import Flask
from flask_socketio import SocketIO

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins='*')

scheduler = sched.scheduler(time.time, time.sleep)

timer = 0


def increase_counter():
    threading.Timer(1, increase_counter).start()
    socketio.emit('getcounter', str(datetime.datetime.now()))


@app.route('/', strict_slashes=False)
def index():
    return 'Hello there'


@socketio.on('hello')
def handle_hello(msg):
    print(msg)


@socketio.on('getcounter')
def handle_get_counter(data):
    print(data)
    increase_counter()
