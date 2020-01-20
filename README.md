# Installation #

```
$ sudo mkdir -p /opt/misc/linters/
$ sudo git clone https://github.com/hablutzel1/blobfish-ejbca-linters-wrappers.git /opt/misc/linters/wrappers/
```
# Linters installation and EJBCA validators configuration #

Currently documented at https://confluence.blobfish.pe/x/KpUiAw (TODO evaluate to move this documentation here).

# TODOS #
- Get sure that linters definitions are updated automatically and make sure too that wrappers would fail if the update doesn't succeed completely, e.g. failing to update restricted/special domains like example.org. Linters should be automatically updated to their latest versions and they should stop working if the update fails or is left in an inconsistent state. Maybe for this we should perform a final "git status" after the update or check the output of "git pull". Additionally maybe linters could be automatically tested during updates with a fixed test certificate for some expected output.
- Check if there are any official EJBCA linters wrappers, I think I saw something on this.
- Maybe create a base wrapper script for all three linters, e.g. by receiving the full linter command and expected output as arguments.
