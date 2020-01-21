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
-- TODO try to get the latest changes from the official x509lint too. First check if these rwbaumg changes had already get to the official repo anyway, otherwise, maybe cherry pick the commits of interest in rwbaumg over the official repo.
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

# TODOS #
- Get sure that linters definitions are updated automatically and make sure too that wrappers would fail if the update doesn't succeed completely, e.g. failing to update restricted/special domains like example.org. Linters should be automatically updated to their latest versions and they should stop working if the update fails or is left in an inconsistent state. Maybe for this we should perform a final "git status" after the update or check the output of "git pull". Additionally maybe linters could be automatically tested during updates with a fixed test certificate for some expected output.
- Check if there are any official EJBCA linters wrappers, I think I saw something on this.
- Maybe create a base wrapper script for all three linters, e.g. by receiving the full linter command and expected output as arguments.
