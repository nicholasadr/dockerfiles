FROM ros:melodic-ros-base

ARG user
ARG group
ARG uid
ARG gid

ARG ssh_prv_key
ARG ssh_pub_key

RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${gid} -ms /bin/bash ${user}

RUN apt update && \
    apt install -y wget git openssh-server && \
    apt install -y ros-melodic-ddynamic-reconfigure ros-melodic-octomap-msgs ros-melodic-octomap-ros \
    autoconf ros-melodic-cv-bridge ros-melodic-eigen-conversions ros-melodic-image-geometry \
    ros-melodic-tf-conversions ros-melodic-pcl-conversions ros-melodic-pcl-ros ros-melodic-rviz

RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list
RUN wget http://packages.ros.org/ros.key -O - | apt-key add - && \
    apt-get update && apt-get install -y python-catkin-tools python-wstool

WORKDIR /home/${user}
ENV PATH="/home/${user}/.local/bin:${PATH}"
USER ${user}

# Authorize SSH Host
RUN mkdir .ssh && \
    chmod 0700 .ssh && \
    ssh-keyscan github.com > .ssh/known_hosts
# Add the keys and set permissions
RUN echo "$ssh_prv_key" > .ssh/id_rsa && \
    echo "$ssh_pub_key" > .ssh/id_rsa.pub && \
    chmod 600 .ssh/id_rsa && \
    chmod 600 .ssh/id_rsa.pub

RUN mkdir -p catkin_ws/src && cd catkin_ws && \
    catkin init && catkin config --extend /opt/ros/melodic && \
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin config --merge-devel
RUN cd catkin_ws/src && wstool init && wstool set catkin_simple --git git@github.com:catkin/catkin_simple.git -y && \
    wstool set perception_tutorials --git git@github.com:ethz-asl/perception_tutorials.git -y && wstool update && \
    wstool merge -y perception_tutorials/dependencies.rosinstall && \
    wstool update -j8
RUN echo "source /home/${user}/catkin_ws/devel/setup.bash" >> ~/.bashrc
# Source bashrc
RUN ["/bin/bash", "-c", "source ~/.bashrc"]

# Install Sensorstick SDK
RUN cd catkin_ws/src && wstool merge perception_tutorials/sensorstick.rosinstall && \
    wstool update -j8

# Install Kinect V2 SDK
RUN cd catkin_ws/src && wstool merge perception_tutorials/kinectv2.rosinstall && \
    wstool update -j8

# Install Kinect Azure SDK
RUN cd catkin_ws/src && wstool merge perception_tutorials/azure.rosinstall && \
    wstool update -j8

WORKDIR /home/${user}/catkin_ws

# Build workspace
RUN ["/bin/bash", "-c", "catkin build perception_tutorials"]
