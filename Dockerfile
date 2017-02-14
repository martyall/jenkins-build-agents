FROM ubuntu:16.04
MAINTAINER Kishore Bhatia <bhatia dot kishore at gmail dot com>

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y git
RUN apt-get install -y sudo
RUN apt-get install -y apt-transport-https
RUN apt-get install -y lsb-release
RUN apt-get install curl
# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

#add Docker
USER root
RUN curl -L -o /tmp/docker-latest.tgz https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
  && tar xzf /tmp/docker-latest.tgz -C /tmp/ \
  && mv /tmp/docker/* /usr/bin/ \
  && chmod a+x /usr/bin/docker* \
  && rm -rf /tmp/docker* \
  && delgroup staff \
  && groupadd -g 50 docker \
  && groupadd staff \
  && adduser jenkins docker \
  && adduser root docker
RUN curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)"
RUN chmod +x /usr/local/bin/docker-compose

#run bootstrap script
RUN mkdir -p /tmp/scripts/
ADD bootstrap.sh /tmp/scripts/bootstrap.sh
RUN chmod +x /tmp/scripts/bootstrap.sh
RUN sh -x /tmp/scripts/bootstrap.sh

# Standard SSH port
EXPOSE 22
