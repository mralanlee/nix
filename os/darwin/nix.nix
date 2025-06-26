{
  nix = {
    enable = false;
    # Garbage collection
    gc = {
      # automatic = true;
      # interval = {
      #   Weekday = 7;
      #   Hour = 3;
      #   Minute = 15;
      # }; # Run every Sunday at 3:15 AM
      # options = "--delete-older-than 30d";
    };

    # Store optimization
    optimise = {
      # automatic = true;
      # interval = [
      #   {
      #     Hour = 3;
      #     Minute = 0;
      #   }
      # ]; # Run daily at 3:00 AM
    };
  };
}
