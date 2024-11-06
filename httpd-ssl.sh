#!/bin/bash

# Variables for Key Vault details
KEY_VAULT_NAME="tls-kv-003"
CERT_SECRET_NAME="tlscert-crt"
KEY_SECRET_NAME="tlscert-key"

# Location where Apache expects certificates
CERT_DIR="/etc/ssl/apache2"
CERT_FILE="${CERT_DIR}/apache-cert.crt"
KEY_FILE="${CERT_DIR}/apache-key.key"


sudo yum -y update # update system

# Install Apache if not installed
sudo yum install -y httpd mod_ssl

sudo chown -R $USER:$USER /var/www/html

sudo echo "<html>" > /var/www/html/index.html
sudo echo "<body>" >> /var/www/html/index.html

sudo echo "<h1>Public IP Address: $(curl -s http://ident.me)</h1>"  >> /var/www/html/index.html
sudo echo "<h1>Hostname: $(hostname -f)</h1>"  >> /var/www/html/index.html
sudo echo "<h1>Private IP Address: $(ip route get 1.2.3.4 | awk '{print $7}')</h1>"  >> /var/www/html/index.html
sudo echo "<p>This is the VMSS DEMO.</p>" >> /var/www/html/index.html

sudo echo "</body>" >> /var/www/html/index.html
sudo echo "</html>" >> /var/www/html/index.html

# Create certificate directory
sudo mkdir -p ${CERT_DIR}

# Install Azure CLI to interact with Key Vault (if needed)
# curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
sudo dnf install azure-cli -y

sleep 5

# Login with managed identity
az login --identity

# Fetch certificate and key from Key Vault
CERT_CONTENT=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name $CERT_SECRET_NAME --query value -o tsv)
KEY_CONTENT=$(az keyvault secret show --vault-name $KEY_VAULT_NAME --name $KEY_SECRET_NAME --query value -o tsv)

# Write the certificate and key to files
echo "$CERT_CONTENT" | sudo tee $CERT_FILE
echo "$KEY_CONTENT" | sudo tee $KEY_FILE

# Set correct permissions
sudo chmod 600 $CERT_FILE $KEY_FILE
sudo chown root:root $CERT_FILE $KEY_FILE

# Configure Apache for HTTPS
sudo bash -c 'cat <<EOF > /etc/httpd/conf.d/ssl.conf
Listen 443 https

<VirtualHost *:443>
    ServerName test.clouddays.info
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    DirectoryIndex index.html index.php
    SSLEngine on
    SSLCertificateFile /etc/ssl/apache2/apache-cert.crt
    SSLCertificateKeyFile /etc/ssl/apache2/apache-key.key

    <Directory "/var/www/html">
        AllowOverride All
    </Directory>

    ErrorLog logs/ssl_error_log
    TransferLog logs/ssl_access_log
</VirtualHost>

<VirtualHost *:80>
  ServerName test.clouddays.info
  Redirect / https://test.clouddays.info/
</VirtualHost>  

EOF'

# Enable and start Apache
sudo systemctl enable httpd
sudo systemctl start httpd
