#!/bin/bash

source /opt/misc/linters/pkilint/venv/bin/activate
#source /Users/jhablutzel/Documents/certificate_linters/pkilint/venv/bin/activate

# FIXME increase the severity. It will require some way to exclude the CPS CP qualifier validation from the NOTICE level as well as a way to exclude the following WARNING: cabf.smime.german_ntr_registration_reference_not_euid (WARNING): Registration Reference is not in EUID format: "HRB 98213 B”.  Maybe I can create an specific exception for those checks only.
lint_cabf_smime_cert lint -d -s ERROR "$@"

exit_code=$?

# TODO check: needed?
deactivate

exit $exit_code
