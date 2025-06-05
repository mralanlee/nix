# Nix Configuration

This repository contains my personal Nix configuration for both NixOS and macOS (Darwin) systems. It uses Nix flakes to manage system configurations, home-manager for user-specific settings, and provides a modular structure for easy maintenance and extensibility.

## Repository Structure

```
.
├── flake.nix           # Main flake defining system configurations
├── flake.lock          # Lock file for reproducible builds
├── hosts/              # Host-specific configurations
│   ├── drumwave/       # macOS (aarch64-darwin) configuration
│   ├── shimmer/        # NixOS (x86_64-linux) configuration
│   └── yoshi/          # NixOS (x86_64-linux) configuration
├── os/                 # OS-level configurations
│   ├── common/         # Shared configurations across all systems
│   ├── darwin/         # macOS-specific configurations
│   └── nixos/          # NixOS-specific configurations
└── home/               # User-specific configurations
    └── alan/           # User 'alan' configurations
        ├── common/     # Shared user configs across systems
        ├── darwin/     # macOS-specific user configs
        └── nixos/      # NixOS-specific user configs
```

## How It Works

### 1. **Flake Structure**

The `flake.nix` file is the entry point that:

- Defines inputs (nixpkgs, home-manager, darwin, hardware modules, etc.)
- Configures NixOS systems (`shimmer`, `yoshi`)
- Configures macOS systems (`drumwave`)
- Integrates home-manager for user-specific configurations

### 2. **Layered Configuration**

The configuration follows a hierarchical structure:

```
Host Configuration (e.g., hosts/shimmer/)
└── OS Configuration (os/nixos/)
    └── Common OS Configuration (os/common/)
        └── Home Manager Configuration (home/alan/nixos/)
            └── Common User Configuration (home/alan/common/)
```

This allows for:

- **Maximum code reuse**: Common settings are defined once
- **Platform-specific overrides**: Each layer can override or extend configurations
- **Host-specific customization**: Individual machines can have unique settings

### 3. **Module System**

Each directory contains modular Nix files:

- `default.nix`: Main entry point that imports other modules
- `packages.nix`: Package installations
- `home.nix`: Home-manager specific settings
- `git.nix`, `neovim.nix`, etc.: Application-specific configurations

### 4. **Package Distribution**

Packages are distributed through multiple layers:

1. **System-level packages** (in `os/*/packages.nix`):
   - Core system utilities
   - System services
   - Drivers and firmware

2. **User-level packages** (in `home/alan/*/packages.nix`):
   - Development tools (terraform, kubectl, etc.)
   - Communication apps (slack, discord, etc.)
   - User applications

## Supported Systems

### NixOS Hosts

- **shimmer**: x86_64-linux system with Intel graphics, DisplayLink support
- **yoshi**: x86_64-linux system

### macOS Hosts

- **drumwave**: aarch64-darwin (Apple Silicon) with Homebrew integration

## Key Features

- **Flakes**: Reproducible builds with locked dependencies
- **Home-manager**: User-specific configurations portable across systems
- **Multi-platform**: Supports both NixOS and macOS
- **Modular**: Easy to extend and maintain
- **Homebrew integration**: On macOS via nix-homebrew
- **Hardware support**: nixos-hardware for better device compatibility
- **Secrets management**: sops-nix integration for secure secrets

## Building and Switching

### NixOS Systems

```bash
# Build and switch to a new configuration
sudo nixos-rebuild switch --flake .#shimmer

# Build without switching
sudo nixos-rebuild build --flake .#shimmer

# Test configuration (activate but don't add to boot)
sudo nixos-rebuild test --flake .#shimmer
```

### macOS Systems

```bash
# Build and switch to a new configuration
darwin-rebuild switch --flake .#drumwave

# Build without switching
darwin-rebuild build --flake .#drumwave
```

### Formatting

The repository uses `alejandra` for Nix code formatting:

```bash
# Format all Nix files
nix fmt
```

## Customization

To add a new host:

1. Create a new directory under `hosts/`
2. Add a `default.nix` that imports the appropriate OS configuration
3. Add the host to `flake.nix` under `nixosConfigurations` or `darwinConfigurations`

To add new packages:

1. For system-wide packages: Edit `os/*/packages.nix`
2. For user packages: Edit `home/alan/common/packages.nix`
3. For host-specific packages: Add them in the host's configuration

## Notable Configurations

- **Window Manager**: Hyprland (NixOS)
- **Shell**: Zsh with custom configuration
- **Editor**: Neovim with LazyVim
- **Terminal Multiplexer**: Tmux
- **Development Tools**: Terraform, Kubernetes tools, Docker/Podman
- **File Manager**: Yazi

