
import threading
import datetime
import sys
import hashlib
import time 
import socket
import rsa
import os.path
from pathlib import Path

from ecdsa import VerifyingKey, BadSignatureError
CertPath = str(Path(os.path.dirname(os.path.abspath(__file__))).parent) + "\\Certificate\\CA\\" ;

vk = VerifyingKey.from_pem(open("PublicKeyECDSA.pem").read())

# with 4 hardcoded nodes no random 


class PKQThread (threading.Thread):
   def __init__(self, threadID, serverAddressPort, bytesToSend, name, counter):
      threading.Thread.__init__(self)
      self.threadID = threadID
      self.name = name
      self.counter = counter
      self.serverAddressPort = serverAddressPort
      self.bytesToSend = bytesToSend
      self.message = b''
      self.messageString = ''
      self.signature = b''

   def run(self):
        bufferSize          = 2048;
        UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM);
        UDPClientSocket.sendto(self.bytesToSend, self.serverAddressPort);
        msgFromServer = UDPClientSocket.recvfrom(bufferSize);
        #msg = "Reponse to PKQuery {}".format(msgFromServer[0].decode("utf-8"));
        #print(msg);
        #self.message = format(msgFromServer[0].decode("utf-8"));
        #SHA256 64 bytes
        self.message = msgFromServer[0][:64];
        self.signature = msgFromServer[0][64:];
        #self.messageString = format(msgFromServer[0][:64].decode("utf-8"));
        self.verified = False;
        try:
            vk.verify(self.signature, self.message)
            self.verified = True;
        except BadSignatureError:
            self.verified = False;

def main():

    myHash = input("Please enter the subject : ")
    print(int(round(time.time() * 1000)))
    hash_object = hashlib.sha256(str(myHash.lower()[:256]).encode('utf-8')).hexdigest().upper();
    msgFromClient       = hash_object;
    bytesToSend         = str.encode(msgFromClient);
    serverAddressPortBase   = ("127.0.0.1", 55);

#    serverAddressPort1   = ("192.168.2.145", 55);
    serverAddressPort1   = serverAddressPortBase;
    thread1 = PKQThread(1,serverAddressPort1,bytesToSend, "PKQThread1", 0)
    thread1.start()

    serverAddressPort2   = ("127.0.0.1", 5501);
#    serverAddressPort2   = serverAddressPortBase;
    thread2 = PKQThread(2,serverAddressPort2, bytesToSend, "PKQThread2", 0)
    thread2.start()
    
    serverAddressPort3   = ("127.0.0.1", 5502);
#    serverAddressPort3   = serverAddressPortBase;
    thread3 = PKQThread(3,serverAddressPort3, bytesToSend, "PKQThread3", 0)
    thread3.start()

    serverAddressPort4   = ("127.0.0.1", 5503);
#    serverAddressPort4   = serverAddressPortBase;
    thread4 = PKQThread(4,serverAddressPort4,bytesToSend, "PKQThread4", 0)
    thread4.start()

    thread1.join()
    thread2.join()
    thread3.join()
    thread4.join()

    if ((thread4.message == thread3.message == thread2.message == thread1.message) and thread4.verified and thread3.verified and thread2.verified and thread1.verified):
        print("Verification OK");
        #print(thread1.messageString);
    else:
        print("Verification Failed");
        print(thread1.message);
        print(thread2.message);
        print(thread3.message);
        print(thread4.message);
    print(int(round(time.time() * 1000)))

if __name__ == '__main__':
    main()
while True:
    main()