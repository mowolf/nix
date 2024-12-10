update:
	nix flake update
rebuild: 
	darwin-rebuild switch --flake .#MacBook
check:
	darwin-rebuild check --flake .#MacBook

build:
	darwin-rebuild build --flake .#MacBook
Mo:		
	home-manager switch --flake .#Mo -b backup