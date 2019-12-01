# Instructions

1. Clone this repository

   `git clone -b feat/212-workshop https://github.com/nicholasadr/dockerfiles.git`

2. Generate SSH key in your machine and add to your Github account following the information in [here](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh). If your ssh key pair is not generated in/as ~/.ssh/id_rsa(.pub), update line 7 in run.sh
3. Install nvidia driver for your NVIDIA GPU
4. Install [docker-ce](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [docker-compose](https://docs.docker.com/compose/install/)
5. Install nvidia-docker2 (For non-debian based distribution refer to [here](https://github.com/NVIDIA/nvidia-docker#upgrading-with-nvidia-docker2-deprecated))
    ```
    sudo apt-get update
    sudo apt-get --only-upgrade install docker-ce nvidia-docker2
    sudo systemctl restart docker
    ```
6. Modify .env
     
     ```
     cd dockerfiles/212-workshop/
     cat .env
     ```

   Variables:
   * dUSER: Username to emulate in container.
   * dGROUP: Group to emulate in container.
   * dUID: UID of the user in host machine. To obtain: `$user@host id -u <username>`
   * dGID: GID of the user in host machine. To obtain: `$user@host id -g <username>`
   * dPORT: Port in host machine.
   * dDRIVE: Disk location in host to be mounted to docker container
   * dWORKSPACE: Path to your development workspace

7. Start docker container
   ```
   chmod a+x run.sh
   ./run.sh
   ```

8. (optional) Start a new bash terminal

   `docker-compose exec workshop /bin/bash`
   
### Resources

* [Perception tutorial](https://github.com/ethz-asl/perception_tutorials)
* [ROS docker container with X11 authentication for NVIDIA GPU](https://github.com/diegoferigo/dockerfiles/tree/master/ROS)
* [libGL error](https://github.com/diegoferigo/dockerfiles/issues/6)
* [Using GUI with Docker](http://wiki.ros.org/docker/Tutorials/GUI)
* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
