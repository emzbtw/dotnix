host := "nixos"

default:
    @just --list --unsorted

# --- nixos ---

# check the configuration builds without switching
[group('nixos')]
build:
    nh os build .#{{host}}

# activate without setting as the boot default
[group('nixos')]
test:
    nh os test .#{{host}}

# activate and set as boot default
[group('nixos')]
switch:
    nh os switch .#{{host}}

# build and set as next boot default without activating (boot/kernel/initrd changes — verify via reboot, not switch)
[group('nixos')]
boot:
    nh os boot .#{{host}}

# run flake checks
[group('nixos')]
check:
    nix flake check

# format the tree with alejandra
[group('nixos')]
fmt:
    alejandra .

# update flake inputs
[group('nixos')]
update:
    nix flake update

# update all flake inputs and switch, with confirmation before activating
[group('nixos')]
upgrade:
    nh os switch --update --ask

# update a single flake input and switch, with confirmation before activating
[group('nixos')]
upgrade-input name:
    nh os switch --update-input {{name}} --ask

# roll back to the previous generation
[group('nixos')]
rollback:
    nh os rollback

# search nixpkgs for a package
[group('nixos')]
search query:
    nh search {{query}}

# search NixOS/Home Manager options
[group('nixos')]
options query:
    nh search options {{query}}

# garbage collect
[group('nixos')]
clean:
    nh clean all

# --- git ---

# git add
[group('git')]
add:
    git add -A

# git commit
[group('git')]
commit message:
    git commit -m "{{message}}"

# git push
[group('git')]
push:
    git push

# git status
[group('git')]
status:
    git status

# git diff
[group('git')]
diff:
    git diff

# git log
[group('git')]
log:
    git log --oneline --graph -20

# git show
[group('git')]
show:
    git show --stat HEAD
