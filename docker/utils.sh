#!/bin/bash

# Printer with shell colors
function utils.printer {
	# BASH COLORS
	GREEN=`tput setaf 2`
	RESET=`tput sgr0`
	if [[ ! -z "$2" ]]; then
		# print new line before
    	echo ""
    fi
    echo -e "${GREEN}$1${RESET}"
}


# Create enviroment files if don't exists
function utils.check_envs_files {
	ENV_FILES=("$@")
	for i in "${ENV_FILES[@]}";  do
		if [[ ! -f "$i" ]]; then
			cp "$i.example" "$i"
		fi
	done
}


# Load environment vars in root directory
function utils.load_environment {
	if [[ ! -z $(cat .env | xargs)  ]]; then
	    set -a
		source .env
		set +a
	fi
}


# Set nginx service renewssl vars...
function utils.nginx_renewssl_vars {
	# Setup container service names
	sed -i /NGINX_SERVICE_CONTAINER=/c\NGINX_SERVICE_CONTAINER=${COMPOSE_PROJECT_NAME}_nginx_1 nginx/renewssl.sh
    sed -i /CERTBOT_SERVICE_CONTAINER=/c\CERTBOT_SERVICE_CONTAINER=${COMPOSE_PROJECT_NAME}_certbot_1 nginx/renewssl.sh

    # Setup cron job vars
    sed -i -e "s/COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME}/g" nginx/crontab
}