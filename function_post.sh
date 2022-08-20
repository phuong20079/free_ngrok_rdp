#!/usr/bin/env bash
# Copyright (C) 2020 - 2022 Muhammad Fadlyas (fadlyas07)
# SPDX-License-Identifier: GPL-3.0-or-later

COMMIT_CHECK=$(git log --pretty=format:"%s" -1)

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

make()
{
    ACTION=${1}
    NAME=${2}
    EXTRA=${3}

    case "$ACTION" in
        __tar)
            tar --use-compress-program="pigz -k -${4}" -cf ${NAME}.tar.gz "$EXTRA"
        ;;
        __zip)
            zip -r9q ${NAME}.zip "$EXTRA"
        ;;
    esac
}

combo&msg()
{
    MSG_TEMPLATE="$2"
    telegram __message $MSG_TEMPLATE && $1 $MSG_TEMPLATE
}
