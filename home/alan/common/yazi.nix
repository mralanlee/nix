{pkgs, ...} : let
  yazi-plugins = pkgs.fetchFromGitHub {
  owner = "yazi-rs";
		repo = "plugins";
		rev = "...";
		hash = "sha256-...";
  };
in {
  programs.yazi = {
    enable = true;
    enableZshIntegrations = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    plugins = {
			chmod = "${yazi-plugins}/chmod.yazi";
			full-border = "${yazi-plugins}/full-border.yazi";
			toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
			starship = pkgs.fetchFromGitHub {
				owner = "Rolv-Apneseth";
				repo = "starship.yazi";
				rev = "...";
				sha256 = "sha256-...";
			};
		};

		initLua = ''
			require("full-border"):setup()
			require("starship"):setup()
		'';
  };
}
