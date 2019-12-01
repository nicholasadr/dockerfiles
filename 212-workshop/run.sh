XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker-compose build --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"
docker-compose up -d
docker-compose exec workshop /bin/bash
