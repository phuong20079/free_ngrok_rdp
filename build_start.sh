#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

source commit_checker.sh
source function_post.sh
cd "$ROM_DIR"
combo_msg info "Now ${A_MSG}"

if ! [[ -d "$ROM_DIR/device/xiaomi/$CODENAME" ]]; then
    combo_msg err "Can't detect device tree folder, please check first!"
    exit 1
fi

if ! [[ -d "$ROM_DIR/vendor/xiaomi/$CODENAME" ]]; then
    combo_msg err "Can't detect vendor tree folder, please check first!"
    exit 1
fi

if ! [[ -d "$ROM_DIR/kernel/xiaomi/$CODENAME" ]]; then
    combo_msg err "Can't detect kernel tree folder, please check first!"
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
combo_msg info "Time to burn $ROM / $BRANCH mate!"

source build/envsetup.sh
breakfast "$CODENAME"
croot
build_cmd
cd "$SCRIPT_DIR"
tar --use-compress-program="pigz -k -1" -cf ccache.tar.gz ccache
rclone copy "$SCRIPT_DIR/ccache.tar.gz" backup:backup -P
end=$(date +"%s")
start_end=$(($end - $start))
combo_msg info "$A_MSG finished! Task took $(($start_end / 60)) minutes, $(($start_end % 60)) seconds."
