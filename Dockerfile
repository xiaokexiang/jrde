FROM xiaokexiang/jrde:less

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN yes | unminimize
RUN apt update && apt install language-pack-zh-hans \
        git \
        vim \
        sudo \
        wget \
        curl \
        htop \
        xfce4-terminal \
        language-pack-zh-hans \
        fonts-wqy-microhei \
        gnome-user-docs-zh-hans \
        language-pack-gnome-zh-hans \
        fcitx \
        fcitx-pinyin \
        fcitx-config-gtk -y

RUN echo -e 'LANG="zh_CN.UTF-8" \nLANGUAGE="zh_CN:zh:en_US:en"' > /etc/enviroment && sudo locale-gen
RUN mkdir /root/.vnc/ && echo "password" | vncpasswd -f > ~/.vnc/passwd && chmod 600 ~/.vnc/passwd
RUN echo "#!/bin/sh \nunset SESSION_MANAGER \nunset DBUS_SESSION_BUS_ADDRESS \nexport GTK_IM_MODULE=fcitx \nexport QT_IM_MODULE=fcitx \nexport XMODIFIERS=@im=fcitx \nexport LANG=zh_CN.UTF-8 \nfcitx -r \nstartxfce4" > ~/.vnc/xstartup && chmod u+x ~/.vnc/xstartup && ./etc/init.d/dbus start

RUN wget https://phoenixnap.dl.sourceforge.net/project/tigervnc/stable/1.13.1/ubuntu-20.04LTS/amd64/tigervncserver_1.13.1-1ubuntu1_amd64.deb -O /opt/tigervnc-1.13.1.deb

EXPOSE 5901