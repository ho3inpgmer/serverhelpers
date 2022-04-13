#!/bin/bash
#
# Bash script for delete a subdomain config file and its folder (nginx)

# Functions
ok() { echo -e '\e[32m'$1'\e[m'; } # Green
die() { echo -e '\e[1;31m'$1'\e[m'; exit 1; }

# Variable definitions.
NGINX_AVAILABLE_VHOSTS='/etc/nginx/sites-available'
NGINX_ENABLED_VHOSTS='/etc/nginx/sites-enabled'
WEB_DIR='/var/www'
NGINX_SCHEME='$scheme'
NGINX_REQUEST_URI='$request_uri'

# Sanity check.
[ $(id -g) != "0" ] && die "Script must be running as root."
[ $# != "1" ] && die "Usage: $(basename $0) subDomainName"

ok "Deleting subdomain $1 ..."

# Delete Subdomain directory.
rm -rf $WEB_DIR/$1

# Delete Subdomain symbolic link.
rm $NGINX_AVAILABLE_VHOSTS/$1
rm $NGINX_ENABLED_VHOSTS/$1

# Restart the Nginx server.
read -p "A restart to Nginx is required for the subdomain to be deleted. Do you wish to restart nginx? (y/n): " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
  /etc/init.d/nginx restart;
fi

ok "Subdomain is deleted for $1"
