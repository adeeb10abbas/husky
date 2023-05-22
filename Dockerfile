FROM  ros:noetic-ros-base-focal

# Set shell for running commands
SHELL ["/bin/bash", "-c"]

# Update and upgrade the system
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y tzdata

# Install necessary dependencies for the script
RUN apt-get install -y wget unzip curl software-properties-common lsb-release python3-pip

# Install Bazelisk using npm as it's straightforward this way
RUN apt-get install -y npm
RUN npm install -g @bazel/bazelisk

# Run Bazelisk to install Bazel
RUN bazelisk

# Install some useful tools for development
RUN apt-get update --fix-missing && \
    apt-get install -y git \
                       nano \
                       vim \
                       libeigen3-dev \
                       tmux \
		               zip

RUN apt-get -y dist-upgrade

# Clone Drake ROS repository
RUN git clone https://github.com/husky/husky.git
RUN cd husky
RUN pip install -U rosdep


# ROS2 workspace setup
RUN mkdir -p husky_ws/src/husky
COPY . /husky_ws/src/husky


RUN source /opt/ros/noetic/setup.bash && \
     cd husky_ws/ && \
     apt-get update --fix-missing && \
     rosdep install -i --from-path src --rosdistro noetic -r -y

WORKDIR '/husky_ws'
# Set the entrypoint to source ROS setup.bash and run a bash shell
ENTRYPOINT ["/bin/bash"]
