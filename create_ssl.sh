#!/bin/bash
echo "
========================
Creating SSL Certificate
========================

Creating SSL Certificates Using OpenSSL
Lesson Objectives
Create a self-signed SSL certificate using OpenSSL
Verify our self-signed SSL certificate using OpenSSL
Create a Certificate Authority Private Key and Certificate
First, we'll need a place to store our certificates:

mkdir -p /etc/nginx/certificates
cd /etc/nginx/certificates
Generate a private key for the CA:

openssl genrsa 2048 > ca-key.pem
Generate the X509 certificate for the CA:

openssl req -new -x509 -nodes -days 365000 \
      -key ca-key.pem -out ca-cert.pem
Create a Private Key and a Self-Signed Certificate for the NGINX Server
Generate a private key and create a certificate request for the NGINX server. We will have to answer some questions:

openssl req -newkey rsa:2048 -days 365000 \
      -nodes -keyout server-key.pem -out server-req.pem
Next, process the key to remove the passphrase:

openssl rsa -in server-key.pem -out server-key.pem
We should see the following: writing RSA key. Generate a self-signed X509 certificate for the NGINX server from the certificate request:

openssl x509 -req -in server-req.pem -days 365000 \
      -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 \
      -out server-cert.pem
We need to allow the nginx user access to the certificates. Add 'read' permissions for 'group' and 'other':

chmod 644 *
Verify the Self-Signed Certificate for the NGINX Server
Let’s verify that the X509 certificate was correctly generated:

openssl verify -CAfile ca-cert.pem server-cert.pem
We should see the following: server-cert.pem: OK.

"
