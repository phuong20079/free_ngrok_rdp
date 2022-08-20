#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

source commit_checker.sh
source function_post.sh
cd "$ROM_DIR"

if ! [[ -d "$ROM_DIR/device/xiaomi/$CODENAME" ]]; then
    combo&msg err "Can't detect device tree folder, please check first!"
    exit 1
fi

if ! [[ -d "$ROM_DIR/vendor/xiaomi/$CODENAME" ]]; then
    combo&msg err "Can't detect vendor tree folder, please check first!"
    exit 1
fi

if ! [[ -d "$ROM_DIR/kernel/xiaomi/$CODENAME" ]]; then
    combo&msg err "Can't detect kernel tree folder, please check first!"
    exit 1
fi

# Setup ccache
export CCACHE_DIR="$SCRIPT_DIR/ccache"
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
ccache -M 20G
ccache -o compression=true
ccache -z

start=$(date +"%s")
combo&msg info "It's time to cook $ROM / $BRANCH mate!"

source build/envsetup.sh
breakfast "$CODENAME"
croot
build_cmd "$CODENAME"
rclone copy "$SCRIPT_DIR/ccache.tar.gz" backup:backup -P
end=$(date +"%s")
start_end=$(($start - $end))
combo&msg info "$A_MSG finished! Task took $(($start_end / 60)) minutes, $(($start_end % 60)) seconds."
