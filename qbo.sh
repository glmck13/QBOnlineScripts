#!/bin/ksh

METHOD=${1:?Enter METHOD}
API=${2:?Enter API URI}
shift; shift
case "$METHOD" in
	GET|POST)
		;;
	*)
		print "METHOD not recognized: $METHOD"; exit
		;;
esac

PARAMS=""
while [ "$*" ]; do
	PARAMS+="${1%%=*}=$(urlencode "${1#*=}")"; shift
done

TOKENFILE=$HOME/etc/${QBO_SANDBOX}qboTokens.conf

. $TOKENFILE

URL=$(eval print ${QBO_APIBASE}${API})

OAUTH="$OAUTH_CONSUMER_KEY&$OAUTH_NONCE&$OAUTH_SIGNATURE_METHOD&$OAUTH_TIMESTAMP&$OAUTH_TOKEN&$OAUTH_VERSION"
[ "$PARAMS" ] && OAUTH+="&$PARAMS"

BASE="$METHOD&$(urlencode "$URL")&$(urlencode "$OAUTH")"
SIGNATURE=$(echo -n "$BASE" | openssl dgst -sha1 -binary -hmac "${OAUTH_CONSUMER_SECRET#*=}&${OAUTH_TOKEN_SECRET#*=}" | base64 | xargs urlencode)
OAUTH+="&oauth_signature=$SIGNATURE"

case "$METHOD" in

	GET)
		curl -s -H "Accept: application/$QBO_FORMAT" "$URL?$OAUTH"
		;;

	POST)
		curl -s -H "Accept: application/$QBO_FORMAT" -H "Content-Type: application/$QBO_FORMAT" -d @- "$URL?$OAUTH"
		;;
esac

print
