#!/bin/bash 
# T-10 . shellsync v.000000 A

#
# shell sync
#
# connect the devices
# share the information
# keep track of it
#
# aimed compatibility: debian, android, openwrt

SS_INIT=1
SS_RUNLEVEL=0

ssdate() {
  echo -n $( date "+%F %T" )
}

sstime() {
  echo -n $( date "+%T" )
}

set_debug() {
  if [ -n "$SS_CFG_DEBUG" ] && [ "$SS_CFG_DEBUG" -eq 1 ]; then
    #set -o errexit
    set -x
    set -o pipefail
    set -o nounset
    set -o errtrace
  fi
}

set_debug

ss_log() {
  local LOGPRIO=shift
  # for ssh right now, but need file log.
  [ -t 0 ] && echo "$( ssdate ) ${LINENO} -- $@"
}

binloc() {
  return
#-x which |
#-x where |
#-x /bin /usr /system/xbin /system/bin
}

# set approrpriate path for each system
check_path(){
  return
}

[ -f '/tmp/.ssrc' ] && . /tmp/.ssrc
[ -f '/data/local/tmp/.ssrc' ] && . /data/local/tmp/.ssrc
[ -f "$HOME/.ssrc" ] && . "${HOME}/.ssrc"
[ -f "./.ssrc" ] && . "./.ssrc"
[ -f "ss.rc" ] && . "ss.rc"
[ -f "/root/code/superconf/ss.rc" ] && . "/root/code/superconf/ss.rc"


#[ -z "$SS_RC" ] && echo '[x] config'

SS_SCRIPTPATH=${BASH_SOURCE}
SS_SCRIPTNAME=${BASH_SOURCE##*/}

ss_log 0 "[ss] init ($SS_VERSION) $SS_ABOUT"

## 1. First, we check versions.
##    Of everything. Bash first.

SS_RUNLEVEL=1

check_bash_version() {
  if [ "${BASH_VERSINFO[0]}" -ne 4 ] || \
    [ "${BASH_VERSINFO[1]}" -lt 3 ]; then 
    
    [ "$SS_CFG_VERBOSE" -eq 1 ] && \
      ss_log 2 " *** enjoy the shell shock *** "
    [ "$SS_CFG_VERBOSE" -ne 1 ] && \
      ss_log 2 "[bash] vulnerable"
    return 66
  fi
}


# trying to get off of that
check_tcsh_version() {
  TCSH_VERSION=$( tcsh --version )
}

check_sed_version() {
  # matches busybox too, but -r is fairly compat
  local SED_VER=$( sed --version | head -1 )
  
  if [ -z "$SED_VER" ]; then
    ss_log 2 "[sed:-]"
  fi
  echo $SED_VER
}

check_awk_version() {
  local AWK_VER=$( awk -V | head -1)
  echo $AWK_VER
}

ss_cmd() {
  return
}

ss_sync() {
  local RES=shift
  local FROM=shift
  local TO=shift
  return
}

ss_update() {
  return
}

#for each file to watch make a $1.ctime backup if its less than 10k
ss_backup() {
  return
}

check_grep_version() {
  local GREP_VER=$( grep --version | head -1 )
  if [ -z "$GREP_VER" ]; then
    SS_GREP=0
    return 33
  fi
}

check_busybox_version() {
  local BB_VER=$( busybox | head -1 )
  echo $BB_VER
}


# system info

check_os_type() {
  local OS=$( uname -s )
  echo $OS
}

check_os_version() {
  OSVERSION=$( uname -r )
  echo $OSVERSION
}

check_os_arch() {
  return 0
}

check_cpu_load() {
  export CPULOAD=$( w|head -1|sed -e 's/.*average:\s//;' |cut -d, -f1-1 )
  echo $CPULOAD
}

check_memory() {
  [[ "${OS}" =~ 'inux' ]] && MEMINFO=$( free )
  [[ "${OS}" =~ 'Darwin' ]] && MEMINFO=$( vmstat )
  echo $MEMINFO
}

check_disks() {
  DISKSPACE=$( df -h )
  DISKMOUNTS=$( mount -lv | egrep -v -e '(tmpfs|/sys|/proc|devpts)' )
  #DISKPARTS=$( fdisk -l )
}

check_system() {
  check_os_version
  check_memory
  check_disks &
  PROCS=$(nproc)
}

get_ip() {
 if [ -x "/usr/bin/upnpc" ]; then
   NET_IP=$(upnpc -l|grep ExternalIPAddress|sed 's/.*=\s//') &
   #my $ip = `GET http://checkip.dyndns.org`;
   LOCAL_IP=$( hostname -I | sed 's/\s.*//g' )
   echo "$LOCAL $NET_IP"
  fi
}

get_route() {
  echo $( ip link )
}

check_bandwidth() {
  return
}

pingcheck() {
  local IP=$1; shift
  local WAIT=1
  local NUM=1
  local QUIET='-q'

  echo $( ping -n -c $NUM -W $WAIT -w $WAIT $QUIET $IP )
}

pingcheck_hosts() {
  PINGHOSTS[0] = '4.2.2.2'
  PINGHOSTS[1] = '8.8.8.8'
  PINGHOSTS[2] = 'google.com'
  #${!PINGHOSTS[#]}
}

check_net_latency() {
  export NETPING="$(pingcheck 8.8.4.4 | grep 'rtt.*avg'| \sed -e 's/.*\ =\ //' -e 's/\ ms//' | cut -d\/ -f2-2 )ms"
  #echo $NETPING
}

check_network() {
  NET_ROUTE=$( get_route )
  # daemon stuff
  #MY_IP=$( get_ip )
  #NET_BW=$( check_bandwidth )
  
  #LASTPING=$( pingcheck 8.8.4.4 ) &
  #LASTDNS=$( host 8.8.8.8 )
  #echo $( ping $MY_IP )
}


network_scan() {
  echo $BIN_NMAP $( localiprange )
}


#
# user apps
#


check_vim_version() {
  VIM_VERSION=$( vim --version|head -1 )
}

check_screen_version() {
  SCREEN_VERSION=$( screen -v )
}

check_less_version() {
  LESS_VERSION=$( less -V )
}

check_ssh_version() {
  SSH_VERSION=$( ssh -V > /dev/null 2>&1 < /dev/null )
}


#
# application groups
#

check_user_programs() {
  check_vim_version
  check_less_version
  check_screen_version
  check_ssh_version

  return
}

check_admin_programs() {
  check_skill_version
  check_lsof_version
  check_binutils_version
  check_coreutils_version
  return
}

check_server_programs() {
  check_mysql_version
  check_mongodb_version
  check_postgres_version
  check_apache_version
  check_sshd_version
  check_syslog_type

  return
}


check_devel_programs() {
  GCC_VERSION=$( gcc --version|head -1 )
  STRIP_VERSION=$( strip --version|head -1 )
  STRINGS_VERSION=$( strings --version|head -1 )
  DIFF_VERSION=$( diff --version|head -1 )
  PATCH_VERSION=$( patch --version|head -1 )
  MAKE_VERSION=$( make --version|head -1 )
  LS_VERSION=$( ls --version|head -1 )

  PYTHON_VERSION=$( python -V )
  PIP_VERSION=$( pip -V )

  PERL_VERSION=$( perl -v|strings|head -1 )
  CPAN_VERSION=$( cpan --version|head -1 )
}

BASH_VERSION=$(check_bash_version)
TCSH_VERSION=$(check_tcsh_version)
SED_VERSION=$(check_sed_version)
AWK_VERSION=$(check_awk_version)
GREP_VERSION=$(check_grep_version)
BUSYBOX_VERSION=$(check_busybox_version)
SYSTEMINFO=$(check_system)


#check_admin_programs
#check_devel_programs
#check_server_programs
check_user_programs


## 2.  Now for the utility functions.
##

SS_RUNLEVEL=2

sscmds() {
  # add doc helptext, grep -B or -A for help
  echo $(grep '^[a-z]' $( which ss ) | grep -v return\$ | sed s/\(.\*//g | sort ) | column -s '\t'
}

checkpid() {
  #-f $1 &&
  #-n -gt 0
  #pgrep $1
  #-f /var/run /tmp
  #findpid()
  return
}

stoppid() {
  return
}

ress() {
 . `which ss`
}

# (re) create the conditions for ss to exist
# btw, if you split by blocks of $#}$ then
# take the first line, thats the short help,
# second line is long help,
#
# first paragraph is help, 2nd is reference
ss_install() {
  # static install, usually in $HOME
  if [ -n "$SS_CFG_USESTATIC" ]; then
    SS_HOME=${SS_CFG_USESTATIC}
    if [ ! -d "$SS_HOME" ]; then
      #dialog --inputbox "ShellSync install directory? (~/.ss)" 9 45
      ss_log 1 "[install] making $SS_HOME"
      mkdir -p "${SS_HOME}"
      if [ ! -d "$SS_HOME" ]; then
        ss_log 2 "[install] unable to create $SS_HOME: (err), exiting"
        return 23
      fi
    fi 
    [ ! -f "${SS_HOME}/${SS_SCRIPTNAME}" ] && cp -Lina ${SS_SCRIPTPATH} ${SS_HOME}
    ln -s "${SS_HOME}/${SS_SCRIPTNAME}" "${SS_HOME}/init"
    [ ! -f "${SS_HOME}/${SS_RC}" ] && cp -ani ${SS_RC} ${SS_HOME}
  fi
 

  _installed=$( grep "^#_ss_installed" ${HOME}/.bashrc )

  #insert self into bashrc, checking that im not there
  if [ -z "$_installed" ]; then
    echo -e "\n\n#_ss_installed $( ssdate ) $SS_VERSION $USER $OS" >> ${HOME}/.bashrc
    echo -e "source ${SS_HOME}/init\n" >> ${HOME}/.bashrc
  fi

  ss_variables > ${SS_HOME}/variables
  ss_cmds > ${SS_HOME}/commands

  grep '^#' ${SS_SCRIPTPATH} > ${SS_HOME}/help

  #alias -p > ${SS_SCRIPTPATH/aliases
  
  echo ${SS_CPUS_HOSTS[@]} > ${SS_SCRIPTPATH}/hosts

  #now initited backup or daemons .. or do further system checks, or should have
}

# convert/list SS system vars to/from user vars
# SS_ vars are system, while GREP_VAR is user
# SS_ vars are monitored for changed differently
ss_variables() {
  #COLS=$COLUMNS
  #OFF=$(( $COLS / 4 ))
  for var in ${!SS_*}; do
    eval echo -e "${var}      \${$var}"
  done | column -s '\t'
  return
}

# so to break convention but leave that intact
# i'll comment here.
#

# return a report of all the information we have
# place into json and use pretty print to display
# maybe make some text graphs lol
ss_report() {
  return
}


track_apt() {
  return
}

track_pip() {
  return
}

list_hosts() {
#for ALL_DATA
  return
}

# for when more is less
rename_programs() {
  return
}


## 3. Now for the network awareness.
##

#check_network

# ssh

remote_exec() {
  return
}

remote_copy() {
  return
}

get_keys() {
  return
}

update_keys() {
  return
}

generate_key() {
  return
}

disable_root() {
  return
}

disable_password() {
  return
}

network_setup() {
  return
}

## 4. And there should be backups after this
##
SS_RUNLEVEL=5

watch_conf_files() {
  local files file missing
  for filesvar in ${!SS_CFG_FILES*}; do
    files=$( eval echo -nE \${$filesvar[*]} ) 
    for file in ${files//\\b/}; do
      if [ -f "$file" ]; then
        echo -n "$( stat -c %s ${file} ) ${file}"
      elif [ -d "$file" ]; then
        echo -n $(du -s "$file")
      else
        missing[$(basename ${file})]=$file
        continue
      fi
    done
  done

  echo ${missing[@]} files .. which though, hmm.
}

backup_home() {
  return
}

lastmodified() {
  return
}

largestfiles() {
  return
}

watch_vi_files() {
  declare -A Filenames Editcounts
  
  for file in $( egrep -h vi\  .history/* .bash_history|sort ); do
    echo $file
    bn=$(basename ${file})
    Filenames[{$bn}]=${file}
    Editcounts[${bn}]=$(( ${Editcounts[${bn}]} + 1 ))
  done
  
  for n in ${!Editcounts[@]}; do
    echo "${n}: ${Editcounts[${n}]} ( ${Filenames[${n}]} )"
  done
return

# watch edits of /etc files
# save incremental diffs
# send to backup host
# link to swap files and undodir
}

historywatch() {
  return
}

resolvconf() {
  return
}

## 5. Aliases, shortcuts, helpers
##
SS_RUNLEVEL=5

if [ -f "${SS_HOME}/aliases" ]; then
  #grep "^[a-z_]()\b" $SS_ALIASES
  ss_log 1 "[aliases]"
  . ${SS_HOME}/aliases
fi

progress_bar() {
  return
}

spinner() {
  return
}

# print a two line prompt
# with remote/display, screens, and background jobs
# can monitor other variables, ss will check them
# can also do some type of events with variables..
# ...
# ss_cron?
#
# remote:0 (#jb)                   (#s)  [time]
# user$host pwd$  

calc(){ echo $(( $@ )) ; }

print_pre_prompt() {
  # get the length of left hand prompt - 1
  #local PAD=$( echo $HOSTNAME $USER $PWD|wc -L )
  # constantly updated by bash now
  TIME=$( sstime ) 
  
  if [ "$(( $RANDOM % 2 ))" -eq 0 ]; then
    jobs -l
  fi
 
  #if [ "$LAST_REHASH" ]; then
  #  . `which ss`
  #fi

  JOBS=$( jobs | wc -l )

  # periodic clauses
  if [ "$(( ${TIME##*:} % 4 ))" -eq 0  ]; then
    SCREENS=$( screen -ls | /bin/fgrep '(' | wc -l )
  elif [ "$(( ${TIME##*:} % 5 ))" -eq 0 ]; then
    history -a
    test "$JOBS" -eq 0 && stitle
  elif [ "$(( ${TIME##*:} % 6 ))" -eq 0 ]; then
    if [ "$(( $RANDOM % 2))" -eq 0 ]; then
      check_cpu_load
    else
      check_net_latency
    fi
  fi  
    # write history every 20 seconds
  #elif [[ $(( ${TIME##*:} )) -lt 00 ]]; then
    # put cpu load in prompt every minute
    #echo Top of the minute
    #NOWPLAYING=$( check_mpd_song )
    #check_cpu_load 
  
  # could be a func promptdate
  # show if youre on console or remote, maybe a breadtrail?
  REMOTE=''
  [ -n "$REMOTEHOST" ] && REMOTE="${REMOTEHOST}"
  [ -n "$DISPLAY" ] && REMOTE="${DISPLAY}"
  local LPROMPT="${REMOTE/.*/} [${JOBS}]"
  export LLEN=$( echo -n "$LPROMPT $NETPING $CPULOAD (s:$SCREENS) [$TIME]"| wc -L )

  # subtract top left prompt from date/extra info length
  export ROFFSET=$(( $COLUMNS - $LLEN ))
  printf "${LPROMPT}%${ROFFSET}s$NETPING $CPULOAD (s:${SCREENS})  [${TIME}]\n"
}

export PROMPT_COMMAND=print_pre_prompt

## Welcome to the system.
##

## 6. MOTD
##

SS_RUNLEVEL=6

## 7. And now for the USER.
##

SS_RUNLEVEL=7


google_search () 
{ 
    title="${*##*/}"
    stitle "g:$title"
    w3m google.com/search?q="$*"
}

alias g=google_search

vi() {
  title="${1##*/}"
  stitle "v:$title"
  /usr/bin/vim $@
}

alias v=vi

stitle() {
  test -z "$STY" && return # not running under screen

  T='\033k'
  T2='\033\\'
  if [ -n "$1" ]; then
    T="$T${*}"
  else
    PPWD=$(dirname $PWD)
    T="${T}${HOSTNAME}:"
    if [ "$PWD" != '/' ]; then
      T="${T}${PPWD##*/}/${PWD##*/}"
    else
      T="${T}/"
    fi
  fi

  echo -e ${T}${T2}
}


## Bash Settings

unset HISTCONTROL
HISTFILESIZE=9999999999
export MPD_HOST=mp3

shopt -s autocd
shopt -s dirspell
shopt -s cdspell

shopt -s checkjobs

shopt -s checkwinsize
shopt -s histappend
shopt -s cmdhist

set enable-meta-key off

color_prompt=yes
force_color_prompt=yes

set -o noclobber

export HISTTIMEFORMAT='  %F %T  '

PAGER='less -RXE'
EDITOR='vim'
LANG=C

## shell and file ops
alias d='ls -h --color -laF'
alias ls='ls -F --color'
alias l='ls'
alias lsort='ls -Sharl'
alias df='df -h'

alias j='jobs -l'

# double dash evaluates to single in cmd
alias -- -='cd -'

alias ...='cd ../..'
alias ....='cd ../../..'
alias h='history'
alias m='$PAGER'
alias v='vi'
#alias vi='$EDITOR'

alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'

alias rmf='/bin/rm -fv'
alias cpf='/bin/cp -fv'
alias mvf='/bin/mv -fv'

alias -- +x='chmod +x'
alias -- -x='chmod -x'

## common

alias rehash='source ~/.bashrc'
alias re=rehash

#alias ircname='shuf ${HOME}/.ircnames|head -1'
#export IRCNAME=$(ircname)

alias sed='sed -r'
alias lane='perl -lane'

alias vol='mpc volume'

function loop ( ) {
  while true;
    do mpc seek -${1};
    sleep $1;
  done
}

vim_undodir() {
  dir="$HOME/.vim/undodir"
  for oname in ${dir}/*
  do
    name="$(echo $oname | sed -e 's@.*/@@' -e 's@%@/@g' )"
    size=$(stat -c '%s' $oname)
    #fsize=$(echo $size | perl -ne 'use Number::Bytes::Human qw(format_bytes); print format_bytes($_)')
    echo "$name - $size $(nformat -s $size)"
    echo "$name - $fsize"
  done

  #later:
  #ls -l `ls -1ct | sed -e 's@.*/@@' -e 's@%@/@g' | head -30`
}

GREP_COLOR='-aHn --color=always'
alias grep='egrep'
#alias cgrep='GREP_COLOR=${CGREP_COLOR} grep'

alias scrx='screen -rx'
alias scrls='screen -ls'
alias system-overview='(scrls |& grep sysmon) || screen -S sysmon -T screen -c /root/.screen/system-overview.screenrc'

function volfade() { local step stop vol dir; dir='+'; [ -z "$1" ] && stop=100; [ -n "$1" ] && stop="$1"; [ -z "$2" ] && step='.4'; [ -n "$2" ] && step="$2"; vol=$( mpc volume | sed -e s/volume:\ // -e s/%// ); [ $stop -lt $vol ] && dir='-'; while [ $vol -ne $stop ]; do mpc -q volume $vol; vol=$(( $vol $dir 1 )); echo -ne "$step $vol\r"; sleep $step; done; }

function volfade() {
  local step stop vol dir;

  dir='+'

  vol=$( mpc volume | sed -e s/volume:\ ?// -e s/%// );

  if [ -z "$1" ]; then
    if [ "$vol" -eq 100 ]; then
      stop=50
    else
      stop=100
    fi
  else
    stop="$1"
  fi
  if [ -z "$2" ]; then
    step='.4'
  else
    step="$2"
  fi

  [ $stop -lt $vol ] && dir='-';

  while [ $vol -ne $stop ]; do
    mpc -q volume $vol;
    vol=$(( $vol $dir 1 ));
    echo -ne "$vol\r";
    sleep $step;
  done;
}

alias acpi='acpi -V'

test -d ~/.history || mkdir ~/.history
test -d ~/.vim/undodir || mkdir -p ~/.vim/undodir

if [ -t 1 ]; then
  TTY=$(echo $(tty) | sed -e s@/dev/@@ -e s@pts/@@ )
  [[ -n "$TTY" ]] && export HISTFILE="${HOME}/.history/bash.history.${TTY}"

  bind "set completion-ignore-case off"
  bind "set completion-map-case off"
  bind "set show-all-if-ambiguous on"
fi
