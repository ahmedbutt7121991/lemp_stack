#!/bin/bash
echo "
==========================
  LEMP STACK INSTALLER  
==========================
========LEMP Installation on RHEL 8
STEP 1: INSTALL NGINX USING THE DEFAULT RHEL PACKAGE REPOSITORIES
=================================================================
=Become the root user:

sudo su -
=Install the NGINX server using yum:

yum -y install nginx
=Enable the NGINX server to start at boot time via systemctl:

systemctl enable nginx
=Before we start NGINX, we want to validate the NGINX configuration:

nginx -t
=Start the NGINX server using systemctl:

systemctl start nginx
=Check the NGINX service status using systemctl:

systemctl status nginx
STEP 2: CONFIGURE HTTP ACCESS THROUGH THE FIREWALL
==================================================
=Check the firewall configuration for the current state using firewall-cmd:

firewall-cmd --info-zone=public
=Allow traffic on port 80 (HTTP) through the firewall:

firewall-cmd --zone=public --add-service=http --permanent
=Reload the new firewall configuration to pick up the change:

firewall-cmd --reload
STEP 3: VERIFY BASIC HTTP FUNCTIONALITY IN NGINX
================================================
=Use curl to verify that the default NGINX web page loads:

curl http://`curl v4.ifconfig.co`
=Use a web browser to go to the default NGINX web page at http://PUBLIC_IP_ADDRESS or http://PUBLIC_DNS_ADDRESS.

=The default NGINX page should be there. The public IP address and DNS of the instance is in /home/cloud_user/server_info.txt.

STEP 4: INSTALL THE PHP COMPONENTS
==================================
=Install the PHP components using yum:

yum -y install php php-pdo php-mysqlnd php-gd php-mbstring php-fpm
=You may notice that php-fpm is already installed. This is not an error, as php-fpm was installed during the creation of the lab environment.

STEP 5: VERIFYING PHP FUNCTIONALITY IN NGINX
============================================
=Load the phpinfo page using curl. Notice that we are specifying a header (using the -H option) so that the proper virtual host is accessed:

curl -H "www.testdomain.local" http://www.testdomain.local/phpinfo.php
=You should see the 'phpinfo' page for this server. If you put your server's public IP address into your /etc/hosts file pointing to www.testdomain.local, you should be able to access the 'phpinfo' page at http://www.testdomain.local/phpinfo.php using a web browser.

STEP 6: INSTALL MARIADB
=======================
=Install MariaDB using yum:

yum -y install mariadb mariadb-server
=Use systemctl to 'enable' and 'start' MariaDB:

systemctl enable mariadb
systemctl start mariadb
=Use systemctl to verify that MariaDB is installed, 'enabled', and 'running':

systemctl status mariadb
STEP 7: VERIFY THE INSTALLED VERSION OF MARIADB
===============================================
=Verify the installed version of MariaDB, using mysql -V:

mysql -V
==============The exact version is not critical here, but we want to confirm it returns a result.
"
echo "
=================
LEMP STACK UBUNTU
===================
LEMP / Ubuntu Linux
===================
Some things that you'll find on Ubuntu Linux LEMP installations:

LEMP stack components are installed using apt-get or apt.
Services are enabled and started when installed via apt-get.
Default NGINX configuration includes the 'sites-enabled' and 'sites-available' directories for virtual host configuration files.
Default document location is /var/www/html
LEMP Installation on Ubuntu Linux
STEP 1: INSTALL NGINX USING THE DEFAULT UBUNTU PACKAGE REPOSITORIES
Become the root user:

sudo su -
Install NGINX from the Ubuntu repositories using apt-get:

apt-get -y install nginx
Check the NGINX service status using systemctl:

systemctl status nginx
The NGINX service should be 'enabled' and 'active'.

STEP 2: CONFIGURE HTTP ACCESS THROUGH THE FIREWALL
Check the initial status of the firewall using ufw:

ufw status
Open port 80 to allow inbound HTTP traffic:

ufw allow 'Nginx HTTP'
Recheck the status of the firewall:

ufw status
STEP 3: VERIFY BASIC HTTP FUNCTIONALITY IN NGINX
Use curl to verify that the default NGINX web page loads:

curl http://`curl v4.ifconfig.co`
Use a web browser to go to the default NGINX web page at http://PUBLIC_IP_ADDRESS or http://PUBLIC_DNS_ADDRESS.

The default NGINX page should be there. The public IP address and DNS of the instance is in /home/cloud_user/server_info.txt.

STEP 4: INSTALL THE PHP COMPONENTS
Install the PHP components using apt-get:

apt-get -y install php-fpm php-mysql
STEP 5: VERIFYING PHP FUNCTIONALITY IN NGINX
In order to test PHP, we will need to enable the www.testdomain.local site. NGINX under Ubuntu accomplishes this by using two directories, the 'sites-available' and the 'sites-enabled' directories. All available server blocks (configuration files for virtual hosts) are placed in 'sites-available'. When you want to make a virtual host active, you create a symbolic link to the appropriate configuration file in 'sites-enabled':

ln -s /etc/nginx/sites-available/testdomain.local.conf /etc/nginx/sites-enabled/testdomain.local.conf
We will now validate the NGINX configuration before reloading the NGINX service, using nginx -t:

nginx -t
If everything checks out, reload the NGINX service:

systemctl reload nginx
If you'd like to check the status of the NGINX service, use systemctl.

systemctl status nginx
We also need to reload the php-fpm service.

systemctl restart php7.2-fpm.service
Verify that PHP is functioning by loading the phpinfo page on the www.testdomain.local virtual host, using the curl command. Note that we are providing a header for the request (via the -H switch) so NGINX knows to route the request to the www.testdomin.local virtual host.

curl -H "www.testdomain.local" http://www.testdomain.local/phpinfo.php
You should see the 'phpinfo' page for this server. If you put your server's public IP address into your /etc/hosts file pointing to www.testdomain.local, you should be able to access the 'phpinfo' page at http://www.testdomain.local/phpinfo.php using a web browser.

STEP 6: INSTALL MARIADB
Install MariaDB using apt-get:

apt-get -y install mariadb-server
Check the status of the MariaDB server using systemctl:

systemctl status mariadb
The server should be 'enabled' and 'running'.

STEP 7: VERIFY THE INSTALLED VERSION OF MARIADB
Verify the installed version of MariaDB, using mysql -V:

mysql -V
The exact version is not critical here, but we want to confirm it returns a result.

Summary
In this lesson, we:

Installed a LEMP stack on Ubuntu Linux
Demonstrated NGINX serving static (HTML / Text) and dynamic (PHP) content
Now that you have a LEMP stack installed and running on Ubuntu, you can proceed with configuring NGINX and MariaDB so you can build your website/application!
"


