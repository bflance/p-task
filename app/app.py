from flask import Flask
import socket
import os

app = Flask(__name__)

@app.route("/")
def pod_info():
    pod_name = os.getenv("HOSTNAME", "unknown")
    pod_ip = socket.gethostbyname(socket.gethostname())
    return f"Pod Name: {pod_name}<br>Pod IP: {pod_ip}\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)

