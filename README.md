# ConsensusPKI
ConsensusPKI in a nutshell (for technical people)

ConsensusPKI is an ecosystem-centric proposal for a new PKI infrastructure to be used as a replacement of X.509 PKI.

ConsensusPKI changes the core of the X.509 PKI from “trust” to “not lying.”

A Certificate authority in ConsensusPKI is an entity that never lies.

Using this core principle, the ConsensusPKI solves all known issues that X.509 suffers. [Please refer to my thesis under the documentation for detailed explanation of the flaws](https://github.com/volkankaya/ConsensusPKI/blob/master/ConsensusPKI/Documentation/ConsensusPKI%20-%20Data%20Driven%20Public%20Key%20Ecosystem%20backed%20by%20Blockchain%20and%20Fault%20Tolerance%20-%20Final%20-22-Jan-2019.pdf)

## How it does;
A)	Replaces the local trust store on an end-user system with a chained CA certificate datastore, so that the local CA datastore on the end-user system would be managed by CAs only. Updating local CA certificate data store is managed by Fetch algorithm of the ConsensusPKI.

**What we have with X.509**

Local CA datastore that end users, programs, and administrators can add remove CA certificates that they trust. Integrity check across the CA certificates is not possible.	

**How it is being replaced**

Chained datastore with a flat structure (no hierarchy) complimented by Fetch algorithm so that the local CA certificate data store can be updated by CAs only. You may ask, is there a temper resistance? Although not in the scope, yes there are many ways to achieve that, a trusted platform module TPM is one of it. PKQuery and Fetch are very similar. See PKQuery below for elaboration.

B)	It changes the algorithm that interprets the certificates so that a lying CA would be detected. What is truth and what is a lie? 

**The truth**: only the latest issued certificate is a valid certificate, and everything else is a lie.

**What we have with X.509**

X.509 path building to construct a trusted path. A certificate is not accepted if there is no trusted path. The certificates in X.509 signed by CAs. Signing indicates that CAs properly identified the subjects in the certificates before the certificate is issued.	

**How it is being replaced**

PKQuery uses PBFT to verify certificates and to detect a lying CA.

**Protection against attacks:**

1)	Asymmetric encryption and signing protect message exchanges
2)	H(subject) is used in the query to remedy profiling and to protect the privacy of the end users
3)	The client chooses 4 random CAs to ask the truth. The CAs don’t know the other responding CAs, and their only option is to tell the truth
4)	A client nonce is used during the query. The nonce guarantees that every client receives different truth indicator as a response from the CA
5)	Truth indicator = 
H(ClientNonce + H(H(subject) + MerkleRoot)) 

Item 4 is very important (see [Pass the hash](https://en.wikipedia.org/wiki/Pass_the_hash)). 
C)	Because of item 1 and 2, CAs are obligated to keep the truth.  The CAs need a structure to come to a consensus about the truth. Because there is only one truth for every subject, identification of the subject is crucial. APKME uses 2 theories to properly identify a subject with very high certainty. ZKP based on Bayes rule to increase certainty, and PBFT to detect a lying CA during identification.


**What we have with X.509**

Single email challenge response to identify the subject. For the rest nothing. It is possible to send the same CSR to many CAs and have many certificates issued for the same subject. They will all be considered as a valid certificate.	

**How it is being replaced**

With a blockchain datastore that keeps only the ordered h(subjects) as data. The blockchain datastore is very similar to the CA datastore on the clients. It handles sizing issues with a root blockchain. Data addition to blockchain requires PoW to reach consensus about the truth.

The certificates are bundled together in a MerkleTree (The C field in an issued certificate), and only the Merkle root of the Merkle tree is stored in the blockchain.

The certificate file carries the MerkleProof together with the C field (the certificate itself). Using the certificate file, we can construct a MerkleRoot.

On the client side, first, the Merkle root is calculated using the certificate. Following, the truth indicator is constructed using the ClientNonce, subject and the calculated MerkleRoot.

The calculated truth indicator must be equal to the responses received from the CAs for a certificate to be accepted as valid.  


# I did two things to test my theory. 

1)	Tested the core protocol PKQuery whether it had any known security issue. (including the known response replay attacks) Tamarin did not find any issue. The constraints (why attacks will not be successful) of all security theories can be found in the thesis.
2)	Developed a prototype to test the sizing and time-to-decision on client side whether it would be a bottleneck if it is widely used.

**My tests were successful**, and I can conclude that my model satisfies all of the requirements. [Please refer to my thesis under the documentation for detailed explanation of the requirements](https://github.com/volkankaya/ConsensusPKI/blob/master/ConsensusPKI/Documentation/ConsensusPKI%20-%20Data%20Driven%20Public%20Key%20Ecosystem%20backed%20by%20Blockchain%20and%20Fault%20Tolerance%20-%20Final%20-22-Jan-2019.pdf)

The source code of the tamarin model and the source code of the prototype are also attached to the project.

There are two indicators Why I think the concept of calculation MerkleRoot using the MerkleProof is completely new. 
1)	I did not see in the literature (very weak indicator)
2)	I did not see it any MerkleTree libraries, and I had to write it myself (the code is also included in the thesis and in the python code) (Another weak indicator)

**Please note:** The source code is just for demonstration purposes, do not use for any other purpose.

Regarding the costs:

Banks run bigger clusters of Hardware Security Modules for payment services. It is not too much to expect from all CAs to invest in 60 HSM boxes, to guarantee the throughput to serve internet as a whole.  Personally, CAs have at the moment a very lucrative business model. With a single HSM, they can just sing certificates which will be accepted as valid. The consequences of their wrong actions, on the contrary, have very big impact. [Check Diginotar case](https://en.wikipedia.org/wiki/DigiNotar) 

# What is next

let's discuss, test, attack and try to falsify my theory :) 
