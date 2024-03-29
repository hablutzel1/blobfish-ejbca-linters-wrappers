#!/bin/bash
#################
# Take into account TODOS/comments in cablintw.sh.
#################

# FIXME the wrapper should fail and not output 0: Exit code: 0STDOUT: No error in x509lintERROUT: /opt/misc/linters/wrappers/x509lintw.sh: line 9: /opt/misc/linters/x509lint/x509lint: Permission denied
# Transform $1 from DER to PEM.
tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
openssl x509 -inform DER -in $1 -outform PEM -out $tmpfile
OUTPUT=$(/opt/misc/linters/x509lint/x509lint $tmpfile | grep -5 '^[WE]: ')
if [ $? -eq 0 ] || [ $? -eq 1 ]; then
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
