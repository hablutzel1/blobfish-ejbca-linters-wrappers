#!/bin/bash

source /opt/misc/linters/pkilint/venv/bin/activate
#source /Users/jhablutzel/Documents/certificate_linters/pkilint/venv/bin/activate

# TODO try to enable at least the WARNING level.
lint_cabf_serverauth_cert lint -d -s ERROR "$@"

exit_code=$?

# TODO check: needed?
deactivate

exit $exit_code
