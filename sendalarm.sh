#!/bin/bash
var=$(./alarm.sh)
curl --data chat_id="-1002033747809" --data-urlencode "text=$var"  "https://api.telegram.org/bot6802387864:AAFntgnRknfjeJLpipSdPDAnmZvsYe8_Sgc/sendMessage?parse_mode=HTML"
