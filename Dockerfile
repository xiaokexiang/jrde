FROM ubuntu:22.04
RUN apt update && apt install --no-install-recommends xubuntu-desktop -y && \
    tigervnc-standalone-server tiger-common -y
