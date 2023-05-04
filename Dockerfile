FROM ubuntu:22.04

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置中文环境
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

RUN echo "keyboard-configuration keyboard-configuration/layout select English (US)" | debconf-set-selections && echo "keyboard-configuration keyboard-configuration/variant select English (US)" | debconf-set-selections

# 安装gnome桌面和vnc服务器
RUN apt-get update && apt-get install -y \
    ubuntu-gnome-desktop \
    gnome-session \
    gnome-terminal \
    x11vnc \
    xvfb \
    sudo \
    git \
    && rm -rf /var/lib/apt/lists/*

# 配置vnc密码
RUN mkdir ~/.vnc && x11vnc -storepasswd 123456 ~/.vnc/passwd

# 创建启动脚本
RUN echo '#!/bin/bash\n\
\n\
# Run the VNC server\n\
mkdir -p ~/.vnc\n\
x11vnc -forever -usepw -create\n\
\n\
# Start the desktop environment\n\
gnome-session\n\
' > ~/start.sh && chmod +x ~/start.sh

# Expose VNC port
EXPOSE 5900

# Start VNC server and Gnome session
CMD ["/bin/bash", "/root/start.sh"]