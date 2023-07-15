# Full installation

First, activate "Enable External Script Access" in EJBCA "System Configuration > External Scripts".

Then get the linters wrappers scripts:

```
sudo mkdir -p /opt/misc/linters/
sudo git clone https://github.com/hablutzel1/blobfish-ejbca-linters-wrappers.git /opt/misc/linters/wrappers/
```
Then configure each one of the validators as explained below.

*After installing and configuring each linter in EJBCA, test it with some real certificates, e.g. one with problems and another without them.*

## CA/B Forum lint

### Installation

* NOTE that this is in the process of being automated with Ansible in https://bitbucket.org/blobfisheirl/blobfish-recommended-server-base-configuration-deprecated/src/master/linter_certlint.yml.

```
sudo apt-get install ruby ruby-dev build-essential git  
sudo gem install simpleidn
sudo gem install public_suffix
```

Then:

```
sudo git clone https://github.com/certlint/certlint.git /opt/misc/linters/certlint/
```

Then:

```
cd /opt/misc/linters/certlint/ext
sudo ruby extconf.rb
sudo make
```

### EJBCA Validator

* **Name**: CA/B Forum lint
* **Validator Type**: External Command Certificate Validator
* **Full pathname of script**: `/opt/misc/linters/wrappers/cablintw.sh`

## X.509 lint

### Installation

* NOTE that this is in the process of being automated with Ansible in https://bitbucket.org/blobfisheirl/blobfish-recommended-server-base-configuration-deprecated/src/master/linter_x509lint.yml.

```
# TODO check if there is still anything useful in https://github.com/rwbaumg/x509lint.git.
sudo git clone https://github.com/kroeckx/x509lint /opt/misc/linters/x509lint
cd /opt/misc/linters/x509lint
sudo make
```

### EJBCA Validator

* **Name**: X.509 lint
* **Validator Type**: External Command Certificate Validator
* **Full pathname of script**: `/opt/misc/linters/wrappers/x509lintw.sh`

## ZLint

### Installation

* NOTE that this is in the process of being automated with Ansible in https://bitbucket.org/blobfisheirl/blobfish-recommended-server-base-configuration-deprecated/src/master/linter_zlint.yml.

First, install Go >=1.12

```
apt-cache madison golang | grep 'Packages$'
sudo apt install golang
```

Then install ZLint:

```
# TODO make it a verbose operation
sudo GOPATH=/opt/misc/linters/zlint_go go get github.com/zmap/zlint/v3/cmd/zlint
```

### EJBCA Validator

* TODO check: It seems a bug in EJBCA to expect the %cert% argument in the command here... when it has been observed that this produces that the cert is /being sent to the STDIN instead of being sent as a regular parameter.

* **Name**: ZLint
* **Validator Type**: External Command Certificate Validator
* **Full pathname of script**: `/opt/misc/linters/wrappers/zlintw.sh %cert%`

# TODOS #
- Instead of maintaining these wrappers and sort out the process to keep the linters updated, evaluate to simply use an external service. See  https://groups.google.com/g/mozilla.dev.security.policy/c/oTQ9OYgS8D4. Note that it even seems that the associated source code is open source, e.g. https://github.com/crtsh/certwatch_db/blob/master/linting/lint_certificate.fnc.
- Get sure that linters definitions are updated automatically and make sure too that wrappers would fail if the update doesn't succeed completely, e.g. failing to update restricted/special domains like example.org. Linters should be automatically updated to their latest versions and they should stop working if the update fails or is left in an inconsistent state. Maybe for this we should perform a final "git status" after the update or check the output of "git pull". Additionally maybe linters could be automatically tested during updates with some fixed test certificates for some expected output.
- Check if there are any official EJBCA linters wrappers, I think I saw something on this.
- Maybe create a base wrapper script for all three linters, e.g. by receiving the full linter command and expected output as arguments.
- Determine if the folder /opt/misc/linters/ is the most appropriate one for keeping all of this. See at the EJBCA Cloud for reference.
- Evaluate to install all linters under /usr/local/bin as recommended in https://bbs.archlinux.org/viewtopic.php?pid=1852209#p1852209.
- Work seriously on making the wrappers robust: Check the exit status for each linter when the input certificate is in a wrong format (e.g. PEM when expecting DER) or when the file can't be read.
- Study the best possible permissions to apply in /opt/misc/linters/wrappers.
- Allow wrappers to be configured for a set of given severities to fail for, e.g. only on error or fatal, or fail even for warning. The previous could be done with parameters.
- Test to configure an EJBCA validator to not fail on linter warnings, but just to log the event (maybe with an audit log entry?).
- Study https://github.com/rwbaumg/pki-lint and evaluate to migrate to it as it might be a better maintained wrapper for multiple third party linters.
