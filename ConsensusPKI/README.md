# How to run the ConsensusPKI PKQuery simulator on your local environment
Please follow below instructions to run the simulation on your local environment
# Installation
You need to have the consensuspki database up and running on your local PC.
Alternative 1) Use the SQL files in the project under DataModel to create the database with a limited data. If you choose this path, create new certificates using the JCRTandDataGenerator.py script under the certificates. 
Alternative 2) [Dowload full database backup to your local machine 1.7 GB](https://drive.google.com/drive/folders/1xqpO7Aa7t7vnzkzyQmSc-FwYRof_imhE?usp=sharing) and restore it to your local MariaDB server.

1) Download and install MariaDB if you dont have it installed on your PC
2) Install Python preferably 64bit
3) Install following python librarites 
	a) mysql-connector
	b) pycryptodome
	c) pycryptodomex
	d) rsa
	e) ecdsa (if you would like to check ecdsa)
	f) merkletools

3) Add the hosts in the hosts.txt file to your hosts file. For ubuntu it is under /etc/hosts , and for windows it is under c:\Windows\System32\drivers\etc\hosts
4) Restore the downloaded MariaDB backup to your MariaDB server
5) Create a MariaDB User called cuser with password difficultpass and give required permissions on consensuspki database to cuser (if you dont want to update the scripts manually :) )
6) You can now run the servers one by one or simply run startCAServersAndClient.bat under windows (You can also create your own script to run the servers and the client in a single execution if you use another OS)

# An Example Simulation Run
1) On the client application, the simulator asks first a host name; enter www.google.com
2) when it asks enter www.google.com1544532406805CertificateFileWithPublicKeyRSAWithProof.jcrt as the certificate name

Please remember the latest issued certificate is the only valid certificate for a particular subject (for example www.google.com is a subject)
