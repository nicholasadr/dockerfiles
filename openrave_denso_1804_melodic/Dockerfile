FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04
MAINTAINER Nicholas Adrian <nicholasadr@ntu.edu.sg>

ENV ROS_DISTRO melodic
# Some QT-Apps/Gazebo don't show controls without this
ENV QT_X11_NO_MITSHM 1

ARG user
ARG group
ARG uid
ARG gid
ARG ssh_prv_key
ARG ssh_pub_key

# Overwrite interactive installation
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends -q -y \
    # Required for ROS 
    gnupg2 lsb-release \
    # Required for openrave-installation
    wget mlocate \ 
    # Required for ssh
    openssh-server dirmngr \
    # Helpful networking tools
    net-tools iputils-ping \
    # Helpful software tools
    git vim sudo && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${gid} -G sudo -ms /bin/bash ${user} && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt update && apt install --no-install-recommends -q -y \
    ros-${ROS_DISTRO}-ros-core \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-catkin-tools \
    python-wstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init

WORKDIR /home/${user}
ENV PATH="/home/${user}/.local/bin:${PATH}"
USER ${user}

# Authorize SSH host
RUN mkdir .ssh && \
    chmod 0700 .ssh && \
    ssh-keyscan github.com > .ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > .ssh/id_rsa && \
    echo "$ssh_pub_key" > .ssh/id_rsa.pub && \
    chmod 600 .ssh/id_rsa && \
    chmod 644 .ssh/id_rsa.pub

RUN mkdir -p catkin_ws/src && cd catkin_ws && \
    catkin init && catkin config --extend /opt/ros/${ROS_DISTRO} && \
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin config --merge-devel

# Install OpenRAVE
RUN mkdir -p ~/git && cd ~/git && \
    git clone https://github.com/crigroup/openrave-installation.git && \
    cd openrave-installation && \
    ./install-dependencies.sh
RUN cd ~/git/openrave-installation && \
    ./install-osg.sh
RUN cd ~/git/openrave-installation && \
    ./install-fcl.sh
RUN cd ~/git/openrave-installation && \
    ./install-openrave.sh

RUN cd catkin_ws/src && wstool init && \
    wstool set denso_common --git git@github.com:quangounet/denso_common.git -v master -y && \
    wstool set bcap --git https://github.com/fsuarez6/bcap.git -v master -y && \
    wstool update -j8

# Ignore the rosdep update warning
# https://github.com/ros-infrastructure/rosdep/issues/473
RUN sudo apt update && \
    rosdep update && \
    sudo rosdep install --rosdistro ${ROS_DISTRO} --ignore-src --from-paths catkin_ws/src -y

WORKDIR /home/${user}/catkin_ws

# Build workspace
RUN ["/bin/bash", "-c", "catkin build"]
RUN echo "source /home/${user}/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN ["/bin/bash", "-c", "source ~/.bashrc"]
