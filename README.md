# Full installation

First, activate "Enable External Script Access" in EJBCA "System Configuration > External Scripts".

Then get the linters wrappers scripts:

```
# mkdir -p /opt/misc/linters/
# git clone https://github.com/hablutzel1/blobfish-ejbca-linters-wrappers.git /opt/misc/linters/wrappers/
```
Then configure each one of the validators as explained below.

*After installing and configuring each linter in EJBCA, test it with a real certificate.*

## CA/B Forum lint

### Installation

*All system users that intend to use this linters will require to be added to the rvm group as indicated below.*

First, a global RVM installation has to be completed like this:

```
$ command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
$ command curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg --import -
$ curl -L https://get.rvm.io | sudo bash -s stable
```

Then, current user will be added to `rvm` group:

```
# usermod -a -G rvm $USER
```

And `wildfly` user will be added to that group too:

```
# usermod -a -G rvm wildfly
```

Now it is required to modify the following file, `/opt/wildfly/bin/standalone.sh` like this at the top:

* FIXME: try not to do this as this will complicate WildFly maintenance. Look if standalone.sh has any method to source custom files and then probably copy from rvm.sh the minimum required to configure the RVM environment.

```
#!/bin/bash
source /etc/profile.d/rvm.sh
...
```

Then:

* TODO Confirm if the following "–default" will really apply globally in this system.

```
$ rvm install ruby-2.6.0
$ rvm use ruby-2.6.0 --default
$ gem install simpleidn
$ gem install public_suffix
```

Then:

* TODO update to the use of https://github.com/certlint/certlint as the AWS version has been archived. Look too for the official AWS archiving announcement.

```
# git clone https://github.com/awslabs/certlint.git /opt/misc/linters/certlint/
```

Then:

```
-- TODO try to avoid the need to do this and allow the user to execute 'ruby extconf.rb' with sudo.
# chown -R $USER /opt/misc/linters/certlint/
$ cd /opt/misc/linters/certlint/ext
$ ruby extconf.rb
$ make
```

* TODO confirm if it is required to restart OS or suffices with restarting wildfly service for applying RVM environment changes.

### EJBCA Validator

* **Name**: CA/B Forum lint
* **Validator Type**: External Command Certificate Validator
* **Full pathname of script**: `/opt/misc/linters/wrappers/cablintw.sh`

## X.509 lint

### Installation

```
-- TODO try to get the latest changes from the official https://github.com/kroeckx/x509lint. First check if the rwbaumg changes had already got to the official repo anyway, otherwise, maybe cherry pick the commits of interest in rwbaumg over the official repo.
# git clone https://github.com/rwbaumg/x509lint.git /opt/misc/linters/x509lint_rwbaumg
$ cd /opt/misc/linters/x509lint_rwbaumg
# git fetch --all
# git checkout -t origin/x19e-master
# make
```

### EJBCA Validator

* **Name**: X.509 lint
* **Validator Type**: External Command Certificate Validator
* **Full pathname of script**: `/opt/misc/linters/wrappers/x509lintw.sh`

## ZLint

### Installation

First, install Go. Always use the latest version available from https://golang.org/dl/.

```
$ wget -P ~/software/ https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz
-- TODO verify fingerprint in the Go recommended way (if any).
# tar -C /usr/local -xzf ~/software/go$VERSION.$OS-$ARCH.tar.gz
```

The install ZLint:

```
-- TODO make it a verbose operation
# GOPATH=/opt/misc/linters/zlint_go /usr/local/go/bin/go get github.com/zmap/zlint/cmd/zlint
```

### EJBCA Validator

* TODO check: It seems a bug in EJBCA to expect the %cert% argument in the command here... when it has been observed that this produces that the cert is /being sent to the STDIN instead of being sent as a regular parameter.

* **Name**: ZLint
* **Validator Type**: External Command Certificate Validator
* **Full pathname of script**: `/opt/misc/linters/wrappers/zlintw.sh %cert%`

# TODOS #
- Get sure that linters definitions are updated automatically and make sure too that wrappers would fail if the update doesn't succeed completely, e.g. failing to update restricted/special domains like example.org. Linters should be automatically updated to their latest versions and they should stop working if the update fails or is left in an inconsistent state. Maybe for this we should perform a final "git status" after the update or check the output of "git pull". Additionally maybe linters could be automatically tested during updates with a fixed test certificate for some expected output.
- Check if there are any official EJBCA linters wrappers, I think I saw something on this.
- Maybe create a base wrapper script for all three linters, e.g. by receiving the full linter command and expected output as arguments.
- Determine if the folder /opt/misc/linters/ is the most appropriate one for keeping all of this. See at the EJBCA Cloud for reference.
- Evaluate to install all linters under /usr/local/bin as recommended in https://bbs.archlinux.org/viewtopic.php?pid=1852209#p1852209.
- Work seriously on making the wrappers robust: Check the exit status for each linter when the input certificate is in a wrong format (e.g. PEM when expecting DER) or when the file can't be read.
- Study the best possible permissions to apply in /opt/misc/linters/wrappers.
- Allow wrappers to be configured for a set of given severities to fail for, e.g. only on error or fatal, or fail even for warning. The previous could be done with parameters.
- Test to configure an EJBCA validator to not fail on linter warnings, but just to log the event (maybe with an audit log entry?).
- Study https://github.com/rwbaumg/pki-lint and evaluate to migrate to it as it seems to be a wrapper for multiple third party linters.
