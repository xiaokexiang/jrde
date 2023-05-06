# Docker版ubuntu镜像
---
<p style="text-align: center">
    <img src="https://img.shields.io/badge/create-2023.05.6-brightgreen" alt="2021.04.20"/>
    <img src="https://img.shields.io/badge/ubuntu20.04" alt="ubuntu20.04"/>    
    <img src="https://img.shields.io/badge/github%20-workflow-orange" alt="github action"/>
    <img src="https://img.shields.io/badge/vnc%20-tigervnc-yellow" alt="tigervnc"/>
</p>

## 前言
<b>基于xubuntu-desktop、tigervnc、ubuntu20.04的远程桌面镜像，可由docker直接启动，通过vnc访问即可。</b>

## 命令
### 基础镜像

```bash
docker runn -itd --name ubuntu-gui xiaokexianng/jrde:base
```
> 1. 基础镜像包含了启动GUI桌面必备的组件。

### Java开发镜像

```bash
docker run -itd -p 5901:5901 --cap-add=NET_ADMIN -v /dev/net/tun:/dev/net/tun  --name ubuntu-gui xiaokexiang/jrde:java
```
> 1. java development镜像包含了`jdk8、maven3、idea2022.3、kt-connect`。
> 2. --cap-add=NET_ADMIN -v /dev/net/tun:/dev/net/tun 参数非必要，为了启动kt-connect组件所用。