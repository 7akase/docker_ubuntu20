FROM ubuntu:latest
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
# docker-compose run --rm main

RUN apt-get update && apt-get install -y git python3-pip
RUN pip3 install numpy scipy scikit-learn

RUN apt-get install -y autoconf automake autotools-dev curl device-tree-compiler libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev git wget

# set working user
RUN useradd -m docker

#--------------------------------------------------------------
# Build using 
#--------------------------------------------------------------
ENV MAKEFLAGS -j5

## install icarus 12.0 (https://iverilog.fandom.com/wiki/Installation_Guide#Compiling_on_Linux.2FUnix)
WORKDIR /tmp
RUN git clone https://github.com/steveicarus/iverilog.git
WORKDIR iverilog
RUN sh autoconf.sh && ./configure && make ${MAKEFLAGS} && make install ${MAKEFLAGS}

## install gtkwave
RUN apt-get install -y gtkwave



# debconf-get-selections to switch dash to bash
#    This should be done after 'git clone' 
RUN apt-get install -y debconf-utils 
RUN echo "dash    dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

WORKDIR /root/
#--------------------------------------------------------------
# change user
#--------------------------------------------------------------
# USER docker
# ENV HOME /home/docker
# WORKDIR ${HOME}
# ln -s /work ./work

# WORKDIR OpenRAM
# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD [ "/bin/bash" ]