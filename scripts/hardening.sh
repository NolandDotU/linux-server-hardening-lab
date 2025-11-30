echo "--- 1. Updating System ---"
sudo apt update && sudo apt upgrade -y

echo "--- 2. Installing Dependencies (Apache2, UFW, Fail2Ban) ---"
sudo apt install apache2 ufw fail2ban libapache2-mod-security2 -y

echo "--- 3. Configuring Firewall (UFW) ---"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default ssh
sudo ufw default 80/tcp
sudo ufw default 443/tcp
echo "y" | sudo ufw enable

echo "--- 4. SSH Hardening ---"
#Backup config asli
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
#Disable Root Login & Password Auth (Pastikan sudah setup SSH Key sebelumnya)
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
#Opsional: sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "--- 5. Setup Apache TLS (Self-Signed for Lab ---"
sudo a2enmod ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/apache-selfsigned.key \
	-out /etc/ssl/certs/apache-selfsigned.crt \
	-subj "/C=ID/ST=JawaTengah/L=Semarang/O=IT/CN=Localhost"

# Config Apache untuk pakai certif yang baru
sudo tee /etc/apache2/sites-available/default-ssl.conf > /dev/null <<EOT
<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerAdmin webmaster@localhost
		DocumentRoot /var/www/html
		SSLEngine on
		SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
		SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
	</VirtualHost>
</IfModule>
EOT

sudo a2ensite default-ssl.conf
sudo systemctl reload apache2

echo "--- DONE. Check logs at /var/log/auth.log ---"
