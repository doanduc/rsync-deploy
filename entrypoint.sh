#!/bin/bash
set -eu

SSHPATH="$HOME/.ssh"
mkdir "$SSHPATH"
echo "$DEPLOY_KEY" > "$SSHPATH/key"
chmod 600 "$SSHPATH/key"
SERVER_DEPLOY_STRING="$USERNAME@$SERVER_IP:$SERVER_DESTINATION"
# sync it up"
#sh -c "rsync $ARGS -e 'ssh -i $SSHPATH/key -o StrictHostKeyChecking=no -p $SERVER_PORT' $GITHUB_WORKSPACE/$FOLDER $SERVER_DEPLOY_STRING"

echo "test alert"

urlencode() {
    # urlencode <string>
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
}

cd $GITHUB_WORKSPACE
#ALERT=`git show --oneline -s HEAD`
ALERT=`git show --pretty=format:%s -s HEAD`

ALERTFULL=`urlencode "$GITHUB_REPOSITORY $ALERT"`

# alert to telegram"
URL="https://api.telegram.org/$BOT_TOKEN/sendMessage?chat_id=$BOT_ID&text=$ALERTFULL"
curl $URL
echo "$ALERT"
