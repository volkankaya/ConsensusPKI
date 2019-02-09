# How to run the ConsensusPKI PKQuery simulator on your local environment
Please follow the below instructions to simulate your local environment

# Data 
It would be best if you had the consensuspki database up and running on your local PC. You have below alternatives 
1) Use the SQL files in the project under DataModel to create the database with limited data. If you choose this path, create new certificates using the JCRTandDataGenerator.py script under the certificates. 
2) [Dowload full database backup to your local machine 1.7 GB](https://drive.google.com/drive/folders/1xqpO7Aa7t7vnzkzyQmSc-FwYRof_imhE?usp=sharing) and restore it to your local MariaDB server.

# Installation
<ol>
<li>Download and install MariaDB if you don't have it on your PC</li>
<li>Install Python (preferably 64bit version)</li>
<li>Install the following python libraries using "pip install library_name"
<ol>
  <li>mysql-connector</li>
  <li>pycryptodome</li>
  <li>pycryptodomex</li>
  <li>rsa</li>
  <li>ecdsa (if you would like to check ecdsa)</li>
  <li>merkletools</li>
</ol></li>
<li>Add the hosts in the hosts.txt file to your hosts file. For Ubuntu, it is under /etc/hosts, and for windows, it is under c:\Windows\System32\drivers\etc\hosts</li>
<li>Restore the downloaded MariaDB backup to your MariaDB server</li>
<li>Create a MariaDB User called user with password difficultpass and gave required permissions on the consensuspki database to cuser (if you don't want to update the scripts manually :) )</li>
<li>You can now run the servers one by one or simply run startCAServersAndClient.bat under windows (You can also create your script to run the servers and the client in a single execution if you use another OS)</li>
</ol>
# An Example Simulation Run
1) On the client application, the simulator asks first a hostname; enter www.google.com
2) when it asks enter www.google.com1544532406805CertificateFileWithPublicKeyRSAWithProof.jcrt as the certificate name

Please remember the latest issued certificate is the only valid certificate for a particular subject (for example www.google.com is a subject)

