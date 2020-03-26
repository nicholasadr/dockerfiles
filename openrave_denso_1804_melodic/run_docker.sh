#!/bin/bash
SESS="[DOCKER-RUN]"
PROJ="$(grep -i "^COMPOSE_PROJECT_NAME" .env | sed "s/COMPOSE_PROJECT_NAME=//g")"
PROJID=$USER-$(date '+%d%m%Y-%H%M%S')

if [ -z $PROJ ]
then
	echo "$SESS Setting COMPOSE_PROJECT_NAME=$PROJID"
	echo "COMPOSE_PROJECT_NAME=$PROJID" >> .env
else
	if [ -z $1 ]
	then
		echo "$SESS COMPOSE_PROJECT_NAME is already defined in .env file. This might indicate that you have already have an existing container from this image. To proceed nevertheless, use -o to overwrite."
		exit 1
	elif [ $1==-o ]
	then
		echo "$SESS Overwriting COMPOSE_PROJECT_NAME in .env from $PROJ to $PROJID."
		sed -i "s/$PROJ/$PROJID/g" .env
	else
		echo "$SESS Unrecognized argument."
		exit 1
	fi
fi

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker-compose build --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"
docker-compose up -d
docker-compose exec orpyD18m /bin/bash
