import os
import sys
import socket
import json
from awsiot import mqtt_connection_builder
from awscrt import mqtt

# --- CONFIGURATION ---
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def get_path(filename):
    return os.path.join(BASE_DIR, filename)

ENDPOINT = "ak6j5nthu348m-ats.iot.us-east-1.amazonaws.com"
PATH_TO_CERT = get_path("certificate.pem.crt")
PATH_TO_KEY = get_path("private.pem.key")
PATH_TO_ROOT = get_path("AmazonRootCA1.pem")
TOPIC = "sensors/data"

# GODOT CONFIG
GODOT_IP = "127.0.0.1" # Localhost
GODOT_PORT = 4242
udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def on_message_received(topic, payload, **kwargs):
    # Forward the raw JSON string directly to Godot
    message = payload.decode('utf-8')
    print(f"Relaying to Godot: {message}")
    udp_socket.sendto(message.encode(), (GODOT_IP, GODOT_PORT))

# AWS Connection Logic
mqtt_connection = mqtt_connection_builder.mtls_from_path(
    endpoint=ENDPOINT,
    cert_filepath=PATH_TO_CERT,
    pri_key_filepath=PATH_TO_KEY,
    ca_filepath=PATH_TO_ROOT,
    client_id="godot_relay_client",
    clean_session=False,
    keep_alive_secs=30
)

connect_future = mqtt_connection.connect()
connect_future.result()

mqtt_connection.subscribe(topic=TOPIC, qos=mqtt.QoS.AT_LEAST_ONCE, callback=on_message_received)

print(f"Relay Active. Listening to {TOPIC} and sending to port {GODOT_PORT}...")
import threading
threading.Event().wait()