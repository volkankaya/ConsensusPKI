import threading
import datetime
import sys
import hashlib
import time 
import socket
import mysql.connector as mariadb
import collections
import random
import json
import os
import os.path
from pathlib import Path
from Cryptodome.PublicKey import RSA
from Cryptodome.Signature import PKCS1_v1_5
from Cryptodome.Hash import SHA256
from Cryptodome.Cipher import PKCS1_OAEP

CertPath = str(Path(os.path.dirname(os.path.abspath(__file__))).parent) + "\\Certificate\\GeneratedCerts\\" ;


#The code is a POC, do not use it for production purposes
#load local CA store
mariadb_connection = mariadb.connect(user='cuser', password='difficultpass',host='consensuspkidbhost',database='consensuspki');
cursor = mariadb_connection.cursor();
cursor.execute("select SUBJECT, CACertificate from vw_ca");
CARecords = cursor.fetchall();

CA = collections.deque();
CAIndex = collections.deque();


for CARecord in CARecords:
    singleCert = json.loads (CARecord[1]);
    
    try:
        S = CARecord[0];
        V = singleCert['V'];
        H = singleCert['H'];
        VT = singleCert['VT'];
        CN = singleCert['CN'];
        SP = singleCert['SP'];
        KeyText = singleCert['PublicKey'];
        KeyRSA = RSA.importKey(singleCert['PublicKey']);
        if CAIndex.count(S)==0:
            CA.append([S,V,H,VT,CN,SP,KeyText,KeyRSA]);
            CAIndex.append(S);

    except TypeError:
        print("Cert Parse Error");


class PKQThread (threading.Thread):
   def __init__(self, threadID, serverAddressPort, bytesToSend, CAPublicKey, name, counter):
      threading.Thread.__init__(self)
      self.threadID = threadID
      self.name = name
      self.counter = counter
      self.CAPublicKey = CAPublicKey
      self.serverAddressPort = serverAddressPort
      self.bytesToSend = bytesToSend
      self.message = b''
      self.messageString = ''
      self.signature = b''
      self.verified = False;
   def run(self):
        bufferSize          = 4096;
        UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM);
        
        encryptor = PKCS1_OAEP.new(self.CAPublicKey);
        encrypted = encryptor.encrypt(self.bytesToSend);
        #encrypted = encryptor.encrypt(self.bytesToSend.encode());
        #print ('Ciphertext Start');
        #print (encrypted.hex().upper());
        #print ('End');
        UDPClientSocket.sendto(encrypted, self.serverAddressPort);
        msgFromServer = UDPClientSocket.recvfrom(bufferSize);
        self.message = msgFromServer[0][:64];
        self.signature = msgFromServer[0][64:];
        #print(self.signature.hex().upper())
        self.messageString = format(msgFromServer[0][:64].decode("utf-8"));
        responseHash = SHA256.new(data=self.message);
        self.verified = False;
        
        try:
            verified = False;
            verifier = PKCS1_v1_5.new(self.CAPublicKey);
            verified = verifier.verify(responseHash, self.signature);    
            self.verified = verified;
        except ValueError:
            self.verified = False;

def calculate_hash(binaryValueToHash):
    sha256_digest = hashlib.sha256(binaryValueToHash).hexdigest();
    return sha256_digest;

def get_MerkleRootFromProof(targetHash,proof):
    s1 = json.dumps(proof)
    myInitHash  = targetHash;
    myProofs = json.loads(s1)

    initilized = False;
    myFinalHash = b'';
    for singleProof in myProofs:
        mySibling = '';
        try:
            mySibling = bytearray.fromhex(singleProof['right']);
            if not initilized:
                myFinalHash = calculate_hash(bytearray.fromhex(myInitHash) + mySibling);
                initilized = True;
            else:
                myFinalHash = calculate_hash(bytearray.fromhex(myFinalHash) + mySibling);
        except KeyError:
            mySibling = bytearray.fromhex(singleProof['left']);
            if not initilized:
                myFinalHash = calculate_hash(mySibling + bytearray.fromhex(myInitHash));
                initilized = True;
            else:
                myFinalHash = calculate_hash(mySibling + bytearray.fromhex(myFinalHash));
    return myFinalHash;
def main():

    mySubjectOpen = input("Please Enter The Subject : ")
    myCertFileInput = input("Please Enter Certificate Filename : ")
    print("PKQuery check is started. The time in milliseconds: " + str(int(round(time.time() * 1000))));
    myCertFile = CertPath + myCertFileInput;
    myCert = open(myCertFile,"r").read();
    singleCert = json.loads (myCert);


    try:
        cert = singleCert['C'];
        json_cert = json.dumps(cert);
        certhash = hashlib.sha256(json_cert.encode()).hexdigest();
        proof = singleCert['P'];
        #json_proof = json.dumps(cert); 
        root = get_MerkleRootFromProof (certhash,proof);
        #print (root);
    except KeyError:
        print("Certificate Parse Error");

    myHSubject = hashlib.sha256(str(mySubjectOpen.lower()[:256]).encode('utf-8')).hexdigest().upper();

    myHSubjectBin = hashlib.sha256(str(mySubjectOpen.lower()[:256]).encode('utf-8')).hexdigest();
    myHSubjectBin_bytes = bytes(myHSubjectBin, "utf-8");
    MRoot_bytes = bytes(root, "utf-8");

    myHSubjectBinMRoot_bytes = myHSubjectBin_bytes.hex() + MRoot_bytes.hex();

    myHSubjectandMR = hashlib.sha256();
    myHSubjectandMR.update (myHSubjectBinMRoot_bytes.encode());
    myExpectedResponseHHSubjectMR = myHSubjectandMR.hexdigest();
    
    print ('h(subject) + MR from Certificate :' + myExpectedResponseHHSubjectMR.upper());

    myClientNonce       = os.urandom(8).hex() #Random Nonce 8 Bytes

    myExpectedResponseNonceHHSubjectMR_bytes = bytes(myClientNonce, "utf-8") + bytes(myExpectedResponseHHSubjectMR.upper(), "utf-8");

    myExpectedResponseNonceHHSubjectMR = hashlib.sha256(myExpectedResponseNonceHHSubjectMR_bytes);
    ExpectedResponse = myExpectedResponseNonceHHSubjectMR.hexdigest().upper();
    
    print ("The HSubject: " +  myHSubject);
    print ("Randomly selected client nonce: " + myClientNonce);    
    print ("The expected response calculated using the proof in the certificate: " + ExpectedResponse );

    print("The start of the PKQuery threads. The time in milliseconds: " + str(int(round(time.time() * 1000))));
    
    msgFromClient       = myClientNonce.encode() + myHSubject.encode();
    bytesToSend         = msgFromClient;
    
    RandomCAs = random.sample(CA, 4);
    i=1;
    threads = collections.deque();
    print("Thread start. The time in milliseconds: " + str(int(round(time.time() * 1000))));
    for RandomCA in RandomCAs:
        serverAddressPortBase   = (RandomCA[0], RandomCA[5]);
        threads.append( PKQThread(i,serverAddressPortBase,bytesToSend,RandomCA[7], "PKQThread" + RandomCA[0], 0));
        i=i+1;
    for thread in threads:
        thread.start();
    print("Thread start finished. The time in milliseconds: " + str(int(round(time.time() * 1000))));

    for thread in threads:
        thread.join();

    print("The end of the PKQuery threads. The time in milliseconds: " + str(int(round(time.time() * 1000))));
    print("The start of the validation checks. The time in milliseconds: " + str(int(round(time.time() * 1000))));
    Verification = collections.deque();
    SignatureFailedCAs = collections.deque();
    CAResponses = collections.deque();
    CAResponseStrings = collections.deque();
    NonHonestCAs = collections.deque();

    x='';
    y='';
    z='';
    w='';
    i=1;
    for thread in threads:
        print(thread.messageString);
        if i==1:
            x=thread.messageString;
            i=i+1;
        elif i==2:
            y=thread.messageString;
            i=i+1;
        elif i==3:
            z=thread.messageString;
            i=i+1;
        else:
            w=thread.messageString;

        CAResponses.append([thread.messageString,thread.serverAddressPort,thread.message,thread.signature]);
        CAResponseStrings.append(thread.messageString);
        Verification.append(thread.verified);
        if not thread.verified:
            SignatureFailedCAs.append([thread.serverAddressPort,thread.message,thread.signature]);

    multiple = False;
    FaultyResponse ='';
    AcceptedResponse ='';

    if (Verification.count(True) == 4):
        print("Signature Verifications are OK. The time in milliseconds: " + str(int(round(time.time() * 1000))));
    else:
        print("Missing Signature Verifications. The time in milliseconds: " + str(int(round(time.time() * 1000))));
        print(SignatureFailedCAs);

    if x==y==z==w:
        print("All Responses are equal.");
        AcceptedResponse = x;
        FaultyResponse = '';
    else:
        print("All Responses are not equal.");

        countResponseX = CAResponseStrings.count(x);
        countResponseY = CAResponseStrings.count(y);
        countResponseZ = CAResponseStrings.count(z);
        countResponseW = CAResponseStrings.count(w);
        
    
        if countResponseX <= 2 and countResponseY <=2 and countResponseZ <= 2 and countResponseW <=2:
            print("Multiple Non Honest CA Detected connection is not secure");
            multiple = True;
        else:
            print("Non Honest CA Detected.");
            if countResponseX ==1:
                FaultyResponse = x;
                AcceptedResponse = y;
            elif countResponseY ==1:
                FaultyResponse = y;
                AcceptedResponse = x;
            elif countResponseZ ==1:
                FaultyResponse = z;
                AcceptedResponse = x;
            elif countResponseW ==1:
                FaultyResponse = w;
                AcceptedResponse = x;

        for CAResponse in CAResponses:
            if multiple:
               NonHonestCAs.append([bytesToSend, CAResponse[0],CAResponse[1],CAResponse[2],CAResponse[3]]);
            else:
                if CAResponse[0] == FaultyResponse:
                    NonHonestCAs.append([bytesToSend, CAResponse[0],CAResponse[1],CAResponse[2],CAResponse[3]]);

        print("Non-Honest-CAs and Exchanged Messages:");
        print(NonHonestCAs);

    if AcceptedResponse==ExpectedResponse:
        print("Connection is secure Certificate matches the Accepted response : " + AcceptedResponse);
        if FaultyResponse != '':
            print("Detected Faulty response : " + FaultyResponse);
    else:
        if multiple:
            print("There is no Consensus among the CAs");
        else:
            print("Connection is Not secure Cert does not matches the response. The Accepted response from the CAs : " + AcceptedResponse);
            print("The Expected response from the Certificate: " + ExpectedResponse);
            if FaultyResponse != '':
                print("Detected Faulty response : " + FaultyResponse);

    print("The PKQuery check is finilized. The time in milliseconds: " + str(int(round(time.time() * 1000))));

if __name__ == '__main__':
    main()
while True:
    main()