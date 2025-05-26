FROM nvidia/cuda:12.6.1-base-ubuntu22.04
ARG DEBIAN_FRONTEND=noninteractive
#set bash as default shell
SHELL ["/bin/bash", "-c"]
# install ros2 jazzy
RUN apt update -y && apt install locales -y
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt install -y software-properties-common

RUN apt install -y software-properties-common \
    && add-apt-repository universe -y

RUN apt update -y && apt install curl -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update -y && apt install -y ros-dev-tools
RUN apt install -y python3-colcon-common-extensions
RUN apt update -y &&\
    apt upgrade -y &&\
    apt install ros-humble-desktop-full -y

RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
# install gz-harmonic
RUN apt update -y && apt upgrade -y \
    && apt install -y ros-humble-gz-*\
    && apt install ros-humble-rmw-cyclonedds-cpp -y \
    && apt install ros-humble-joint* -y \
    && rm -rf /var/lib/apt/lists/* 

# create a user with sudo privileges
RUN useradd -m -s /bin/bash ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY entrypoint.sh /home/ubuntu/entrypoint.sh
COPY .bashrc /home/ubuntu/.bashrc
RUN chmod +x /home/ubuntu/entrypoint.sh
RUN chmod +x /home/ubuntu/.bashrc

USER ubuntu
    WORKDIR /home/ubuntu
        # set the entrypoint
        RUN source .bashrc
        RUN git clone https://github.com/Shell-Urban-Concept-Autonomous/shell_urban_simulator.git
    WORKDIR /home/ubuntu/shell_urban_simulator
        RUN colcon build --symlink-install
        ENTRYPOINT ["/home/ubuntu/entrypoint.sh"]

# clone the your repo to start the development
#end of ros2 jazzy installation