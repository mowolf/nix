# Nix Packages https://search.nixos.org/packages
# Home Manager https://home-manager-options.extranix.com
{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      environment = {
        systemPackages = [ 
          pkgs.home-manager
          pkgs.awscli2
          pkgs.nodejs_22
          pkgs.pnpm
          pkgs.exiftool
        ];
        shells = [
          pkgs.bashInteractive
          pkgs.zsh
          pkgs.fish
        ];
      };

      fonts.packages =[
        pkgs.nerd-fonts.monaspace
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system = {
        stateVersion = 5;
        configurationRevision = self.rev or self.dirtyRev or null;

        # can be found by running: `defaults find ${word}`
        defaults.CustomUserPreferences = {
          "com.apple.WindowManager" = {
            EnableTiledWindowMargins = 0;
          };
          # "Apple Global Domain" = {
          #  "com.apple.trackpad.scaling" = 5;
          #};
        };

        # normally you would need to logout login so preferences take effect
        activationScripts.postUserActivation.text = ''
          # Following line should allow us to avoid a logout/login cycle
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';
      };
      # Add ability to used TouchID for sudo authentication
      security.pam.enableSudoTouchIdAuth = true;

      users.users.mo = {
        name = "Mo";
        home = "/Users/Mo";
      };

      homebrew = {
        enable = true;
        # updates homebrew packages on activation,
        # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
        onActivation.autoUpdate = true;
        casks = [
          "signal"
          "webstorm"
          "phpstorm"
          "visual-studio-code"
          "docker"
          "spotify"
        ];
        brews = [
          "autojump"
        ];
        masApps = {
          "Bitwarden" = 1352778147;
        };
      };

      programs = {
        # Create /etc/zshrc that loads the nix-darwin environment.
        zsh.enable = true;
        fish.enable = true;
        # Avoid bugs with npm like https://github.com/NixOS/nixpkgs/issues/16441
        pnpm.enable = true;
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook
    darwinConfigurations."MacBook" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager switch --flake .#Mo -b backup'
    homeConfigurations = {
        "Mo" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit self inputs;
          };
          modules = [ ./home-manager/home.nix ];
        };
      };
  };
}
