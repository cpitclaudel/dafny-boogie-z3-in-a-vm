# Run Dafny, Boogie, and Z3 from a virtual machine -- no setup needed

This repo contains a [Vagrantfile](https://www.vagrantup.com/) to help quickly set up a virtual machine running [Dafny](http://research.microsoft.com/en-us/projects/dafny/), [Boogie](http://research.microsoft.com/en-us/projects/boogie/), and [Z3](https://github.com/Z3Prover/z3).

The setup includes the three verifiers, and a bare Emacs setup pre-loaded with [boogie-friends](https://github.com/boogie-org/boogie-friends).

## Local setup

To set up a Dafny environment in your own VM, copy `provision.sh` and `init.el` to it, and run

```bash
BASEDIR="$HOME" ./provision.sh
```

Feel free to study the [provisioning script](provision.sh) for more information.
