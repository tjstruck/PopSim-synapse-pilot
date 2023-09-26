#cd <directory with Docker file>
#docker build .

#note the id that is output at the end of the build. Use that id in the command to run the container
#docker run -p 1024:1024 -p 9123:9123 -ti <id> bash


#FROM python:slim
# Start with Synapse's DOCKER Image
FROM python:3.9.1-slim-buster

# RUN apt-get update && apt-get -y upgrade \
#   && apt-get install -y --no-install-recommends \
#     build-essential \
#     zlib1g-dev \
#     swig \
#     git \
#     wget \
#     procps \
#     && rm -rf /var/lib/apt/lists/*
# WORKDIR /root

# # Install miniconda and needed packages
# ENV PATH="/root/miniconda3/bin:${PATH}"
# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#     && mkdir /root/.conda \
#     && bash Miniconda3-latest-Linux-x86_64.sh -b \
#     && rm -f Miniconda3-latest-Linux-x86_64.sh
# RUN conda install conda-build
# RUN pip3 install numpy
# RUN conda install dill

# Install demes
RUN pip3 install demes
RUN pip3 install -U scikit-learn