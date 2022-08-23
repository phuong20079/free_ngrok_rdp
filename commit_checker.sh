#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

source function_post.sh

case "$COMMIT_CHECK" in
    "Auto Push: collect ccache")
        A_MSG="Collecting cacche"
        build_cmd()
        {
            brunch "$CODENAME" &
            sleep 80m
            kill %
        }
    ;;
    "Auto Push: do build")
        A_MSG="Building bacon"
        build_cmd()
        {
            brunch "$CODENAME" 2>&1| tee "$ROM_DIR/build.log"
            telegram __file "$ROM_DIR/build.log"
            TARGET="$(find $ROM_DIR/out/target/product/$CODENAME/lineage*UNOFFICIAL*$CODENAME.zip)"
            if ! [[ -e "$TARGET" ]]; then
                combo_msg err "File empty! Maybe something wrong above."
                exit 1
            else
                combo_msg info "Build founded! Pushing file to Google Drive..."
                rclone copy "$TARGET" backup:backup -P
            fi
        }
    ;;
    *)
        combo_msg info "Skip build! force ERROR!"
        exit 1
    ;;
esac
