#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

source function_post.sh
cd "$ROM_DIR"

start=$(date +"%s")
combo&msg info "Synchronize $ROM from $BRANCH branch..."

repo init -q --no-repo-verify --depth=1 -u "https://github.com/$ROM/android" -b "$BRANCH" -g default,-device,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

end=$(date +"%s")
start_end=$(($start - $end))
combo&msg info "$ROM / $BRANCH Synchronized! Task took $(($start_end / 60)) minutes, $(($start_end % 60)) seconds."
