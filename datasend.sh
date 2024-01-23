#!/bin/bash
var=$(./data.sh)
curl --data chat_id="-1002076891700" --data-urlencode "text=$var"  "https://api.telegram.org/bot6802387864:AAFntgnRknfjeJLpipSdPDAnmZvsYe8_Sgc/sendMessage?parse_mode=HTML"
