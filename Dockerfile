FROM ubuntu:22.04
MAINTAINER xiaokexiang <xxiaokexiang@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai
LABEL VERSION="base"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN yes | unminimize
RUN apt-get update && apt install --no-install-recommends xubuntu-desktop -y && \
    apt install language-pack-zh-hans \
        git \
        vim \
        sudo \
        wget \
        curl \
        htop \ 
        zsh \
        guake \
        autocutsel \
        xfce4-terminal \
        language-pack-zh-hans \
        tigervnc-standalone-server \
        dbus-x11 \
        x11-utils \
        fonts-wqy-microhei \
        gnome-user-docs-zh-hans \
        language-pack-gnome-zh-hans \
        fcitx \
        fcitx-pinyin \
        fcitx-config-gtk -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo -e 'LANG="zh_CN.UTF-8" \nLANGUAGE="zh_CN:zh:en_US:en"' > /etc/enviroment && sudo locale-gen
RUN mkdir /root/.vnc/ && echo "password" | vncpasswd -f > ~/.vnc/passwd && chmod 600 ~/.vnc/passwd
RUN echo "#!/bin/sh \nunset SESSION_MANAGER \nunset DBUS_SESSION_BUS_ADDRESS \nexport GTK_IM_MODULE=fcitx \nexport QT_IM_MODULE=fcitx \nexport XMODIFIERS=@im=fcitx \nexport LANG=zh_CN.UTF-8 \nfcitx -r \nchsh -s $(which zsh) \nstartxfce4" > ~/.vnc/xstartup && chmod u+x ~/.vnc/xstartup && ./etc/init.d/dbus start

# oh-my-zsh
RUN sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)" "" --unattended && \
    git clone https://ghproxy.com/https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://ghproxy.com/https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://ghproxy.com/https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions && \
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/g' ~/.zshrc && \
    echo 'bindkey ";" autosuggest-accept' >> ~/.zshrc

# powerlevel10k
RUN git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >>! /root/.zshrc && \
    sed -i 's&robbyrussell&powerlevel10k/powerlevel10k&g' /root/.zshrc
SHELL ["/usr/bin/zsh", "-c"]    
RUN source /root/.zshrc

RUN mkdir -p /usr/share/fonts/MesloLGS && \
    wget -P /usr/share/fonts/MesloLGS -O MesloLGS-NF-Regular.ttf "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" && \
    wget -P /usr/share/fonts/MesloLGS -O MesloLGS-NF-Bold.ttf "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" && \
    wget -P /usr/share/fonts/MesloLGS -O MesloLGS-NF-Italic.ttf "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" && \
    wget -P /usr/share/fonts/MesloLGS -O MesloLGS-NF-Bold-Italic.ttf "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" && \
    fc-cache -f -v

# guake配置
RUN update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/guake 50 && \
    update-alternatives --set x-terminal-emulator /usr/bin/guake

EXPOSE 5901

CMD ["sh","-c","vncserver :1 -localhost no -geometry=1920x1080 && tail -F /root/.vnc/*.log"]