FROM xiaokexiang/jrde:base
MAINTAINER xiaokexiang <xxiaokexiang@gmail.com>
WORKDIR /opt

# kt-connect
RUN curl -OL https://ghproxy.com/https://github.com/alibaba/kt-connect/releases/download/v0.3.7/ktctl_0.3.7_Linux_x86_64.tar.gz && tar -zxvf ktctl_0.3.7_Linux_x86_64.tar.gz && mv ktctl /usr/local/bin/ && rm ktctl_0.3.7_Linux_x86_64.tar.gz
RUN curl -OL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && mv kubectl /usr/local/bin/
RUN echo '#!/bin/bash\nif [ "$#" -ne 2 ]; then\n    echo "Usage: $0 IP PASSWORD"\n    exit 1\nfi\nNEWIP=$1\nPASSWORD=$2\ncp /root/.kube/config.sample /root/.kube/config -f\nsed -i "s/{IP}/$NEWIP/g" /root/.kube/config\nsed -i "s/{PATH}/pki/g" /root/.kube/config\nsshpass -p $PASSWORD scp -o StrictHostKeyChecking=no -r root@$NEWIP:/etc/kubernetes/pki/ /root/.kube/\nktctl -d -i abcsys.cn:5000/public/kt-connect-shadow:stable  --namespace=kube-system connect\n' > kt.sh && \
    chmod +x kt.sh && mv kt.sh /usr/local/bin/
RUN mkdir -p /root/.kube/ && echo -e "apiVersion: v1\nclusters:\n- cluster:\n    certificate-authority: ./{PATH}/ca.pem\n    server: https://{IP}:6443\n  name: cluster-ssl\ncontexts:\n- context:\n    cluster: cluster-ssl\n    user: admin_ssl\n  name: admin@cluster-ssl\ncurrent-context: admin@cluster-ssl\nkind: Config\nusers:\n- name: admin_ssl\n  user:\n   client-certificate: ./{PATH}/admin.pem\n   client-key: ./{PATH}/admin-key.pem" > /root/.kube/config.sample 

# zsh
RUN apt-get update && \
    apt-get install -y zsh wget curl sshpass && \
    sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)" && \
    git clone https://ghproxy.com/github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://ghproxy.com/github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://ghproxy.com/github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions && \
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/g' ~/.zshrc && \
    echo 'bindkey ";" autosuggest-accept' >> ~/.zshrc

# chorme
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# 安装 jdk8
RUN wget https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz -O /opt/zulu8.tar.gz  && \
    mkdir -p /opt/java && \
    tar -xzf /opt/zulu8.tar.gz -C /opt/java --strip-components=1 && \
    rm /opt/zulu8.tar.gz
ENV JAVA_HOME=/opt/java
ENV PATH=${PATH}:${JAVA_HOME}/bin

RUN wget https://download.jetbrains.com/idea/ideaIC-2022.3.tar.gz -O /opt/ideaIC-2022.3.tar.gz && \
    mkdir -p /opt/idea && \
    tar -xzf /opt/ideaIC-2022.3.tar.gz -C /opt/idea --strip-components=1 && \
    rm /opt/ideaIC-2022.3.tar.gz
# 安装 maven3
RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz -O /opt/maven3.tar.gz && \
    mkdir -p /opt/maven3 && \
    tar -xzf /opt/maven3.tar.gz -C /opt/maven3 --strip-components=1 && \
    rm /opt/maven3.tar.gz
ENV MAVEN_HOME=/opt/maven3
ENV PATH=${PATH}:${MAVEN_HOME}/bin