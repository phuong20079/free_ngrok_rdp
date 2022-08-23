#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

ROM_DIR="$SCRIPT_DIR/$ROM"
COMMIT_CHECK=$(git log --pretty=format:"%s" -1)

if ! [[ -d "$ROM_DIR" ]]; then
    mkdir -p "$ROM_DIR"
fi

telegram()
{
    CHANNEL_ID=${TG_CHANNEL_ID}
    ACTION=${1}
    EXTRA=${2}
    URL="https://api.telegram.org/bot${TG_BOT_TOKEN}"

    case "$ACTION" in
        __message)
            curl \
            -d chat_id=$CHANNEL_ID \
            -d "parse_mode=html" \
            -d "disable_web_page_preview=true" \
            -X POST $URL/sendMessage \
            -d text="$(
                for POST in "${EXTRA}"; do
                    echo "${POST}";
                done
            )"
        ;;
        __file)
            curl \
            -F chat_id=$CHANNEL_ID \
            -F "parse_mode=html" \
            -F "disable_web_page_preview=true" \
            -F document=@$EXTRA $URL/sendDocument \
            -F caption="$(
                for caption in "${3}"; do
                    echo "${caption}";
                done
            )"
        ;;
    esac
}

info()
{
    echo -e "\e[1;32m$*\e[0m"
}

err()
{
    echo -e "\e[1;41m$*\e[0m"
}

combo_msg()
{
    MSG_TEMPLATE="$2"
    telegram __message "$MSG_TEMPLATE" && $1 "$MSG_TEMPLATE"
}

get_build_message()
{
    get_distro_name=$(source /etc/os-release && echo ${PRETTY_NAME})
    post_template=$(echo -e "
    <b>====== Starting Build $ROM O-o-O ======</b>
    <b>Branch:</b> <code>${BRANCH}</code>
    <b>Device:</b> <code>${CODENAME}</code>
    <b>Type:</b> <code>${A_MSG}</code>
    <b>Job:</b> <code>$(nproc --all) Paralel processing</code>
    <b>Running on:</b> <code>$get_distro_name</code>
    <b>============== O-o-O ==============</b>")
}
