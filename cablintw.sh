#!/bin/sh
# TODO allow to receive as arguments the different severities to produce an error exit code, e.g. E:, W:, etc.
# TODO check: the -5 in 'grep' seems overkilling.
# "B" (Bug) and "F" (Fatal Error) (see https://github.com/awslabs/certlint#user-content-output) should ALWAYS be recognized as errors too. TODO check if certlint produces an 1 exit code for these or under any other circumstance.
# TODO check zlintw.sh where
OUTPUT=$(ruby -I /opt/misc/linters/certlint/lib:/opt/misc/linters/certlint/ext /opt/misc/linters/certlint/bin/cablint $1 | grep -5 '^[BFWE]: ')
# TODO confirm if $? is guaranteed to be <> 0 if any of the previous piped commands fail, i.e. ruby and grep.
if [ $? -eq 0 ]; then
  if [ -z "$OUTPUT" ]; then
    # TODO maybe unnecesary output!.
    echo "No error in cablint"
    exit 0
  else
    # TODO maybe unnecesary output!.
    echo "Error in cablint:"
    echo "$OUTPUT" >&2
    exit 1
  fi
else
  echo "certlint execution failed"
  exit 1
fi
