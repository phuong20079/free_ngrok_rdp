#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

source function_post.sh
cd "$ROM_DIR"

start=$(date +"%s")
get_build_message "Synchronize $ROM / $BRANCH" "Sync..."

repo init -u "https://github.com/$ROM/android.git" -b "$BRANCH"
repo sync -j$(nproc --all) 2>&1| tee "$ROM_DIR/sync.log"

end=$(date +"%s")
start_end=$(($end - $start))
get_build_message "$ROM / $BRANCH Synchronized" "Task took $(($start_end / 60)) minutes, $(($start_end % 60)) seconds."
telegram __file "$ROM_DIR/sync.log"
