#!/bin/ksh

ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
CHARS=${#ALPHABET}

len=$(shuf -i 16-32 -n 1)

NONCE=""
while [[ "$len" > 0 ]]; do
	i=$(shuf -i 1-$CHARS -n 1); (( --i ))
	NONCE+=${ALPHABET:$i:1}
	(( --len ))
done

print $NONCE
