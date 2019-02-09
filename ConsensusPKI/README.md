# How to run the ConsensusPKI PKQuery simulator on your local environment
Please follow the below instructions to simulate your local environment

# Data 
It would be best if you had the consensuspki database up and running on your local PC. You have below alternatives 
1) Use the SQL files in the project under DataModel to create the database with limited data. If you choose this path, create new certificates using the JCRTandDataGenerator.py script under the certificates. 
2) [Dowload full database backup to your local machine 1.7 GB](https://drive.google.com/drive/folders/1xqpO7Aa7t7vnzkzyQmSc-FwYRof_imhE?usp=sharing) and restore it to your local MariaDB server.

# Installation
1) Download and install MariaDB if you don't have it on your PC
2) Install Python (preferably 64bit version)
3) Install the following python libraries 
	3a) mysql-connector
	3b) pycryptodome
	3c) pycryptodomex
	3d) rsa
	3e) ecdsa (if you would like to check ecdsa)
	3f) merkletools
4) Add the hosts in the hosts.txt file to your hosts file. For Ubuntu, it is under /etc/hosts, and for windows, it is under c:\Windows\System32\drivers\etc\hosts
5) Restore the downloaded MariaDB backup to your MariaDB server
6) Create a MariaDB User called user with password difficultpass and gave required permissions on the consensuspki database to cuser (if you don't want to update the scripts manually :) )
7) You can now run the servers one by one or simply run startCAServersAndClient.bat under windows (You can also create your script to run the servers and the client in a single execution if you use another OS)

# An Example Simulation Run
1) On the client application, the simulator asks first a hostname; enter www.google.com
2) when it asks enter www.google.com1544532406805CertificateFileWithPublicKeyRSAWithProof.jcrt as the certificate name

Please remember the latest issued certificate is the only valid certificate for a particular subject (for example www.google.com is a subject)

