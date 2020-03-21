[docker hub](https://hub.docker.com/r/alicespace/wechat/)

本镜像基于[深度操作系统](https://www.deepin.org/download/)
### 修复了高分屏缩放问题
###  闪退问题
在开机后不要立即开启，否则会因为KDE依赖加载不全导致闪退
## 国内的话请尽量在本地构建，速度会加快
构建方法
1. 选择一个文件夹
```bash
git clone https://github.com/Alice-space/docker-wechat.git
cd docker-wechat
```
2. 开始本地构建
```bash
docker build -t wechat .
```
3. 启动
```bash
sudo chmod +x local_launch.sh
./local_launch.sh
```
### 准备工作

1. 允许所有用户访问X11服务,运行命令:

```bash
    xhost +
```
或者

```bash
   sudo xhost +
```
2. KDE桌面环境注意
本wechat移植自deepin，打包进了一些gnome依赖[deepin-wine-ubuntu#12](https://github.com/wszqkzqk/deepin-wine-ubuntu/issues/12)
kde桌面环境需要安装gnome-settings-daemon才能正常运行
安装后寻找gsd-settings并运行
```bash
/usr/lib /gnome-settings-daemon/gsd-xsettings &
```

## 运行

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
