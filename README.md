# Ghost with Docker Configuration #

## Docker

#### Prerequisitos

Download && install **docker**
- [For Mac](https://download.docker.com/mac/stable/Docker.dmg)
- [For Windows](https://download.docker.com/win/stable/InstallDocker.msi)
- [For Linux](https://docs.docker.com/engine/getstarted/step_one/#docker-for-linux)

Download && install **docker-compose**
- [Instrucciones](https://docs.docker.com/compose/install/)

#### Happy path

Just run:
```
cd docker/production
bash docker.sh up
```

The docker configuration is explained in detail below.

#### Script bash and env vars

Go from console to the `docker / local` folder:
```
cd docker/local
```

In `docker/local` there is a bash script in the` docker.sh` file that can be run like this:
```
./docker.sh parameters
# Or
bash docker.sh parameters  // If you have a different bash shell like oh my zsh
```

There are two files with environment variables to consider:
- `docker/local/.env` # Environment variables needed to run the bash script
- `docker/local/ghost/.env` # Hugo service environment variables

Files with environment variables `.env` are ignored and will be created automatically from the `.env.example` files.

#### Commands

**Notes:**
- Parameters between {} are optionals.
- Service names available: `hugo | node | bower | compass`

The following describes each of the parameters::

**Usage: docker.sh [up|start|restart|stop|rm|sh|bash|logs|ps]**
* `up {service}` --> Run services.
* `start {service}` --> Start services.
* `restart {service}` --> Restart services.
* `stop {service}` --> Stop services.
* `rm {service}` --> Remove services.
* `sh service` --> Connect to "service" shell.
* `bash service` --> Connect to "service" bash shell
* `logs {n_last_lines}` --> Show "service" server logs
* `help` --> Show menu options
