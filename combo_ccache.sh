#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

start=$(date +"%s")
source function_post.sh

# Setup rclone
mkdir -p ~/.config/rclone
curl -Lo ~/.config/rclone/rclone.conf $RCLONE

combo_msg info "Downloading ccache from Google Drive..."

rclone copy backup:backup/ccache.tar.gz $SCRIPT_DIR -P
if [[ -e "$SCRIPT_DIR/ccache.tar.gz" ]]; then
    get_size=$(du -sh "$SCRIPT_DIR/ccache.tar.gz" | cut -c 1-4)
    combo_msg info "ccache downloaded! The size is ${get_size}B"
    tar -xf "$SCRIPT_DIR/ccache.tar.gz"
    rm -rf "$SCRIPT_DIR/ccache.tar.gz"
fi

if ! [[ -d "$SCRIPT_DIR/ccache" ]]; then
    combo_msg err "Can't detect ccache folder, please check first!"
    ls
    exit 1
fi

end=$(date +"%s")
start_end=$(($end - $start))
combo_msg info "ccache was ready! Task took $(($start_end / 60)) minutes, $(($start_end % 60)) seconds."
