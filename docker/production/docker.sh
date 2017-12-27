#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`

# Utils functions
. $SCRIPTPATH/../utils.sh

# Create envs vars if don't exist
ENV_FILES=(".env" "nginx/site.template" "nginx/site.template.ssl" "nginx/.env" "nginx/nginx.conf" "nginx/renewssl.sh" "nginx/crontab" "ghost/.env" "mysql/.env")
utils.check_envs_files "${ENV_FILES[@]}"

# Load environment vars, to use from console, run follow command:
utils.load_environment

# Menu options
if [[ "$1" == "deploy" ]]; then
    # Build && start services
    utils.printer "Build && start services"
    docker-compose up -d ghost
    docker-compose restart ghost
elif [[ "$1" == "server.up" ]]; then
    if [[ "$2" == "secure" ]]; then
        utils.printer "Set nginx service renewssl vars..."
        utils.nginx_renewssl_vars
        utils.printer "Settting default.conf based on site.template.ssl..."
        cp nginx/site.template.ssl nginx/default.conf
        utils.printer "Stopping nginx machine if it's running..."
        docker-compose stop nginx
        utils.printer "Creating letsencrypt certifications files..."
        docker-compose up certbot
        utils.printer "Setting up cron job for auto renew ssl..."
        CRONPATH=/opt/crons/${COMPOSE_PROJECT_NAME}
        mkdir -p $CRONPATH
        cp nginx/renewssl.sh $CRONPATH/renewssl.sh
        chmod +x $CRONPATH/renewssl.sh
        touch $CRONPATH/renewssl.logs
        cp nginx/crontab $CRONPATH/crontab
        crontab $CRONPATH/crontab
    else
        utils.printer "Settting default.conf based on site.template..."
        cp nginx/site.template nginx/default.conf
    fi
    utils.printer "Starting nginx machine..."
    docker-compose build nginx
    docker-compose up -d nginx
    docker-compose restart nginx
elif [[ "$1" == "up" ]]; then
    # Build && start ghost service
    bash docker.sh deploy
    # Set server configuration
    bash docker.sh server.up $2
elif [[ "$1" == "start" ]]; then
    utils.printer "Start services"
    docker-compose start $2
elif [[ "$1" == "restart" ]]; then
    utils.printer "Restart services"
    docker-compose restart $2
elif [[ "$1" == "stop" ]]; then
    utils.printer "Stop services"
    docker-compose stop $2
elif [[ "$1" == "rm" ]]; then
    utils.printer "Stop && remove all services"
    docker-compose stop $2
    docker-compose rm $2
elif [[ "$1" == "bash" ]]; then
    if [[ ! -z "$2" ]]; then
        utils.printer "Connect to $2 bash shell"
        docker-compose exec $2 bash
    else
        utils.printer "You should specify the service name"
    fi
elif [[ "$1" == "sh" ]]; then
    if [[ ! -z "$2" ]]; then
        utils.printer "Connect to $2 bash shell"
        docker-compose exec $2 sh
    else
        utils.printer "You should specify the service name"
    fi
elif [[ "$1" == "logs" ]]; then
    if [[ ! -z "$2" ]]; then
        utils.printer "Showing logs..."
        if [[ -z "$3" ]]; then
            docker-compose logs -f $2
        else
            docker-compose logs -f --tail=$3 $2
        fi
    else
        utils.printer "You should specify the service name"
    fi
elif [[ "$1" == "ps" ]]; then
    utils.printer "Show all running containers"
    docker-compose ps
else
    utils.printer "Params between {} are optional, except {}*"
    utils.printer "Service names: ghost | mysql | nginx | cerbot"
    utils.printer ""
    utils.printer "Usage: docker.sh [deploy|server.up|up|start|restart|stop|rm|sh|bash|logs|machine.[details|create|start|restart|stop|rm|ssh]]"
    echo -e "deploy                          --> Build and run services"
    echo -e "server.up {secure}              --> Build and run server (nginx) services; \"secure\" parameter is optional for ssl configuration"
    echo -e "up {secure}                     --> Build && deploy services; \"secure\" parameter is optional for ssl configuration"
    echo -e "start {service}                 --> Start services"
    echo -e "restart {service}               --> Restart services"
    echo -e "stop {service}                  --> Stop services"
    echo -e "rm {service}                    --> Stop && remove services"
    echo -e "sh {service}*                   --> Connect to \"service\" shell"
    echo -e "bash {service}*                 --> Connect to \"service\" bash shell"
    echo -e "logs {service}* {n_last_lines}  --> Show \"service\" server logs"
    echo -e "ps                              --> Show all running containers"
fi