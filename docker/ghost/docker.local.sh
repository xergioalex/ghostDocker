# Utils functions
. utils.sh

# Create envs vars if don't exist
ENV_FILES=(".env" "nginx/site.template" "nginx/site.template.ssl" "ghost/config.js")
utils.check_envs_files "${ENV_FILES[@]}"

# Load environment vars, to use from console, run follow command: 
utils.load_environment 

# Menu options
if [[ "$1" == "config" ]]; then
    utils.printer "Set ghost configuration..."
    mkdir -p /opt/ghost/
    cp ghost/config.js /opt/ghost/config.js
elif [[ "$1" == "deploy" ]]; then
    # Build && start ghost service
    bash docker.local.sh config
    utils.printer "Build && start services"
    docker-compose up -d ghost
    docker-compose restart ghost
elif [[ "$1" == "start" ]]; then
    utils.printer "Start services"
    docker-compose start ghost
elif [[ "$1" == "restart" ]]; then
    utils.printer "Restart services"
    docker-compose restart ghost
elif [[ "$1" == "stop" ]]; then
    utils.printer "Stop services"
    docker-compose stop ghost
elif [[ "$1" == "rm" ]]; then
    if [[ "$2" == "all" ]]; then
        utils.printer "Stop && remove ghost service"
        docker-compose rm ghost
    else
        utils.printer "Stop && remove all services"
        docker-compose rm $2
    fi
elif [[ "$1" == "bash" ]]; then
    utils.printer "Connect to ghost bash shell"
    docker-compose exec ghost bash
elif [[ "$1" == "ps" ]]; then
    utils.printer "Show all running containers"
    docker-compose ps
elif [[ "$1" == "logs" ]]; then
    utils.printer "Showing ghost logs..."
    if [[ -z "$2" ]]; then
        docker-compose logs -f --tail=30 ghost
    else
        docker-compose logs -f --tail=$2 ghost
    fi
elif [[ "$1" == "server.config" ]]; then
    utils.printer "Set nginx configuration..."
    mkdir -p /opt/nginx/config/
    cp nginx/site.template /opt/nginx/config/default.conf
    utils.printer "Creating logs files..."
    mkdir -p /opt/nginx/logs/
    touch /opt/nginx/logs/site.access
    touch /opt/nginx/logs/site.error
elif [[ "$1" == "server.start" ]]; then
    utils.printer "Starting nginx machine..."
    docker-compose up -d nginx
    docker-compose restart nginx
elif [[ "$1" == "server.up" ]]; then
    # Set initial configuration in server for nginx
    bash docker.sh server.config
    # Deploying services to remote machine server
    bash docker.sh server.start
elif [[ "$1" == "up" ]]; then
    # Build && start ghost service
    bash docker.sh deploy
    # Set server configuration
    bash docker.sh server.up
else
    utils.printer "Usage: docker.sh [build|up|start|restart|stop|mongo|bash|logs n_last_lines|rm|ps]"
    echo -e "up --> Build && restart ghost service"
    echo -e "start --> Start ghost service"
    echo -e "restart --> Restart ghost service"
    echo -e "stop --> Stop ghost service"
    echo -e "bash --> Connect to ghost service bash shell"
    echo -e "logs n_last_lines --> Show ghost server logs; n_last_lines parameter is optional"
    echo -e "rm --> Stop && remove ghost service"
    echo -e "rm all --> Stop && remove all services"
    echo -e "server.config --> Set nginx configuration service"
    echo -e "deploy --> Build, config && start services"
fi