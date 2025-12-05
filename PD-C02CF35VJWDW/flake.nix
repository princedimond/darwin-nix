{
  description = "PD-C02CF35VJWDW iMac nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    #Nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      nixvim,
      home-manager,
    }:
    let
      configuration =
        { pkgs, config, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.neovim
            pkgs.tmux
            pkgs.warp-terminal
            pkgs.zed-editor
            pkgs.evil-helix
            pkgs.helix-gpt
            pkgs.fastfetch
            pkgs.onefetch
            pkgs.nixd
            pkgs.nil
            pkgs.gitkraken
            pkgs.nh
            pkgs.bitwarden-desktop
            pkgs.reaper
            pkgs.audacity
            pkgs.the-unarchiver
	    pkgs.input-leap
            #pkgs.streamdeck-ui
          ];

          homebrew = {
            enable = true;
            brews = [
              "mas"
              "nvm"
            ];
            casks = [
              "microsoft-edge"
              "chrome-remote-desktop-host"
              "ferdium"
              "expressvpn"
              "onlyoffice"
              "vlc"
              "opencore-patcher"
              "lmms"
              "elgato-stream-deck"
            ];
            masApps = {
              "Davinci Resolve" = 571213070;
              "GarageBand" = 682658836;
              "iMovie" = 408981434;
              "dJay" = 450527929;
              "OneDrive" = 823766827;
              "OneNote" = 784801555;
              "HP Easy Scan" = 967004861;
              "HP Print & Support" = 1474276998;
              "TailScale" = 1475387142;
              "Windows App" = 1295203466;
              "Donner Control" = 6738984734;
            };
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          # Other package configs

          # Other Environment Configs
          environment.shellAliases = {
            fr = "nh darwin switch --hostname PD-C02CF35VJWDW /Users/princedimond/darwin-nix/PD-C02CF35VJWDW";
            fu = "nh darwin switch --hostname PD-C02CF35VJWDW /Users/princedimond/darwin-nix/PD-C02CF35VJWDW --update";
            v = "nvim";
          };

          # Define System Services to be enabled
          services = {
            tailscale.enable = true;
            #nixd.enable = true;
            #nil.enable = true;
          };

          # Define Primary User for nix-darwin/homebrew invocation issues
          system.primaryUser = "princedimond";

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          #Allow unfree/insecure Packages
          nixpkgs.config = {
            allowUnfree = true;
            permittedInsecurePackages = [
            ];
          };

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version and other git options.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          system.defaults = {
            NSGlobalDomain.AppleICUForce24HourTime = true;
            magicmouse.MouseButtonMode = "TwoButton";
            finder = {
              ShowPathbar = true;
              ShowStatusBar = true;
              FXDefaultSearchScope = "SCcf";
              _FXSortFoldersFirst = true;
              NewWindowTarget = "Home";
            };
            WindowManager = {
              EnableTiledWindowMargins = false;
            };
            dock = {
              minimize-to-application = true;
              tilesize = 40;
              largesize = 100;
              magnification = true;
              wvous-bl-corner = 2;
              show-recents = false;
              persistent-apps = [
                "/Applications/Microsoft Edge.app"
                "/System/Applications/Mail.app"
                "/System/Applications/Messages.app"
                "/System/Applications/FaceTime.app"
                "/Applications/Ferdium.app"
                "/Applications/Nix Apps/Zed.app"
                "/Applications/Nix Apps/Warp.app"
                #"/Applications/Weather.app"
                "/System/Applications/App Store.app"
                "/System/Applications/System Settings.app"
              ];
              persistent-others = [
                {
                  folder = {
                    path = "/Applications";
                    showas = "grid";
                    displayas = "folder";
                  };
                }
                {
                  folder = {
                    path = "/Users/princedimond";
                    showas = "grid";
                    displayas = "folder";
                  };
                }
                {
                  folder = {
                    path = "/Users/princedimond/Downloads";
                    showas = "grid";
                    displayas = "folder";
                  };
                }
              ];
            };
          };

          /*
            programs.git.settings = {
              config = {
                enable = true;
                userName = "princedimond";
                userEmail = "princedimond@gmail.com";
              };
            };
          */

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "x86_64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."PD-C02CF35VJWDW" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          inputs.nixvim.nixDarwinModules.nixvim
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              # Apple Silicon Only
              #enableRosetta = true;
              # User owning homebrew prefix
              user = "princedimond";
              #Use if homebrew was previously installed
              #autoMigrate = true;
            };
          }
        ];
      };
    };
}
