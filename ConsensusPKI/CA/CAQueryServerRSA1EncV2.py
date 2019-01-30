
# ConsensusPKI PKQuery Server

import socketserver
import threading
import datetime
import mysql.connector as mariadb
import datetime
import sys
import hashlib
import time 
import collections
import pickle
import base64
import os.path
from pathlib import Path
from Cryptodome.PublicKey import RSA
from Cryptodome.Signature import PKCS1_v1_5
from Cryptodome.Hash import SHA256
from Cryptodome.Cipher import PKCS1_OAEP

ServerAddress = ("127.0.0.1", 5501);
#from ecdsa import VerifyingKey, BadSignatureError
#vk = VerifyingKey.from_pem(open("PublicKey.pem").read())

CertPath = str(Path(os.path.dirname(os.path.abspath(__file__))).parent) + "\\Certificate\\CA\\" ;

vk = RSA.importKey(open(CertPath + "PublicKeyRSACA1.pem").read())
sk = RSA.importKey(open(CertPath + "PrivateKeyRSACA1.pem").read())
decryptor = PKCS1_OAEP.new(sk);

class PKQueryRequestHandler(socketserver.DatagramRequestHandler):

    def handle(self):
        print("A query received. The Time in milliseconds: "  + str(int(round(time.time() * 1000))));
        datagram = self.request[0]; 
        #print("The message in Ciphertext: ");
        #print(datagram.hex());
        decrypted = decryptor.decrypt(datagram);
        print("The message in plaintext: ");
        print(decrypted);

        clientNonce = decrypted[:16];
        subject = decrypted[16:];

        myQruryString = subject.decode("utf-8");
        #print("The querystring h(subject): " + myQruryString);
        
        #Dont be angry this is just a POC :)
        mariadb_connection = mariadb.connect(user='cuser', password='difficultpass',host='consensuspkidbhost',database='consensuspki');
        
        cursor = mariadb_connection.cursor();
        cursor.execute("select Hash from VW_Response where subject = %s limit 1", (format(myQruryString),));

        mySubjectAndMR = b'';
        for Hash in cursor:
            mySubjectAndMR = format(Hash).replace("'", "").replace(",", "").replace("(", "").replace(")", "").encode();

        myResponse=b'';
        myResponse = hashlib.sha256(clientNonce+mySubjectAndMR).hexdigest().upper().encode();

        #print("The constructed response message: ")
        #print(myResponse);

        responseHash = SHA256.new(data=myResponse);
        signer = PKCS1_v1_5.new(sk)
        signature = signer.sign(responseHash)
           
        self.wfile.write(myResponse+signature);
        #print("End of the response delivery. The Time in milliseconds: "  + str(int(round(time.time() * 1000))));

        

# Create a Server Instance
print (ServerAddress);

            
UDPServerObject = socketserver.ThreadingUDPServer(ServerAddress, PKQueryRequestHandler);
UDPServerObject.serve_forever();

