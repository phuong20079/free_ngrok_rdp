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

telegram_curl()
{
	local ACTION=${1}
	shift
	local HTTP_REQUEST=${1}
	shift
	if [ "$HTTP_REQUEST" != "POST_FILE" ]; then
		curl -s -X $HTTP_REQUEST "https://api.telegram.org/bot$TG_BOT_TOKEN/$ACTION" "$@" | jq .
	else
		curl -s "https://api.telegram.org/bot$TG_BOT_TOKEN/$ACTION" "$@" | jq .
	fi
}

telegram_main()
{
	local ACTION=${1}
	local HTTP_REQUEST=${2}
	local CURL_ARGUMENTS=()
	while [ "${#}" -gt 0 ]; do
		case "${1}" in
			--animation | --audio | --document | --photo | --video )
				local CURL_ARGUMENTS+=(-F $(echo "${1}" | sed 's/--//')=@"${2}")
				shift
				;;
			--* )
				if [ "$HTTP_REQUEST" != "POST_FILE" ]; then
					local CURL_ARGUMENTS+=(-d $(echo "${1}" | sed 's/--//')="${2}")
				else
					local CURL_ARGUMENTS+=(-F $(echo "${1}" | sed 's/--//')="${2}")
				fi
				shift
				;;
		esac
		shift
	done
	telegram_curl "$ACTION" "$HTTP_REQUEST" "${CURL_ARGUMENTS[@]}"
}

telegram_curl_get()
{
	local ACTION=${1}
	shift
	telegram_main "$ACTION" GET "$@"
}

telegram_curl_post()
{
	local ACTION=${1}
	shift
	telegram_main "$ACTION" POST "$@"
}

telegram_curl_post_file()
{
	local ACTION=${1}
	shift
	telegram_main "$ACTION" POST_FILE "$@"
}

tg_send_message()
{
	telegram_main sendMessage POST "$@"
}

tg_edit_message_text()
{
	telegram_main editMessageText POST "$@"
}

tg_send_document()
{
	telegram_main sendDocument POST_FILE "$@"
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
    if [ "$CI_MESSAGE_ID" = "" ]; then
CI_MESSAGE_ID=$(tg_send_message --chat_id "$TG_CHANNEL_ID" --text "<b>====== Starting Build $ROM ======</b>
<b>Branch:</b> <code>${BRANCH}</code>
<b>Device:</b> <code>${CODENAME}</code>
<b>Type:</b> <code>${A_MSG}</code>
<b>Job:</b> <code>$(nproc --all) Paralel processing</code>
<b>Running on:</b> <code>$get_distro_name</code>

<b>Status:</b> $1" --parse_mode "html" | jq .result.message_id)
    else
tg_edit_message_text --chat_id "$TG_CHANNEL_ID" --message_id "$CI_MESSAGE_ID" --text "<b>====== Starting Build $ROM ======</b>
<b>Branch:</b> <code>${BRANCH}</code>
<b>Device:</b> <code>${CODENAME}</code>
<b>Type:</b> <code>${A_MSG}</code>
<b>Job:</b> <code>$(nproc --all) Paralel processing</code>
<b>Running on:</b> <code>$get_distro_name</code>

<b>Status:</b> $1" --parse_mode "html"
    fi
}
