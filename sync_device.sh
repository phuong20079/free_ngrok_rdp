#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

source function_post.sh
cd "$ROM_DIR"

start=$(date +"%s")
combo&msg info "Cloning device, kernel & vendor tree..."

git clone -j$(nproc --all) -b main https://github.com/greenforce-project/device_xiaomi_chime device/xiaomi/$CODENAME --depth=1
git clone -j$(nproc --all) -b $BRANCH https://gitlab.com/chimeoss/vendor_xiaomi_chime vendor/xiaomi/$CODENAME --depth=1
git clone -j$(nproc --all) -b main https://github.com/greenforce-project/kernel_xiaomi_citrus_sm6115 kernel/xiaomi/$CODENAME --depth=1

end=$(date +"%s")
start_end=$(($start - $end))
combo&msg info "OK device, kernel & vendor tree cloned! Task took $(($start_end / 60)) minutes, $(($start_end % 60)) seconds."
