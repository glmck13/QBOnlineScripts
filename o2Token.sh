#!/bin/ksh

LOGFILE=/tmp/qbo.log
TOKENFILE=$HOME/etc/${QBO_SANDBOX}qboTokens.conf

. $TOKENFILE

print "$OAUTH2_CONNECT_SERVER?client_id=$OAUTH2_CLIENT&response_type=code&scope=$QBO_SCOPE&redirect_uri=$(urlencode "$OAUTH2_CALLBACK")&state=none"
