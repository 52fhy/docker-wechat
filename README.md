[docker hub](https://hub.docker.com/r/alicespace/wechat/)

本镜像基于[深度操作系统](https://www.deepin.org/download/)
### 修复了高分屏缩放问题

### 准备工作

允许所有用户访问X11服务,运行命令:

```bash
    xhost +
```
或者

```bash
   sudo xhost +
```

## 查看系统audio gid

```bash
  cat /etc/group | grep audio
```

fedora 26 结果：

```bash
audio:x:63:
```

### 运行

### docker-compose

```yml
version: '3'
services:
  wechat:
    image: alicespace/wechat
    container_name: wechat
    devices:
      - /dev/snd
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - $HOME/WeChatFiles:/WeChatFiles
    environment:
      - DISPLAY=unix$DISPLAY
      - QT_IM_MODULE=fcitx
      - XMODIFIERS=@im=fcitx
      - GTK_IM_MODULE=fcitx
      - AUDIO_GID=63 # 可选 默认63（fedora） 主机audio gid 解决声音设备访问权限问题
      - GID=1000 # 可选 默认1000 主机当前用户 gid 解决挂载目录访问权限问题
      - UID=1000 # 可选 默认1000 主机当前用户 uid 解决挂载目录访问权限问题
      - DPI=125 # dpi放大比例，百分比
```

或

```bash
    docker run -d --name wechat --device /dev/snd \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/WeChatFiles:/WeChatFiles \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e AUDIO_GID=`getent group audio | cut -d: -f3` \
    -e GID=`id -g` \
    -e UID=`id -u` \
    -e DPI=125 \
    alicespace/wechat
```
