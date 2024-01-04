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
# TODO get sure that an error like the following still will produce error: "FATA[0000] unable to parse certificate: x509: certificate name constraint contained IP address range of length 0" as this was the reason for the previous incorrect commit.
# TODO revert the previous incorrect commit appropriately, it was generating no errors for OISTEWISeKeyGlobalRootGBCA.cacert.pem which has problems.
# FIXME the following type of problem should produce an error: /opt/misc/linters/wrappers/zlintw.sh: 17: /opt/misc/linters/wrappers/zlintw.sh: /opt/misc/linters/zlint_go/bin/zlint: Permission denied\nNo error in zlint
# TODO stop excluding w_subject_common_name_included when Pedro agrees on removing it, https://wisekey.slack.com/archives/C01CH1PSUHM/p1704386438294709.
OUTPUT=$(/opt/misc/linters/zlint_go/bin/zlint -pretty -excludeNames w_subject_common_name_included <&0 | grep -1 '"warn"\|"error"\|"fatal"')
if [ $? -eq 0 ] || [ $? -eq 1 ]; then
  if [ -z "$OUTPUT" ]; then
    echo "No error in zlint"
    exit 0
  else
    echo "Error in zlint"
    echo $OUTPUT >&2
    exit 1
  fi
else
  echo "zlint execution failed"
  exit 1
fi

