# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a nix-darwin system configuration flake for managing a macOS system declaratively. The configuration manages:
- System packages via Nix
- Homebrew packages, casks, and Mac App Store apps
- System settings and user configuration

## Commands

### Building and Applying Changes

**Build and switch the configuration:**
```bash
darwin-rebuild switch --flake .#PD-C02CF35VJWDW
```

**Build without switching (for testing):**
```bash
darwin-rebuild build --flake .#PD-C02CF35VJWDW
```

**Check configuration for errors:**
```bash
nix flake check
```

**Update flake inputs:**
```bash
nix flake update
```

**Update a specific input:**
```bash
nix flake lock --update-input nixpkgs
```

**View changelog:**
```bash
darwin-rebuild changelog
```

### Debugging

**Show flake metadata:**
```bash
nix flake show
```

**Show configuration evaluation:**
```bash
nix eval .#darwinConfigurations.PD-C02CF35VJWDW.config.environment.systemPackages --apply builtins.length
```

## Architecture

### Flake Structure

The `flake.nix` defines a single host configuration named `PD-C02CF35VJWDW` with these key components:

**Inputs:**
- `nixpkgs` - Package repository (unstable channel)
- `nix-darwin` - macOS system configuration framework
- `nix-homebrew` - Declarative Homebrew management

**Configuration Module:**
The main configuration is inline within the flake and includes:
- `environment.systemPackages` - Nix packages installed system-wide
- `homebrew` - Homebrew brews, casks, and Mac App Store apps with auto-cleanup/upgrade
- `system.primaryUser` - Set to "princedimond"
- `nix.settings.experimental-features` - Enables flakes and nix-command
- `nixpkgs.config` - Allows unfree packages

### Important Notes

- The hostname `PD-C02CF35VJWDW` is referenced in the `darwinConfigurations` output and must match when building
- System state version is 6 (backwards compatibility marker)
- Platform: x86_64-darwin (Intel Mac)
- Homebrew cleanup is set to "zap" mode (aggressive cleanup)
- Some configuration sections (dock settings, git config) are commented out

### File Organization

- `flake.nix` - Main configuration file
- `flake.lock` - Locked versions of inputs
- `flake.lock.good` - Backup of known-good lock file

## Configuration Changes

When adding or modifying:
- **Nix packages**: Add to `environment.systemPackages` array
- **Homebrew formulas**: Add to `homebrew.brews` array
- **Homebrew casks**: Add to `homebrew.casks` array
- **Mac App Store apps**: Add to `homebrew.masApps` with app ID

Always rebuild after changes to test before committing.
