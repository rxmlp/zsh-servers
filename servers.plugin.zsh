
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set a fancy prompt (non-color, unless we know we "want" color)
export COLORTERM=truecolor
export TERM=xterm-256color
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Any server lsd
alias ls='lsd' # Use lsd insead of ls
alias la='lsd -Alh' # show hidden files
alias lsa='lsd -aFh' # add colors and file type extensions
alias lx='lsd -lXBh' # sort by extension
alias lk='lsd -lSrh' # sort by size
alias lka='lsd -AlSrh' # sort by size | show hidden files
alias lr='lsd -lRh' # recursive ls
alias lt='lsd -ltrh' # sort by date
alias lf="lsd -l | egrep -v '^d'" # files only
alias ldir="lsd -l | egrep '^d'" # directories only
alias lz="lsd *.zip *.tgz *.zst *.gz *.tar *.spk *.jar *.vlt *.txz *.xz" # Search for these files


# Any Pi
alias shutdown="sudo shutdown now"
alias reboot="sudo shutdown now -r"
alias syson="systemctl start"
alias sysoff="systemctl stop"
alias sys="systemctl"
alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"


# Black
alias mullon="mullvad lockdown-mode set on & mullvad connect"
alias mulloff="mullvad lockdown-mode set off & mullvad disconnect"


# DSM
alias 2d='cd /volume1/docker'


# Docker stuff
alias dockerup='docker compose pull && docker compose up -d'
alias dockerprune='docker system prune --all --volumes'

dup() {
  local compose_dir="${1:-.}"
  local base_dir="$HOME/docker"


  # Adjust base directory for DSM
  if [[ "$(hostname)" =~ ^DSM ]]; then
    base_dir="/volume1/docker"
  fi

  docker compose -f "$base_dir/$compose_dir/docker-compose.yaml" pull && \
  docker compose -f "$base_dir/$compose_dir/docker-compose.yaml" up -d
}

dupall() {
  local base_dir="$HOME/docker"


  # Adjust base directory for DSM
  if [[ "$(hostname)" =~ ^DSM ]]; then
    base_dir="/volume1/docker"
  fi

  # Loop over directories exactly one level below $HOME/docker
  for dir in "$base_dir"/*/; do
    # Check if docker-compose.yml or docker-compose.yaml exists in this dir
    if [[ -f "$dir/docker-compose.yml" ]]; then
      echo "Running docker compose in $dir"
      docker compose -f "$dir/docker-compose.yml" pull && docker compose -f "$dir/docker-compose.yml" up -d
    elif [[ -f "$dir/docker-compose.yaml" ]]; then
      echo "Running docker compose in $dir"
      docker compose -f "$dir/docker-compose.yaml" pull && docker compose -f "$dir/docker-compose.yaml" up -d
    fi
  done
}
