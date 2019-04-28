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

case "$METHOD" in

	GET)
		curl -s -H "Authorization: Bearer $OAUTH2_ACCESS_TOKEN" -H "Accept: application/$QBO_FORMAT" "$URL?$PARAMS"
		;;

	POST)
		curl -s -H "Authorization: Bearer $OAUTH2_ACCESS_TOKEN" -H "Accept: application/$QBO_FORMAT" -H "Content-Type: application/$QBO_FORMAT" -d @- "$URL?$PARAMS"
		;;
esac

print
