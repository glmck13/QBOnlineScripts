#!/bin/ksh

vars="$QUERY_STRING"
while [ "$vars" ]
do
	print $vars | IFS='&' read v vars
	[ "$v" ] && export $v
done

TOKENFILE=/home/pi/etc/${QBO_SANDBOX}qboTokens.conf; . $TOKENFILE
AUTH=$(print -n "$OAUTH2_CLIENT:$OAUTH2_SECRET" | base64 -w0)
REDIR=$(urlencode "$OAUTH2_CALLBACK")
curl -s -H "Authorization: Basic $AUTH" -d "grant_type=authorization_code&code=$code&redirect_uri=$REDIR" "$OAUTH2_TOKEN_SERVER" >oauth.txt 2>&1

print "Content-type: text/html\\n\\n"
print "<html>"
print "<pre>"
cat oauth.txt
print "</pre>"
print "</html>"
