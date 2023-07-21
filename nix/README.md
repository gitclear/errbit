# Nix devshell for errbit

This directory contains files for systems using the `nix` package manager. It
can be used to enter a [`devshell`](https://github.com/numtide/devshell/),
similar to a python virtual environment, that has all required dependencies
installed, just locally in this project's directory.

1. Install the `nix` package manager https://nixos.org/download.html.
2. Enable the nix flakes experimental feature.
```
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```
3. Run the following to enter the `devshell` with all required dependencies
installed.
```
nix develop --impure ./nix
```

#### Optional:
To automatically enter `devshell` when changing to this directory, install
[`direnv`](https://direnv.net/) globally and run:
```
direnv allow
```
