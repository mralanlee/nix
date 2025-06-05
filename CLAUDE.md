# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Building and Switching Configurations

**NixOS Systems (shimmer, yoshi):**
```bash
# Switch to new configuration
sudo nixos-rebuild switch --flake .#shimmer
sudo nixos-rebuild switch --flake .#yoshi

# Build without switching
sudo nixos-rebuild build --flake .#shimmer

# Test configuration (activate but don't add to boot)
sudo nixos-rebuild test --flake .#shimmer
```

**macOS Systems (drumwave):**
```bash
# Switch to new configuration
darwin-rebuild switch --flake .#drumwave

# Build without switching
darwin-rebuild build --flake .#drumwave

# Quick rebuild alias (defined in shell config)
rebuild  # equivalent to: darwin-rebuild switch --flake ~/projects/nix
```

**Code Formatting:**
```bash
# Format all Nix files using alejandra
nix fmt
```

## High-Level Architecture

This is a multi-platform Nix configuration repository supporting both NixOS and macOS systems through a layered, modular architecture.

### Configuration Hierarchy

The configuration follows a strict hierarchical structure where each layer can override or extend the layer above:

```
hosts/<hostname>/           # Machine-specific config (top priority)
└── os/<platform>/          # OS-specific config (nixos/darwin)
    └── os/common/          # Shared OS config
        └── home/alan/<platform>/  # User platform-specific config
            └── home/alan/common/  # Shared user config (base layer)
```

### Key Architectural Patterns

1. **Flake-based Configuration**: The `flake.nix` orchestrates all system configurations, defining inputs (nixpkgs, home-manager, darwin, etc.) and outputs for each host.

2. **Module Composition**: Each directory contains a `default.nix` that imports other specialized modules (packages.nix, git.nix, neovim.nix, etc.). This allows granular control over features.

3. **Platform Abstraction**: Common configurations are shared across platforms in `*/common/` directories, with platform-specific overrides in `*/nixos/` or `*/darwin/` directories.

4. **Package Distribution Strategy**:
   - System packages: Defined in `os/*/packages.nix` for core utilities and services
   - User packages: Defined in `home/alan/*/packages.nix` for development tools and applications
   - Host-specific packages: Can be added in individual host configurations

5. **Home-Manager Integration**: User configurations are managed through home-manager, embedded within the system configuration but maintaining clear separation of concerns.

### Adding New Hosts

To add a new host:
1. Create `hosts/<hostname>/default.nix` importing the appropriate OS config
2. Add hardware-specific configuration if needed
3. Register in `flake.nix` under `nixosConfigurations` or `darwinConfigurations`
4. The host will automatically inherit the full configuration stack

### Key Technologies Configured

- **Window Manager**: Hyprland (NixOS only)
- **Shell**: Zsh with Oh-My-Zsh, custom aliases and functions
- **Development**: Terraform, Kubernetes tooling, Docker/Podman
- **Editor**: Neovim with LazyVim configuration
- **Terminal**: Tmux with auto-start, Alacritty
- **Package Management**: Nix, Homebrew (macOS), mise
- **Security**: 1Password integration, sops-nix for secrets