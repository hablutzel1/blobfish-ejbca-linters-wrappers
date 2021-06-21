#!/bin/sh
#################
# Take into account TODOS/comments in cablintw.sh.
#################

# Start of Cygwin tests
#PATH=$PATH:/bin/
#openssl x509 -inform DER -in "$1" -out tmp.pem
#dos2unix tmp.pem 2>/dev/null
#OUTPUT=`/cygdrive/c/Users/hablu/go/bin/zlint.exe -pretty tmp.pem`
#OUTPUT=`echo "$OUTPUT" | grep -1 '"info"\|"warn"\|"error"\|"fatal"'`
# End of Cygwin tests

# TODO try to simplify it more, we might even stop requiring to use the current wrapper.
OUTPUT=$(/opt/misc/linters/zlint_go/bin/zlint -pretty <&0 2>&1)
if [ $? -eq 0 ]; then
    echo "No error in zlint"
    exit 0
else
    echo "Error in zlint"
    echo $OUTPUT >&2
    exit 1
fi
