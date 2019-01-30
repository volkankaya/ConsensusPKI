
# ConsensusPKI PKQuery Server

import socketserver
import threading
import datetime
import mysql.connector as mariadb
import datetime
import sys
import hashlib
import time 
import os.path
from pathlib import Path

#ECDSA without client nonce (very slow already)

CertPath = str(Path(os.path.dirname(os.path.abspath(__file__))).parent) + "\\Certificate\\CA\\" ;
ServerAddress = ("127.0.0.1", 5501);
from ecdsa import SigningKey
sk = SigningKey.from_pem(open(CertPath + "PrivateKeyECDSA.pem").read())

from ecdsa import VerifyingKey, BadSignatureError
vk = VerifyingKey.from_pem(open(CertPath + "PublicKeyECDSA.pem").read())

class PKQueryRequestHandler(socketserver.DatagramRequestHandler):


    def handle(self):
        datagram = self.rfile.readline().strip();
        
        myQruryString = datagram.decode("utf-8");
        
        #Dont be angry this is just a POC
        mariadb_connection = mariadb.connect(user='cuser', password='difficultpass',host='consensuspkidbhost',database='consensuspki');
        cursor = mariadb_connection.cursor();
        cursor.execute("select Hash from sites where hash = %s", (format(myQruryString),));

        for Hash in cursor:
            
            myResponse = b'';
            myResponse = format(Hash).replace("'", "").replace(",", "").replace("(", "").replace(")", "").encode();
            signature = sk.sign(myResponse)
            self.wfile.write(myResponse+signature);
            

# Create a Server Instance
print (ServerAddress);
            
UDPServerObject = socketserver.ThreadingUDPServer(ServerAddress, PKQueryRequestHandler);
UDPServerObject.serve_forever();

