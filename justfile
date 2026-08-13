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
    nh os switch .#{{host}}

# build and set as next boot default without activating (boot/kernel/initrd changes — verify via reboot, not switch)
boot:
    nh os boot .#{{host}}

# run flake checks
check:
    nix flake check

# format the tree with alejandra
fmt:
    alejandra .

# update flake inputs
update:
    nix flake update

# update all flake inputs and switch, with confirmation before activating
upgrade:
    nh os switch --update --ask

# update a single flake input and switch, with confirmation before activating
upgrade-input name:
    nh os switch --update-input {{name}} --ask

# roll back to the previous generation
rollback:
    nh os rollback

# search nixpkgs for a package
search query:
    nh search {{query}}

# search NixOS/Home Manager options
options query:
    nh search options {{query}}

# garbage collect
clean:
    nh clean all

# --- git ---

# git add
add:
    git add -A

# git commit
commit message:
    git commit -m "{{message}}"

# git push
push:
    git push

# git status
status:
    git status

# git diff
diff:
    git diff

# git log
log:
    git log --oneline --graph -20

# git show
show:
    git show --stat HEAD
