#!/bin/bash

#sudo yum -y update # update system
sudo yum install -y httpd # install Apache server
sudo systemctl start httpd # start Apache server
sudo systemctl enable httpd # configure to restart Apache upon (re)boot

sudo chown -R $USER:$USER /var/www/html

sudo echo "<html>" > /var/www/html/index.html
sudo echo "<body>" >> /var/www/html/index.html

sudo echo "<h1>Public IP Address: $(curl -s http://ident.me)</h1>"  >> /var/www/html/index.html
sudo echo "<h1>EC2 hostname: $(hostname -f)</h1>"  >> /var/www/html/index.html
sudo echo "<h1>Private IP Address: $(ip route get 1.2.3.4 | awk '{print $7}')</h1>"  >> /var/www/html/index.html
sudo echo "<p>This is the VMSS DEMO.</p>" >> /var/www/html/index.html

sudo echo "</body>" >> /var/www/html/index.html
sudo echo "</html>" >> /var/www/html/index.html
