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

# 设置 VNC 密码
RUN mkdir ~/.vnc && \
    x11vnc -storepasswd 123456 ~/.vnc/passwd

# 创建启动脚本
RUN echo '#!/bin/bash\n\
Xvfb :1 -screen 0 1024x768x16 &\n\
export DISPLAY=:1.0\n\
dbus-launch --exit-with-session gnome-session &' > /start.sh && \
    chmod +x /start.sh

EXPOSE 5901

CMD ["/start.sh", "&&", "x11vnc", "-rfbport", "5901", "-rfbauth", "/root/.vnc/passwd", "-forever", "-shared", "-noxrecord", "-noxdamage", "-xkb"]

