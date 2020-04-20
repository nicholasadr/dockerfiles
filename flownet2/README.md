Dockerfile for https://github.com/sampepose/flownet2-tf

# Instructions

1. Clone this repository

   `git clone https://github.com/nicholasadr/dockerfiles.git`

2. Modify .env

     ```
     cd dockerfiles/flownet2/
     cat .env
     ```

   Variables:
   (Note: This docker implementation allows you to mimic the user in your host machine into the container. This is helpful to avoid file permission related issues when editing files between host and container. To do so, you have to edit dUSER, dGROUP, dUID and dGID to replicate the corresponding values in your host machine.)
   * dUSER: You can obtain your username with the terminal command `whoami`.
   * dGROUP: Similar to the username above.
   * dUID: You can obtain your UID with the terminal command `id -u <username>`.
   * dGID: You can obtain your GID with the temrinal command `id -g <username>`.
   * dDRIVE: Disk location containing dataset in host to be mounted to docker container. The dataset will be accessible from the container.
   * dWORKSPACE: Path to your development workspace in host machine. The workspace will be accesible from the container.

3. Build and run container

   `bash run_docker.sh`

## Helpful commands

To start another bash terminal:
`docker-compose exec flownet /bin/bash`

To stop container:
`docker-compose down`

## Note on COMPOSE_PROJECT_NAME
The run_docker.sh script automatically generates a project name unique to your username, date and time of script call. This is to avoid overwriting another container from the same image. When you run a docker-compose command e.g. `docker-compose down`, docker will use the current COMPOSE_PROJECT_NAME value in .env file as the active project name and your command will be run accordingly. Make sure to change the value if you would like to run your command under different project name.
