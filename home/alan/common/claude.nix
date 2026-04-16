{...}: {
  home.file.".claude/skills" = {
    source = ../dotfiles/claude/skills;
    recursive = true;
  };
}
