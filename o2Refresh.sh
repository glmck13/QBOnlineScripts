#!/bin/ksh

TOKENFILE=$HOME/etc/${QBO_SANDBOX}qboTokens.conf

. $TOKENFILE

AUTH=$(print -n "$OAUTH2_CLIENT:$OAUTH2_SECRET" | base64 -w0)
REDIR=$(urlencode "$OAUTH2_CALLBACK")

json=$(curl -s -H "Authorization: Basic $AUTH" -d "grant_type=refresh_token&refresh_token=$OAUTH2_REFRESH_TOKEN" "$OAUTH2_TOKEN_SERVER")

token=$(print "$json" | sed -e 's/.*"access_token":"\([^"]\+\)".*/\1/')

ed $TOKENFILE <<EOF
/OAUTH2_ACCESS_TOKEN/
d
a
OAUTH2_ACCESS_TOKEN="$token"
.
w
q
EOF

print $json; tail -1 $TOKENFILE
