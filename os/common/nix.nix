{
  nix = {
    settings = {
      # Substituters
      trusted-substituters = ["https://nix-community.cachix.org/"];
      trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      
      # Build performance
      max-jobs = "auto";
      cores = 0; # Use all available cores
      
      # Better caching
      keep-outputs = true;
      keep-derivations = true;
      
      # Faster downloads
      http-connections = 50;
      
      # Memory management during builds
      min-free = 1073741824; # 1GB - stop builds if less than this is free
      max-free = 10737418240; # 10GB - run GC if more than this is free
    };

    channel.enable = true;

    # Store optimization
    optimise = {
      automatic = true;
      interval = [{ Hour = 3; Minute = 0; }];
    };
    
    # Garbage collection
    gc = {
      automatic = true;
      interval = { Weekday = 7; };
      options = "--delete-older-than 30d";
    };
  };
}
