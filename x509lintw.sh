#!/bin/bash
#################
# Take into account TODOS/comments in cablintw.sh.
#################

# Transform $1 from DER to PEM.
tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
openssl x509 -inform DER -in $1 -outform PEM -out $tmpfile
OUTPUT=$(/opt/misc/linters/x509lint_rwbaumg/x509lint-sub $tmpfile | grep -5 '^[WE]: ')
if [ $? -eq 0 ]; then
  rm $tmpfile
  if [ -z "$OUTPUT" ]; then
    echo "No error in x509lint"
    exit 0
  else
    echo "Error in x509lint:"
    echo "$OUTPUT" >&2
    exit 1
  fi
else
  echo "x509lint execution failed"
  exit 1
fi
