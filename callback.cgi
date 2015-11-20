#!/bin/ksh

VERFILE=oauth_verifier

print "$QUERY_STRING&" | tr '&' '\n' | grep oauth_verifier >$VERFILE

print "Content-type: text/html\\n\\n"
print "<html>"
print "<pre>"
print QUERY_STRING=$QUERY_STRING
ls -l $PWD/$VERFILE
cat $VERFILE
print "</pre>"
print "</html>"
