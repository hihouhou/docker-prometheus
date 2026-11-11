#
# Prometheus Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:trixie

LABEL org.opencontainers.image.authors="hihouhou < hihouhou@hihouhou.com >"

ENV PROMETHEUS_VERSION=v3.16.0

# Update & install packages for prometheus
RUN apt-get update && \
    apt-get install -y wget

# Get prometheus from github
RUN wget https://github.com/prometheus/prometheus/releases/download/${PROMETHEUS_VERSION}/prometheus-$(echo $PROMETHEUS_VERSION | cut -c2-).linux-amd64.tar.gz && \
    tar xf prometheus-$(echo $PROMETHEUS_VERSION | cut -c2-).linux-amd64.tar.gz && \
    mv prometheus-$(echo $PROMETHEUS_VERSION | cut -c2-).linux-amd64/prometheus /usr/local/bin/ && \
    mkdir /etc/prometheus

RUN useradd -ms /bin/bash prometheus

USER prometheus

EXPOSE 9090

COPY your_config.yml /etc/prometheus/your_config.yml
COPY rules.yml /etc/prometheus/rules.yml

CMD ["prometheus", "--config.file=/etc/prometheus/your_config.yml", "--storage.tsdb.path=/srv/prometheus"]
