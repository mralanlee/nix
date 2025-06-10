{
  nix = {
    # Garbage collection
    gc = {
      automatic = true;
      dates = "Sun 03:15";  # Run every Sunday at 3:15 AM
      options = "--delete-older-than 30d";
      persistent = true;
    };
    
    # Store optimization
    optimise = {
      automatic = true;
      dates = ["03:00"];  # Run daily at 3:00 AM
    };
  };
}
