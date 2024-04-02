import socket
import json
import time

SEND_ADDRESS = "127.0.0.1"
SEND_PORT = 12345
RECV_ADDRESS = "0.0.0.0"
RECV_PORT = 12346

INPUT_ROTATION = True

# Create UDP Socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind((RECV_ADDRESS, RECV_PORT))
sock.setblocking(False)  # Seconds, so that Ctrl-C works.



def handle_packet(packet):
    content = json.loads(packet.decode("utf-8"))
    largest_indicator = [0, 0.0]
    for i, indicator_value in enumerate(content):
        if indicator_value > largest_indicator[1]:
            largest_indicator[0] = i
            largest_indicator[1] = indicator_value
    print("Largest indicator: {}".format(largest_indicator))
    send_inputs(largest_indicator)


def send_inputs(largest_indicator):
    response = {
        "move_forward": 0.0,
        "move_back": 0.0,
        "move_left": 0.0,
        "move_right": 0.0,
        "rotate_cw": 0.0,
        "rotate_ccw": 0.0,
    }

    if largest_indicator[0] in [0, 1, 7]:
        response["move_forward"] = 1.0
    if largest_indicator[0] in [3, 4, 5]:
        response["move_back"] = 1.0
    if largest_indicator[0] in [5, 6, 7]:
        response["move_left"] = 1.0
    if largest_indicator[0] in [1, 2, 3]:
        response["move_right"] = 1.0

    if INPUT_ROTATION:
        if largest_indicator[0] in [1, 5]:
            response["rotate_cw"] = 1.0
        if largest_indicator[0] in [3, 7]:
            response["rotate_ccw"] = 1.0

    print(json.dumps(response))
    sock.sendto(json.dumps(response).encode("utf-8"), (SEND_ADDRESS, SEND_PORT))

    
while True:
    try:
        # Nonblocking socket throws if no data.
        while (True):
            data, addr = sock.recvfrom(1024)
            handle_packet(data)
    except BlockingIOError:
        time.sleep(0.0)
