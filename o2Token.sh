#!/bin/ksh

TOKENFILE=$(type -p $0)
TOKENFILE=${TOKENFILE%/bin/*}/etc/${QBO_SANDBOX}qboTokens.conf

. $TOKENFILE

print "$OAUTH2_CONNECT_SERVER?client_id=$OAUTH2_CLIENT&response_type=code&scope=$(urlencode $QBO_SCOPE)&redirect_uri=$(urlencode "$OAUTH2_CALLBACK")&state=$(urlencode $TOKENFILE)"
