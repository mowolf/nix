
!! To Update run `make rebuild`

Nix OS
  Deinstallation:
https://nix.dev/manual/nix/2.25/installation/uninstall.html

Installation
 1. Install Lyx
https://lix.systems/install/
 2. Install nix-davin
nix run nix-darwin -- switch --flake ~/.config/nix
 3. Set this as your terminal:
/run/current-system/sw/bin/fish

4. Navigate to `.config/nix` and download nix configs from the GitHub repo https://github.com/mowolf/nix
 Run the commands
   cd home-manager
   home-manager init  cd .. make build make Mo


Tipps
 Always restart terminal when something does not work

Save NixStore password, if keychain gets corruptt...

SSA Cert issues
sudo rm /etc/ssl/certs/ca-certificates.crt
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt   # nix
installed with lix: https://lix.systems/install/
source/build system
```fish
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
```
update system:
```fish
nix flake update
```
## homemanager
damit kann man alles an user settings einstellen
[Appendix A. Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml)

## fish not working
https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1782971499
das war in conf.d ordner in der brew installation, wo ichs deinstaliert hab:
```fish
# Nix

if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'

. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'

end

# End Nix
```

es kann gut sein, dass fish nicht als shell auftaucht (weil das sudo braucht und somit home manager nicht machen kann).

```shell
cat /etc/shells
```

dann muss mans halt selber hinzufügen;
iterm aktualisiert nicht so schnell, muss eventuell neugestartet werden

## Garbage collection
```shell
# löscht zeug vom nix stuff
sudo nix-collect-garbage --delete-older-than 60d
# ohne sudo dann von home manager

# optimiert stuff in den derivatives und erstellt hardlinks, dann existieren files wirklich nur einmal
nix-store --optimise
```
## links von miguel
https://xyno.space/post/nix-darwin-introduction
https://github.com/LnL7/nix-darwin
https://noghartt.dev/blog/set-up-nix-on-macos-using-flakes-nix-darwin-and-home-manager/
https://xyno.space/post/nix-darwin-introduction
https://github.com/kivikakk/vyxos
https://kirarin.hootr.club/git/steinuil/flakes
https://git.sr.ht/~fd/nix-configs
https://github.com/thornycrackers/nix-config
https://github.com/shazow/nixfiles
https://www.youtube.com/watch?v=ARjAsEJ9WVY
https://iterm2.com/documentation-dynamic-profiles.html
https://github.com/MatthiasBenaets/nix-config/blob/master/darwin/default.nix
https://daiderd.com/nix-darwin/manual/index.html#opt-fonts.packages
https://github.com/ironicbadger/nix-config
https://macos-defaults.com/
https://github.com/ironicbadger/nix-config/blob/80f5fec36fcda7ded0601f07ac3efd60c0688768/hosts/common/darwin-common.nix#L253
https://iterm2.com/documentation/2.1/documentation-hidden-settings.html
https://www.youtube.com/live/VkkUzggJejo?si=6FZTpWb6auaeftPF
https://ianthehenry.com/posts/how-to-learn-nix/introduction/

multi user setup:
https://github.com/Misterio77/nix-starter-configs/blob/cd2634edb7742a5b4bbf6520a2403c22be7013c6/standard/flake.nix#L67

# auto completions in flakes
Wenn nicht installier, suche flake wo steht wie die autocompletions installiert werden. Suche Definition von wo der bash command definiert wird und entweder das direkt kopieren ode rüber Inputs reinladen 
