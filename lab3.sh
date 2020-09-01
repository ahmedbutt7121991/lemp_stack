#!/bin/bash
echo "
Learning Objectives
check_circle
==========================================================
Create a Certificate Authority Private Key and Certificate
==========================================================
Become root:

sudo su -
Create a directory to store our certificates:

mkdir -p /etc/nginx/certificates
cd /etc/nginx/certificates
Generate a private key for the CA:

openssl genrsa 2048 > ca-key.pem
Generate the X509 certificate for the CA. For this step, just hit Enter for all the questions and use the default answers:

openssl req -new -x509 -nodes -days 365000 \
      -key ca-key.pem -out ca-cert.pem
check_circle
Create a Private Key for the NGINX Server
Generate a private key and create a certificate request for the NGINX server:

openssl req -newkey rsa:2048 -days 365000 \
      -nodes -keyout server-key.pem -out server-req.pem
We will have to answer some questions.

Process the key to remove the passphrase:

openssl rsa -in server-key.pem -out server-key.pem
We should see the following: writing RSA key

check_circle
Create a Self-Signed Certificate for the NGINX Server
Generate a self-signed X509 certificate for the NGINX server:

openssl x509 -req -in server-req.pem -days 365000 \
      -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 \
      -out server-cert.pem
We now have self-signed X509 certificates for the NGINX server in the /etc/nginx/certificates directory.

We need to allow the nginx user access to the certificates. Add read permission for group and other:

chmod 644 *
check_circle
Verify the Self-Signed Certificate for the NGINX Server
Let's use the openssl verify command to verify that the X509 certificate was correctly generated:

openssl verify -CAfile ca-cert.pem server-cert.pem
We should see the following: server-cert.pem: OK
"
