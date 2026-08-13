host := "nixos"

default:
    @just --list

# --- NixOS ---

# check the configuration builds without switching
build:
    nh os build .#{{host}}

# activate without setting as the boot default
try:
    nh os test .#{{host}}

# activate and set as boot default
switch:
    git add -A
    nh os switch .#{{host}}

# run flake checks
check:
    nix flake check

# format the tree with alejandra
fmt:
    alejandra .

# update flake inputs
update:
    nix flake update

# garbage collect
clean:
    nh clean all

# --- git ---

push:
    git push

status:
    git status

diff:
    git diff

log:
    git log --oneline --graph -20

show:
    git show --stat HEAD
