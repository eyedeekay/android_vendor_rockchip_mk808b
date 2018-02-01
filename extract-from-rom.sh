#! /usr/bin/env sh

export systemimg="system.img"

if [ ! -z $1 ]; then
    export systemimg="$1"
fi

if [ -f "$systemimg" ]; then
    mkdir -p vendor \
        proprietary/bin \
        proprietary/etc/firmware \
        proprietary/lib/ \
        proprietary/lib/drm \
        proprietary/lib/egl \
        proprietary/lib/hw \
        proprietary/lib/modules \
        proprietary/lib/soundfx \
        proprietary/lib/ssl \
        proprietary/lib/ssl/engines
    mkdir -p proprietary/lib/com.trans.beatpenguin \
        proprietary/lib/com.trans.dancingbeats \
        proprietary/lib/com.trans.hurdling \
        proprietary/lib/com.trans.pingpang2 \
        proprietary/lib/com.trans.sprint \
        proprietary/lib/com.trans.tennis
    /usr/sbin/fuse2fs "$systemimg" vendor
    for f in $(cat proprietary-files.txt); do
        cp "$f" $(echo "$f" | sed 's|vendor|proprietary|g' )
    done
    /bin/fusermount -u vendor
    rm -rf vendor
    ./setup-makefiles.sh
    cp vendor/rockchip/mk808b/* .
    rm -rf vendor
    sed -i 's|proprietary/vendor|proprietary|g' *.mk
else
    echo "File not found"
fi
