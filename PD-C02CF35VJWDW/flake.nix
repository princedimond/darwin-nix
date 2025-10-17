{
  description = "PD-C02CF35VJWDW iMac nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
          pkgs.tmux
          pkgs.warp-terminal
	  pkgs.zed-editor
	  pkgs.evil-helix
	  pkgs.helix-gpt
        ];

     homebrew = {
       enable = true;
       brews = [
         "mas"
       ];
       casks = [
         "the-unarchiver"
	 "microsoft-edge"
	 "chrome-remote-desktop-host"
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
	 "Bitwarden" = 1352778147;
	 "TailScale" = 1475387142;
       };
       onActivation.cleanup = "zap";
       onActivation.autoUpdate = true;
       onActivation.upgrade = true;
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
      
      programs.git = {
        config = {
	      enable = true;
	      userName = "princedimond";
	      userEmail = "princedimond@gmail.com";
	      };
      };
      

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
