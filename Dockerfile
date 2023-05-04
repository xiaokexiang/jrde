FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -y \
    kubuntu-desktop \
    kde-plasma-desktop \
    kde-l10n-zhcn \
    x11vnc \
    xvfb \
    kde-full \
    && apt-get autoclean && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install X11 and PulseAudio servers
RUN apt-get update && apt-get install -y \
    xserver-xorg \
    pulseaudio \
    && apt-get autoclean && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir ~/.vnc && x11vnc -storepasswd 123456 ~/.vnc/passwd
RUN echo '#!/bin/bash \n\
\n\
xvfb-run -n 0 -s "-screen 0 1024x768x24" kwin & startkde \n\
' > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup
# Expose X11 and PulseAudio servers
ENV DISPLAY=:0
ENV PULSE_SERVER=unix:/tmp/pulseaudio.socket

# CMD ["/bin/sh","-c","x11vnc -forever -usepw -create"]