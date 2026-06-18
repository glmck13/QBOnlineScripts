#!/bin/bash

TOKENFILE=$(type -p $0)
TOKENFILE=${TOKENFILE%/bin/*}/etc/${QBO_SANDBOX}qboTokens.conf
. $TOKENFILE

LOCKFILE=${TOKENFILE%/*}/qboToken.lock
exec 200>$LOCKFILE

flock -x 200

AUTH=$(echo -n "$OAUTH2_CLIENT:$OAUTH2_SECRET" | base64 -w0)
json=$(curl -s -H "Authorization: Basic $AUTH" -d "grant_type=refresh_token&refresh_token=$OAUTH2_REFRESH_TOKEN" "$OAUTH2_TOKEN_SERVER")

refresh_token=$(jq -r .refresh_token <<<${json})
access_token=$(jq -r .access_token <<<${json})

sed -i \
	-e "s/\(OAUTH2_REFRESH_TOKEN=\).*/\1\"${refresh_token}\"/" \
	-e "s/\(OAUTH2_ACCESS_TOKEN=\).*/\1\"${access_token}\"/" \
$TOKENFILE

flock -u 200

jq . <<<${json}
