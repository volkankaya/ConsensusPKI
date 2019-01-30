import os
import json
import hashlib
import merkletools
import time
import datetime
import mysql.connector as mariadb
import random

from Cryptodome.Hash import SHA256
from Cryptodome.PublicKey import RSA
from Cryptodome.Signature import PKCS1_v1_5

'''
An example Certificate Validation Request Should be as following

{
"V":"4",
"H":"SHA256",
"VT":"2019-12-25T13:28:06.419Z",
"CN":"www.consensuspki.org",
"PublicKey":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArT0W5w8g+fs6lPnnyVm4\nIP/wjtirkpgp6570dYRUjnibO794VTaz5A6ONjI+yePpEH28PT4VmdEaJhKf9oxX\n85fC0/0aZ38ZBUVCijyvLP3hlqH5a33Q1c9XvcGjVrAuGWT1xa7LyXXS76nvcnKG\nhhkVaU3logo2gDqy+tTYOWD5cHpVoRcVyeRyXJiYpwhQeTJQkHRKlqyASzuOfCaX\nhE/v7BrO5manaX2R58OmKAFDCDxcSitVL1H0/1W7nnZcRhvmhq6PCkJ3+guovDgD\n5xJVvjn7Ro2ywQtxkx8FiluT8XAoL9lwoNCIFi6AL2JNOjXDsM5CoEO5u+OUCyZf\nmQIDAQAB\n-----END PUBLIC KEY-----"
} 

'''



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



    myDomain = input("Step1 Please enter a domainname to generate a certificate: ")

    mytime = str(int(round(time.time() * 1000)));
    randomEvidenceMerkleRoot = hashlib.sha256(mytime.encode()).hexdigest(); #considering evidences collected

    #CertificateKey
    private_key = RSA.generate(2048)
    public_key = private_key.publickey()
    #print(private_key.exportKey(format='PEM'))
    #print(public_key.exportKey(format='PEM'))
    with open ("GeneratedCerts\\" + myDomain + mytime + "PrivateKeyRSA.pem", "w") as prv_file:
        print("{}".format(private_key.exportKey()), file=prv_file)
        prv_file.close();
    with open ("GeneratedCerts\\" + myDomain + mytime + "PublicKeyRSA.pem", "w") as pub_file:
        print("{}".format(public_key.exportKey()), file=pub_file)
        pub_file.close();
        PublicKeyFileName = "GeneratedCerts\\" + myDomain + mytime +"PublicKeyRSA.pem"
        myPublicKeyinJsonFriendlyPem = open(PublicKeyFileName,"r").read().replace('b\'''','').replace('\'''','');
    print("Step2 is finilized: Web key for the certificate is generated");

    #DomainKey
    d_private_key = RSA.generate(2048)
    d_public_key = d_private_key.publickey()
    #print(d_private_key.exportKey(format='PEM'))
    #print(d_public_key.exportKey(format='PEM'))
    with open ("GeneratedCerts\\" + myDomain + mytime + "DomainPrivateKeyRSA.pem", "w") as d_prv_file:
        print("{}".format(d_private_key.exportKey()), file=d_prv_file)
        d_prv_file.close();
    with open ("GeneratedCerts\\" + myDomain + mytime + "DomainPublicKeyRSA.pem", "w") as d_pub_file:
        print("{}".format(d_public_key.exportKey()), file=d_pub_file)
        d_pub_file.close();
    print("Step3 is finilized: Domain key for the CVR is generated");


    myRandomIdentifier       = os.urandom(8).hex() #Random Nonce 8 Bytes
        
    cert = {}
    cert['V'] = '4';
    cert['H'] = 'SHA256';
    cert['VT'] = '2020-12-25T13:28:06.419Z';
    cert['CN'] = myDomain;
    cert['PublicKey'] = myPublicKeyinJsonFriendlyPem;    
    json_data = json.dumps(cert)
    
    certhash = hashlib.sha256(json_data.encode()).hexdigest();
    with open ("GeneratedCerts\\" + myDomain + mytime + "CertificateFileWithPublicKeyRSAUnsigned.jcrt", "w") as jcrt_file:
        print("{}".format(json_data), file=jcrt_file)

    certhash_bytes =bytes(certhash, "utf-8");

    signHash = SHA256.new(data=certhash_bytes);
    signer = PKCS1_v1_5.new(d_private_key);
    signature = signer.sign(signHash);

    cvr = {}
    cvr['C'] = cert;
    cvr['I'] = myRandomIdentifier;
    cvr['S'] = str(signature.hex());

    cvr_json_data = json.dumps(cvr)
    with open ("GeneratedCerts\\" + myDomain + mytime + "CVRFileWithPublicKeyRSASigned.jcrt", "w") as cvr_jcrt_file:
        print("{}".format(cvr_json_data), file=cvr_jcrt_file)

    print("Step4 is finilized: Certificate W/O Proof and Signed CVR are generated");
    print("The Identifier for the APKME and domain publickey locator is: " + myRandomIdentifier );

    mariadb_connection = mariadb.connect(user='cuser', password='difficultpass',host='consensuspkidbhost',database='consensuspki');
    mariadb_connection2 = mariadb.connect(user='cuser', password='difficultpass',host='consensuspkidbhost',database='consensuspki');
    cursor = mariadb_connection.cursor();
    insertCursor = mariadb_connection2.cursor();
    cursor.execute("select random_hash, domain from vw_tmp_random");
    
    print("Step5 is finilized: Random domains are selected");
    
    mt = merkletools.MerkleTools();
    certificateMerkleTree = [];
    myCertificateRandomPosition = (random.randint(1,1023) * 2) ; # in the ConsensusPKI the certificates are placed in the certificates merkle tree based on the lexicographic order of the the hash values of the certificates
    #myCertificateRandomPosition = int(random.randint(1,7) * 2) ; # in the PoC we used the random order to demonstrate the process
    i=0;

    for random_hash, domain in cursor:
        if i == myCertificateRandomPosition:
            certificateMerkleTree.append(certhash);
            certificateMerkleTree.append(randomEvidenceMerkleRoot);
            certificateMerkleTree.append(format(random_hash).replace("'", "").replace(",", "").replace("(", "").replace(")", ""));

            mySubject = calculate_hash( format(domain).replace("'", "").replace(",", "").replace("(", "").replace(")", "").encode() );
            insertCursor.execute("insert into subjects (YEAR,HEIGHT,SUBJECT) values (%s,%s,%s)", ('2020','0',mySubject));

            insertCursor.execute("insert into subjects (YEAR,HEIGHT,SUBJECT) values (%s,%s,%s)", ('2020','0',calculate_hash(myDomain.encode())));
            print("Step6 is finilized: The certificate is placed in the Merkle tree");

        else:
            certificateMerkleTree.append(format(random_hash).replace("'", "").replace(",", "").replace("(", "").replace(")", ""));

            mySubject = calculate_hash( format(domain).replace("'", "").replace(",", "").replace("(", "").replace(")", "").encode() );
            insertCursor.execute("insert into subjects (YEAR,HEIGHT,SUBJECT) values (%s,%s,%s)", ('2020','0',mySubject));

        i = i+1;
    #print(certificateMerkleTree); 
    mt.add_leaf(certificateMerkleTree, False);

    mt.make_tree();
    #print(mt.get_leaf_count());
    root = mt.get_merkle_root();
    print("Step7 is finilized. The merkle tree is constructed. The position of the certificate is: " + str(myCertificateRandomPosition));

    print("Step8 is finilized: Merkle Root of Certificate No: " + str(myCertificateRandomPosition));
    print (root);

    proof = mt.get_proof(myCertificateRandomPosition);
    print("Step 8: the Proof of Certificate No: " + str(myCertificateRandomPosition));
    print(proof);
    
    certWithProof = {}
    certWithProof['C'] = cert;
    certWithProof['P'] = proof;
    json_data_with_proof = json.dumps(certWithProof)
    with open ("GeneratedCerts\\" + myDomain + mytime + "CertificateFileWithPublicKeyRSAWithProof.jcrt", "w") as jcrt_file_with_proof:
        print("{}".format(json_data_with_proof), file=jcrt_file_with_proof)

    #print(int(round(time.time() * 1000)));

    targetHash = mt.get_leaf(myCertificateRandomPosition);
    #print("Targethash");
    #print(targetHash);
    #print("Certhash");
    #print(certhash);

    
    merkleRoot = root;
    print("Step 9 and 10 are finilized: All subjects are inserted into the subjects table");

    insertCursor.execute("insert into certificateblockchain  (Year,Height,PreviousBlockHeader,BlockHeader,MerkleRoot,Nonce,BlockTimestamp)  values (%s,%s,%s,%s,%s,%s,now())", ('2020','0','p','b',root,'1'));
    print("Step 11 is finilized: the record is inserted into the certificateblockchain table");
    print("Step 12: Updating the temporary fields to start PoW");
    insertCursor.execute("update subjects s set height = (select max(height) + 1 from certificateblockchain c where c.year = s.YEAR) where s.year = 2020 and s.height =0")
    insertCursor.execute("update certificateblockchain s set height = (select max(height) + 1 from certificateblockchain c where c.year = s.YEAR) , s.PreviousBlockHeader =  (select BlockHeader from certificateblockchain t where t.year = s.YEAR and t.height = (select max(height) from certificateblockchain z where t.year = z.YEAR)) where s.year = 2020 and s.height =0");
    
    print("Step 12: PoW is Started");
    insertCursor.execute("call PoWCertificateBlockchain(2020,(select max(c.Height) from certificateblockchain c where c.Year = 2020),@nonce, @tstamp, @bheader)");
    insertCursor.execute("update certificateblockchain a set a.Nonce = @nonce, a.BlockTimestamp = @tstamp, a.BlockHeader =@bheader where a.Year= 2020 and a.Height = (select max(c.Height) from certificateblockchain c where c.Year = 2020)");
    print("Step 12 is finilized: PoW is Finilized");
    mariadb_connection2.commit();
    print("Fingerprint of the Certificate No: "  + str(myCertificateRandomPosition));
    print(targetHash);
    print("Step 13 is finilized: The certificate and all related records are generated");


    is_valid = mt.validate_proof(proof, targetHash, merkleRoot);

    #print (is_valid);
    #print (merkleRoot);

    CalculatedMerkelRoot = get_MerkleRootFromProof(targetHash,proof);

    #print (CalculatedMerkelRoot);
    print ("The validation result of the Merkle root in the certificate file");
    print(CalculatedMerkelRoot == root);


if __name__ == '__main__':
    main()
while True:
    main()