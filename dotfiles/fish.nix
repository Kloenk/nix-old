{ pkgs, ... }:

''
  alias :q="exit"
  
  if status --is-interactive
  	abbr --add --global admin-YouGen 'ssh admin-JouGen' 
  	abbr --add --global cb 'cargo build'
  	abbr --add --global cr 'cargo run'
  	abbr --add --global ct 'cargo test'
  	abbr --add --global exit ' exit'
  	abbr --add --global gc 'git commit'
  	abbr --add --global gis 'git status'
  	abbr --add --global gp 'git push'
  	abbr --add --global hubble 'mosh hubble'
  	abbr --add --global ipa 'ip a'
  	abbr --add --global ipr 'ip r'
  	abbr --add --global lycus 'ssh lycus'
  	abbr --add --global pluto 'ssh pluto'
  	abbr --add --global s sudo
  	abbr --add --global ssy 'sudo systemctl'
  	abbr --add --global sy 'systemctl'
  	abbr --add --global startx 'exec startx'
  	abbr --add --global v vim
  	abbr --add --global sp 'sudo pacman'
  end
  
  
  #ssh AGENT stuff
  export GPG_TTY=(tty)
  source $HOME/.config/fish/gpg2.fish
  
  set -u SSH_AGENT_PID
  export SSH_AUTH_SOCK=(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
  
  ${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye 2>&1 /dev/null
  
  
  # vim: syntax=sh
  
''

