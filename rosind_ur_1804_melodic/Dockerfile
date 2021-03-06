FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04
MAINTAINER Nicholas Adrian <nicholasadr@ntu.edu.sg>

ENV ROS_DISTRO melodic
# Some QT-Apps/Gazebo don't show controls without this
ENV QT_X11_NO_MITSHM 1

ARG user
ARG group
ARG uid
ARG gid
# Overwrite interactive installation
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends -q -y \
    gnupg2 lsb-release \
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

RUN mkdir -p catkin_ws/src && cd catkin_ws && \
    catkin init && catkin config --extend /opt/ros/${ROS_DISTRO} && \
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin config --merge-devel

RUN cd catkin_ws/src && wstool init && \
    wstool set universal_robot --git https://github.com/ros-industrial/universal_robot.git -v ${ROS_DISTRO}-devel -y && \
    wstool update -j8

RUN sudo apt update && \
    rosdep update && \
    sudo rosdep install --rosdistro ${ROS_DISTRO} --ignore-src --from-paths catkin_ws/src -y

#USER ${user}
RUN echo "source /home/${user}/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN ["/bin/bash", "-c", "source ~/.bashrc"]

WORKDIR /home/${user}/catkin_ws

# Build workspace
RUN ["/bin/bash", "-c", "catkin build"]
