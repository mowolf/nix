update:
	nix flake update
rebuild: 
	sudo darwin-rebuild switch --flake .#MacBook
check:
	darwin-rebuild check --flake .#MacBook

build:
	darwin-rebuild build --flake .#MacBook
Mo:		
	home-manager switch --flake .#Mo -b backup

headroom-update:
	cd pkgs/headroom && nix run nixpkgs#uv -- lock --upgrade

cleanup-disk:
	./scripts/cleanup-disk.sh
