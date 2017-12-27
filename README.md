[![Demo online](https://img.shields.io/badge/live%20demo-online-brightgreen.svg)](https://blog.xergioalex.com/)
[![GitHub issues](https://img.shields.io/github/issues/xergioalex/ghostDocker.svg)](https://github.com/xergioalex/ghostDocker/issues)
[![GitHub forks](https://img.shields.io/github/forks/xergioalex/ghostDocker.svg)](https://github.com/xergioalex/ghostDocker/network)
[![GitHub stars](https://img.shields.io/github/stars/xergioalex/ghostDocker.svg?style=social&label=Star)](https://github.com/xergioalex/ghostDocker/)
[![GitHub followers](https://img.shields.io/github/followers/xergioalex.svg?style=social&label=Follow)]()
[![Twitter XergioAleX](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/xergioalex)


# Ghost docker configuration using nginx and certbot for ssl #

## Docker

#### Prerequisitos

Download && install **docker**
- [For Mac](https://download.docker.com/mac/stable/Docker.dmg)
- [For Windows](https://download.docker.com/win/stable/InstallDocker.msi)
- [For Linux](https://docs.docker.com/engine/getstarted/step_one/#docker-for-linux)

Download && install **docker-compose**
- [Instructions](https://docs.docker.com/compose/install/)

Download && install **docker-machine**
- [Instructions](https://docs.docker.com/machine/install-machine/)


#### Happy path for production in `local machine` environment

Just run:
```
cd docker/production
# without ssl
bash docker.sh up
# with ssl
bash docker.sh up secure
```

#### Happy path for production `remote machine` environment

Just run:
```
cd docker/production
# without ssl
bash docker.machine.sh up
# with ssl
bash docker.machine.sh up secure
```

The docker configuration is explained in detail below.

#### Script bash and env vars

Go from console to the `docker/production` folder:
```
cd docker/production
```

In `docker/production` there is a bash script in the` docker.sh` file that can be run like this:
```
./docker.sh parameters
# Or
bash docker.sh parameters  // If you have a different bash shell like oh my zsh
```

There are serveral files with environment variables or config files to consider:
- `docker/production/.env` # Environment variables needed to run the bash script
- `docker/production/ghost/.env` # Ghost service environment variables
- `docker/production/mysql/.env` # Mysql service environment variables
- `docker/production/nginx/.env` # Nginx service environment variables
- `docker/production/nginx/site.template` # Nginx config site without ssl
- `docker/production/nginx/site.template.ssl` # Nginx config site with ssl

Files with environment variables `.env` and other config files mentioned below are ignored and will be created automatically from the `*.example` files.

#### Commands

**Notes:**
- Params between {} are optional, except {}*.
- Service names available: `Service names: ghost | mysql | nginx | cerbot`

The following describes each of the parameters::

**Usage: docker.sh [up|start|restart|stop|rm|sh|bash|logs|ps]**
* `deploy` --> Build and run services.
* `server.up {secure}` --> Build and run server (nginx) services; "secure" parameter is optional for ssl configuration
* `up {secure}` --> Build && deploy services; "secure" parameter is optional for ssl configuration.
* `start {service}` --> Start services.
* `restart {service}` --> Restart services.
* `stop {service}` --> Stop services.
* `rm {service}` --> Remove services.
* `sh {service}*` --> Connect to "service" shell.
* `bash {service}*` --> Connect to "service" bash shell
* `logs {service}* {n_last_lines}` --> Show "service" server logs
* `machine.[details|create|start|restart|stop|rm|ip|ssh]` --> Machine actions
