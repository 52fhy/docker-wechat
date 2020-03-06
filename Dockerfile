FROM bestwu/deepin:panda-i386
LABEL maintainer='Alice_space <lizhihao0525@gmail.com>'

RUN echo 'deb https://mirrors.aliyun.com/deepin panda main non-free contrib' > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -fy --no-install-recommends locales && \
    echo 'zh_CN.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen && \
    echo -e 'LANG="zh_CN.UTF-8"\nLANGUAGE="zh_CN:zh"\n' > /etc/default/locale && \
    source /etc/default/locale && \
    apt-get install -y --no-install-recommends fonts-wqy-microhei deepin-wine deepin-wine32 deepin-wine32-preloader deepin-wine-helper deepin-wine-uninstaller && \
    apt-get -y autoremove --purge && apt-get autoclean -y && apt-get clean -y && \
    find /var/lib/apt/lists -type f -delete && \
    find /var/cache -type f -delete && \
    find /var/log -type f -delete && \
    find /usr/share/doc -type f -delete && \
    find /usr/share/man -type f -delete

ENV LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    LANG=zh_CN.UTF-8 \
    TZ=UTC-8

RUN echo 'deb https://mirrors.aliyun.com/deepin stable main non-free contrib' > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends deepin.com.wechat && \
    apt-get -y autoremove --purge && apt-get autoclean -y && apt-get clean -y && \
    find /var/lib/apt/lists -type f -delete && \
    find /var/cache -type f -delete && \
    find /var/log -type f -delete && \
    find /usr/share/doc -type f -delete && \
    find /usr/share/man -type f -delete

ENV APP=WeChat \
    AUDIO_GID=63 \
    VIDEO_GID=39 \
    GID=1000 \
    UID=1000 \
    DPI=96

RUN groupadd -o -g $GID wechat && \
    groupmod -o -g $AUDIO_GID audio && \
    groupmod -o -g $VIDEO_GID video && \
    useradd -d "/home/wechat" -m -o -u $UID -g wechat -G audio,video wechat && \
    mkdir /WeChatFiles && \
    chown -R wechat:wechat /WeChatFiles && \
    ln -s "/WeChatFiles" "/home/wechat/WeChat Files" && \
    sed -i 's/WeChat.exe" &/WeChat.exe"/g' "/opt/deepinwine/tools/run.sh"

VOLUME ["/WeChatFiles"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
