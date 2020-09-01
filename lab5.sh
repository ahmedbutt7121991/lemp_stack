#!/bin/bash
echo "
Learning Objectives
check_circle
===================================================
Configure the Logging Location for the Virtual Host
===================================================
Become the root user:

sudo su -
Edit the bigstatecollege.edu.conf file:

cd /etc/nginx/sites-available
vi bigstatecollege.edu.conf
After the server_name line, add the following:

        access_log /var/log/nginx/bigstatecollege.edu_access.log;
        error_log /var/log/nginx/bigstatecollege.edu_error.log;
Save and exit.

check_circle
Test the New Logging Location for the Virtual Host
Validate / reload NGINX:

nginx -t
systemctl reload nginx
Test the new configuration:

curl --insecure https://www.bigstatecollege.edu
ls -al /var/log/nginx/
We should see the new logs. Take a look at the contents of the new access log:

cat /var/log/nginx/bigstatecollege.edu_access.log
Access the virtual host several more times. Access a file that doesn't exist, then take a look at the contents of the log again.

check_circle
Configure the Error Logging Level for the Virtual Host
We're going to set the error logs to the debug level, the most verbose:

vi bigstatecollege.edu.conf
On the error_log line, add debug:

error_log /var/log/nginx/bigstatecollege.edu_error.log debug;
Save and exit.

check_circle
Test the Error Logging Level for the Virtual Host
Validate / reload NGINX:

nginx -t
systemctl reload nginx
Test the new configuration:

curl --insecure https://www.bigstatecollege.edu
curl --insecure https://www.bigstatecollege.edu/foo.txt
Let's see what we generated in the new error log:

cat /var/log/nginx/bigstatecollege.edu_error.log
We'll see there's more detail in there.

check_circle
Configure the Access Log to Use the 'custom' Format
Edit the virtual host configuration file:

vi bigstatecollege.edu.conf
On the access_log line, add the following:

access_log /var/log/nginx/bigstatecollege.edu_access.log custom;
Save and exit.

We will need to define the custom logging level in the nginx.conf file:

vi ../nginx.conf
check_circle
Configure the 'custom' Access Log Format in nginx.conf
After the error_log line, add the following:

log_format  custom '$remote_addr - $remote_user [$time_local] '
                             '"$request" $status $body_bytes_sent '
                             '"$http_referer" "$http_user_agent" '
                             '"$http_x_forwarded_for" $request_id '
                             '$geoip_country_name $geoip_country_code '
                             '$geoip_region_name $geoip_city ';
Save and exit.

check_circle
Test the 'custom' Access Log Format
Validate and reload NGINX:

nginx -t
systemctl reload nginx
Let's test the new configuration:

curl --insecure https://www.bigstatecollege.edu
curl --insecure https://www.bigstatecollege.edu/foo.txt
Now, let's see what we generated in the new access log:

cat /var/log/nginx/bigstatecollege.edu_access.log
You'll see the format of the access log has changed.

"
