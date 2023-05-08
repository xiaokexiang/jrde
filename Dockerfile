FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 更新软件源并安装必要的软件包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ubuntu-desktop \
    gnome-panel \
    gnome-settings-daemon \
    metacity \
    nautilus \
    gnome-terminal \
    dbus-x11 \
    x11-utils \
    && rm -rf /var/lib/apt/lists/*

