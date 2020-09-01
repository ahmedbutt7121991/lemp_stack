#!/bin/bash
echo "
Learning Objectives
check_circle
Create an HTTP Virtual Host Configuration
We're going to become the 'root' user.

sudo su -
First, change to the /etc/nginx/sites-available directory so we can add the new virtual host configuration block:

cd /etc/nginx/sites-available
We're going to copy the configuration file related to the virtual host for site3.bigstatecollege.edu:

cp site3.bigstatecollege.edu.conf site4.bigstatecollege.edu.conf
check_circle
Edit the New HTTP Virtual Host Configuration
Edit the configuration file for site4:

vi site4.bigstatecollege.edu.conf
Change the port that the virtual host is listening on to 8081:

listen 8081;
Also, change the site3 entries for the root directory and the server_name to point to site4. Save and exit the new configuration file for site4.bigstatecollege.edu.

check_circle
Activate and Test the New Virtual Host Configuration
Create a soft link in /etc/nginx/sites-enabled to "activate" the configuration:

ln -s /etc/nginx/sites-available/site4.bigstatecollege.edu.conf /etc/nginx/sites-enabled/site4.bigstatecollege.edu.conf 
Validate and restart NGINX:

nginx -t
systemctl reload nginx
Test the virtual host:

curl http://site4.bigstatecollege.edu:8081
We should see the following:

Welcome to site4.bigstatecollege.edu!

check_circle
Explore the Legacy Download Server
There's a download directory for legacy website downloads, and a virtual host (port 8084). We wish to present this directory as http://www.bigstatecollege.edu/downloads/.

ls -la /var/www/download_files
We can get to the file via http://downloads.bigstatecollege.edu:8084/file1:

curl http://downloads.bigstatecollege.edu:8084/file1.txt
check_circle
Create a Rewrite for the Legacy Download Server
Edit the configuration file:

vi bigstatecollege.edu.conf
Add the following section:

        location /downloads {
                rewrite ^(/downloads)/(.*)$ http://downloads.bigstatecollege.edu:8084/$2 permanent;
                return 403;
        }
This will pass the file name in the /downloads part of the URL to the new URL as the second argument ($2).

check_circle
Test the Rewrite
Validate and restart NGINX:

nginx -t
systemctl reload nginx
Test the rewrite:

curl http://www.bigstatecollege.edu/downloads/file1.txt
Retry the request with the new location:

curl -L http://www.bigstatecollege.edu/downloads/file1.txt
To see what's going on behind the scenes, use the '-I' switch with curl:

curl -I http://www.bigstatecollege.edu/downloads/file1.txt
The Location information points to http://downloads.bigstatecollege.edu:8084/file1.txt.

check_circle
View the Custom Error Page
We've provided a custom 404 error page on the lab server that is branded for bigstatecollege.edu. This file is /var/www/html/BSC_404.html.

cat /var/www/html/BSC_404.html
Try accessing a file that doesn't exist with curl:

curl http://www.bigstatecollege.edu/nofile.txt
We will get a generic error page.

check_circle
Configure the Custom Error Page
We will need to configure our custom error page in the bigstatecollege.edu virtual host server configuration file:

vi bigstatecollege.edu.conf
We're going to add a section of code to configure a custom error page for 404 errors:

        error_page 404 /BSC_404.html;
        location = /BSC_404.html {
                root /var/www/html;
                internal;
        }
Save and exit the configuration file.

check_circle
Test the Custom Error Page
Test the NGINX configuration and reload the NGINX service:

nginx -t
systemctl reload nginx
Now, try accessing the file that doesn't exist:

curl http://www.bigstatecollege.edu/nofile.txt
We now see the custom error page.

check_circle
Exploring the Application Servers
Big State College is building an application backend, which they want to proxy under http://www.bigstatecollege.edu/app. The backend application servers are already up and running. We can validate this using curl:

curl http://app1.bigstatecollege.edu:8085
curl http://app2.bigstatecollege.edu:8086
curl http://app3.bigstatecollege.edu:8087
check_circle
Configuring the Upstream Directive for the Application Servers
Define a group of (application) servers using the upstream directive:

vi bigstatecollege.edu.conf
Add the following at the beginning of the configuration file:

upstream bscapp  {
   server app1.bigstatecollege.edu:8085;
   server app2.bigstatecollege.edu:8086 backup;
   server app3.bigstatecollege.edu:8087 backup;
}
Add a location block for the app directory:

        location /app {
                proxy_pass http://bscapp/;
        }
Save and exit the file.

check_circle
Restart NGINX and Test the Upstream
Validate and reload NGINX:

nginx -t
systemctl reload nginx
Test the upstream:

curl http://www.bigstatecollege.edu/app
We will see that the app1.bigstatecollege.edu server is serving requests. The other two servers are backups right now.

check_circle
Mark the app1 Server as Down
Mark the app1 server as down in the upstream configuration, and see if the backup servers take over:

upstream bscapp  {
   server app1.bigstatecollege.edu:8085 down;
   server app2.bigstatecollege.edu:8086 backup;
   server app3.bigstatecollege.edu:8087 backup;
}
Validate and reload NGINX. Test the upstream:

curl http://www.bigstatecollege.edu/app
We will see that NGINX pulls from both the app2 and app3 servers.

check_circle
Enable the app1 Server and Test
Edit the configuration file and remove the down from app1 in the bscapp group:

upstream bscapp  {
   server app1.bigstatecollege.edu:8085;
   server app2.bigstatecollege.edu:8086 backup;
   server app3.bigstatecollege.edu:8087 backup;
}
Save, exit, validate and restart the NGINX service. Test the upstream:

curl http://www.bigstatecollege.edu/app
We should get Welcome to app1.bigstatecollege.edu!. The app2 and app3 servers are only acting as backups.
"
