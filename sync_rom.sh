#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

source function_post.sh
cd "$ROM_DIR"

start=$(date +"%s")
combo_msg info "Synchronize $ROM from $BRANCH branch..."

repo init --depth=1 -u "https://github.com/$ROM/android.git" -b "$BRANCH" -g g default,-device,-mips,-darwin,-notdefault
repo sync

end=$(date +"%s")
start_end=$(($end - $start))
combo_msg info "$ROM / $BRANCH Synchronized! Task took $(($start_end / 60)) minutes, $(($start_end % 60)) seconds."
