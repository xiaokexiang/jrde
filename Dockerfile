FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt install --no-install-recommends xubuntu-desktop -y && \
    apt install tigervnc-standalone-server tiger-common -y
