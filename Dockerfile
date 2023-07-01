# Dockerfile to deploy a llama-cpp container with conda-ready environments

# docker pull continuumio/miniconda3:latest

ARG TAG=latest
FROM continuumio/miniconda3:$TAG

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        git \
        locales \
        sudo \
        build-essential \
        dpkg-dev \
        wget \
        openssh-server \
        nano \
    && rm -rf /var/lib/apt/lists/*

# Setting up locales

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# SSH exposition
EXPOSE 22/tcp
RUN service ssh start

# Create user

RUN groupadd --gid 1020 llama-cpp-group
RUN useradd -rm -d /home/llama-cpp-user -s /bin/bash -G users,sudo,llama-cpp-group -u 1000 llama-cpp-user

# Update user password
RUN echo 'llama-cpp-user:admin' | chpasswd

# Updating conda to the latest version
#RUN conda update conda -y

# Create virtalenv
RUN conda create -n mpt -y python=3.10.6

# Adding ownership of /opt/conda to $user
RUN chown -R llama-cpp-user:users /opt/conda

# conda init bash for $user
RUN su - llama-cpp-user -c "conda init bash"

# Download latest github
RUN su - llama-cpp-user -c "git clone https://github.com/abacaj/mpt-30B-inference.git ~/mpt \
                            && cd ~/mpt"

# Install Requirements for python virtualenv
RUN su - llama-cpp-user -c "cd ~/mpt \
                            && conda activate \
                            && python3 -m pip install -r requirements.txt "

ENV HOME /home/llama-cpp-user

COPY ./models/mpt-30b-chat.ggmlv0.q4_1.bin ${HOME}/mpt/models/

# Preparing for login
WORKDIR ${HOME}
USER llama-cpp-user
CMD ["/bin/bash"]
