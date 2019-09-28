#!/bin/ksh

LOGFILE=/tmp/qbo.log
TOKENFILE=$HOME/etc/${QBO_SANDBOX}qboTokens.conf

. $TOKENFILE

OAUTH="$OAUTH_CONSUMER_KEY&$OAUTH_NONCE&$OAUTH_SIGNATURE_METHOD&$OAUTH_TIMESTAMP&$OAUTH_TOKEN&$OAUTH_VERIFIER&$OAUTH_VERSION"

BASE="GET&$(urlencode "$OAUTH_ACCURL")&$(urlencode "$OAUTH")"
SIGNATURE=$(echo -n "$BASE" | openssl dgst -sha1 -binary -hmac "${OAUTH_CONSUMER_SECRET#*=}&${OAUTH_TOKEN_SECRET#*=}" | base64 | xargs urlencode)
OAUTH+="&oauth_signature=$SIGNATURE"

curl -s "$OAUTH_ACCURL?$OAUTH" | tee $LOGFILE

(
grep -v TOKEN
echo $(<$LOGFILE)\& | sed -e "s/\([a-z_]*\)=/\U&\"\L&/g" -e "s/\&/\"&/g" | tr '&' '\n' | grep TOKEN
) <$TOKENFILE >$TOKENFILE-tmp; mv $TOKENFILE-tmp $TOKENFILE
