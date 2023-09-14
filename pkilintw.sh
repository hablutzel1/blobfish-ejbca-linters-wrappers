#!/bin/bash

source /opt/misc/linters/pkilint/venv/bin/activate
#source /Users/jhablutzel/Documents/certificate_linters/pkilint/venv/bin/activate

# TODO return the severity back to NOTICE. It will require some way to exclude the CPS CP qualifier validation from the NOTICE level. Maybe I can create an specific exception for that check only.
lint_cabf_smime_cert lint -d -s WARNING "$@"

exit_code=$?

# TODO check: needed?
deactivate

exit $exit_code
