#
# Prometheus Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

MAINTAINER hihouhou < hihouhou@hihouhou.com >

ENV GOROOT /usr/local/go
ENV GOPATH /opt/prometheus
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH
ENV PROMETHEUS_VERSION v2.19.3
ENV GO_VERSION 1.13
ENV USER ROOT

# Update & install packages for prometheus build
RUN apt-get update && \
    apt-get install -y wget git make build-essential curl

# Add yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Update & install packages yarn
RUN apt-get update && \
    apt-get install -y yarn


# Get go
RUN wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -xvf go${GO_VERSION}.linux-amd64.tar.gz && \
    mv go /usr/local

# Get prometheus from github
RUN mkdir -p $GOPATH/src/github.com/prometheus && \
    cd $GOPATH/src/github.com/prometheus && \
    git clone https://github.com/prometheus/prometheus.git && \
    cd prometheus && \
#    wget https://api.github.com/repos/prometheus/prometheus/tarball/${PROMETHEUS_VERSION} -O ${PROMETHEUS_VERSION}.tar.gz && \
#    tar xf  ${PROMETHEUS_VERSION}.tar.gz --strip-components=1 && \
    make build

EXPOSE 9090

WORKDIR $GOPATH/src/github.com/prometheus

COPY your_config.yml your_config.yml

CMD ["./prometheus", "--config.file=your_config.yml"] 
