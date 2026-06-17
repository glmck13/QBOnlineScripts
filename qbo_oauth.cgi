#!/bin/ksh

vars="$QUERY_STRING"
while [ "$vars" ]
do
	print $vars | IFS='&' read v vars
	[ "$v" ] && export $v
done

TOKENFILE=$(urlencode -d $state)
[ -f $TOKENFILE ] && . $TOKENFILE
AUTH=$(print -n "$OAUTH2_CLIENT:$OAUTH2_SECRET" | base64 -w0)
REDIR=$(urlencode "$OAUTH2_CALLBACK")
json=$(curl -s -H "Authorization: Basic $AUTH" -d "grant_type=authorization_code&code=$code&redirect_uri=$REDIR" "$OAUTH2_TOKEN_SERVER")

refresh_token=$(jq -r .refresh_token <<<${json})
access_token=$(jq -r .access_token <<<${json})

sed -i \
	-e "s/^OAUTH2_REFRESH_TOKEN=.*/OAUTH2_REFRESH_TOKEN=\"${refresh_token}\"/" \
	-e "s/^OAUTH2_ACCESS_TOKEN=.*/OAUTH2_ACCESS_TOKEN=\"${access_token}\"/" \
$TOKENFILE

print "Content-type: text/html\n"
print "<html>"
print "<pre>"
jq . <<<${json}
print "</pre>"
print "</html>"
