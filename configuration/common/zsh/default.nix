{ pkgs, config, ... }:

{
  users.users.pbb.shell = pkgs.zsh;
  home-manager.users.pbb.programs.zsh = {
    initExtra = ''
      function use {
        nix-shell -p $@ --run zsh
      }
    '';
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    localVariables = config.environment.variables;
    oh-my-zsh = {
      enable = true;
      theme = "fishy";
      plugins = [
        #"git"
        "sudo"
        "ripgrep"
      ];
    };
    plugins = [
      {
        name = "zsh-fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
      }
    ];
  };
}
