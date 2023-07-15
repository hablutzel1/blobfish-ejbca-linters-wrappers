#!/bin/sh
# TODO allow to receive as arguments the different severities to produce an error exit code, e.g. E:, W:, etc.
# TODO check: the -5 in 'grep' seems overkilling.
# "B" (Bug) and "F" (Fatal Error) (see https://github.com/awslabs/certlint#user-content-output) should ALWAYS be recognized as errors too. TODO check if certlint produces an 1 exit code for these or under any other circumstance.
# TODO check zlintw.sh where
# TODO get sure that if the following fails for permissions (e.g. in /opt/misc/linters/certlint/ext) the overall wrapper will fail.
# FIXME: the following error is not triggering a validation error from EJBCA: Exit code: 0STDOUT: No error in cablintERROUT: /opt/misc/linters/wrappers/cablintw.sh: 7: /opt/misc/linters/wrappers/cablintw.sh: ruby: not found
OUTPUT=$(ruby -I /opt/misc/linters/certlint/lib:/opt/misc/linters/certlint/ext /opt/misc/linters/certlint/bin/cablint $1 | grep -5 '^[BFWE]: ')
# TODO check if the following conditional is really ok!. Note that exit code 1 is being accepted as OK because 'grep' exits like that when it doesn't find any match, but it could produce unexpected results because of the previous 'ruby' execution, isn't it?.
if [ $? -eq 0 ] || [ $? -eq 1 ]; then
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
