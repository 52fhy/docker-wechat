[docker hub](https://hub.docker.com/r/alicespace/wechat/)

本镜像基于[深度操作系统](https://www.deepin.org/download/)
### 修复了高分屏缩放问题
###  闪退问题
在开机后不要立即开启，否则会因为KDE依赖加载不全导致闪退
重启解决百分之99的问题
## 使用方法
**国内的话请尽量在本地构建，速度会加快**
1. 安装docker并将自己加入docker组  
不同linux发行版命令不同，请自行查阅  
2. 选择一个文件夹，打开终端
```bash
git clone https://github.com/Alice-space/docker-wechat.git
cd docker-wechat
```
3. 开始本地构建
```bash
docker build -t wechat .
```
4. 启动准备工作
允许所有用户访问X11服务,运行命令:

```bash
    xhost +
```
KDE桌面环境注意  
本wechat移植自deepin，打包进了一些gnome依赖[deepin-wine-ubuntu#12](https://github.com/wszqkzqk/deepin-wine-ubuntu/issues/12)
kde桌面环境需要安装gnome-settings-daemon才能正常运行  
安装后寻找gsd-settings并运行  
Ubuntu/Debian
```bash
 sudo apt install gnome-settings-daemon
```
下列命令添加到`~/.bash_profile`
```bash
/usr/lib/gnome-settings-daemon/gsd-xsettings &
```
Manjaro/Arch Linux  
```bash
 sudo pacman -Sy gnome-settings-daemon
```
下列命令添加到`~/.bash_profile`
```bash
/usr/lib/gsd-xsettings &
```
4. 启动
```bash
sudo chmod +x local_launch.sh
./local_launch.sh
```
`local_launch.sh`解释
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
    -e DPI=125 \ # 设定字体DPI
    wechat
```
