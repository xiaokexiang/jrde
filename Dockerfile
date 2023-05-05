FROM ubuntu:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y wget \
                       xvfb \
                       x11vnc \
                       openbox \
                       supervisor \
                       libxext-dev \
                       libxrender-dev \
                       libxtst-dev \
                       libxi6 \
                       libgtk-3-0 \
                       libcanberra-gtk-module \
                       dbus-x11 \
                       fonts-wqy-zenhei \
                       fonts-wqy-microhei \
                       fonts-arphic-ukai \
                       fonts-arphic-uming \
                       default-jdk \
                       curl \
                       nano

# Install IntelliJ IDEA
RUN mkdir -p /opt/idea && \
    wget -qO- https://download.jetbrains.com/idea/ideaIC-2021.1.2.tar.gz | tar xvz --strip-components=1 -C /opt/idea

# Configure VNC
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd 1234 ~/.vnc/passwd && \
    echo "#!/bin/bash\n\
    Xvfb :1 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &\n\
    openbox &\n\
    dbus-launch --exit-with-session /opt/idea/bin/idea.sh &\n\
    x11vnc -display :1 -nopw -listen localhost -xkb -forever &\n\
    sleep infinity" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 5900
CMD ["/usr/bin/supervisord"]
