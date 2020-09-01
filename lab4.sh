#!/bin/bash
echo "
Learning Objectives
check_circle
Verify the Self-Signed Certificate for the NGINX Server
First, we'll need to become the root user:

sudo su -
Let's verify that the X509 certificate was correctly generated using the openssl verify command:

openssl verify -CAfile /etc/nginx/ssl/bigstatecollege.edu/ca-cert.pem /etc/nginx/ssl/bigstatecollege.edu/server-cert.pem
We should see the following:
server-cert.pem: OK

check_circle
Configure the Virtual Host to Use HTTPS
Configure the bigstatecollege.edu virtual host to use HTTPS:

cd /etc/nginx/sites-available
vi bigstatecollege.edu.conf
Change the listen line from port 80 to 443, and add ssl after 443:

listen 443 ssl;

Add the following lines after the server_name configuration line:

        ssl_certificate /etc/nginx/ssl/bigstatecollege.edu/server-cert.pem;
        ssl_certificate_key /etc/nginx/ssl/bigstatecollege.edu/server-key.pem;
Save and exit.

check_circle
Validate HTTPS
Validate and reload NGINX:

nginx -t
systemctl reload nginx
Test the new HTTPS connection. We will need to use the --insecure switch in order to accept the self-signed certificate:

curl --insecure https://www.bigstatecollege.edu
We should see Welcome to www.bigstatecollege.edu!.

Congratulations! The virtual host for bigstatecollege.edu is now configured to use HTTPS.

check_circle
Configure Load Balancing on the Virtual Host
There's already an upstream group configured in the bigstatecollege.edu virtual host. Remove the backup status from app2 and app3. This will make them live. Edit the bigstatecollege.edu.conf file:

vi bigstatecollege.edu.conf
The end result should look like the following:

upstream bscapp  {
   server app1.bigstatecollege.edu:8085;
   server app2.bigstatecollege.edu:8086;
   server app3.bigstatecollege.edu:8087;
}
Save and exit.

check_circle
Test Load Balancing on the Virtual Host
Validate and reload NGINX:

nginx -t
systemctl reload nginx
Test the new configuration for https://www.bigstatecollege.edu/app:

curl --insecure https://www.bigstatecollege.edu/app
Reload the command several times. We should see Welcome to app1.bigstatecollege.edu!.

check_circle
Restrict Access By IP Address
We're going to restrict the bigstatecollege.edu virtual host to the 127.0.0.1 interface. Add the following lines after the listen 443; line in the bigstatecollege.edu.conf file:

        allow 127.0.0.1;
        deny all;
Save and exit.

check_circle
Test IP Address Restriction
Validate and reload NGINX:

nginx -t
systemctl reload nginx
Test the new configuration for https://www.bigstatecollege.edu:

curl --insecure https://www.bigstatecollege.edu
Access is forbidden via the private IP address. Try to access the virtual host via localhost:

curl --insecure -H "www.bigstatecollege.edu" https://localhost
We should see Welcome to www.bigstatecollege.edu!.
"
