... superconf v1 Wacky Octopus ...
Welcome to muh scripts.

Scripted: Some say... the whole world is scripted... either from above, or from below... I say, we are the ones who write the codes..


These are configs and scripts that I use across machines.
Some of these are old learning experiments, but many are
being actively updated, such as 'ss'.

An overview:

I mainly use bash on debian linux machines, in addition
to vim, screen, and a number of other utilities, so this
is my attempt to save my customizations.

The bashrc and bash aliases contain some of these changes,
but a majority are in the ss script, where I've begun to
move more complicated shell functions, like rc and ssh key
syncing, the beginnings of remote backups, and MQTT system
reporting. 

I've also included a list of debian packages that I usually
install on my systems. This list is in the process of being
converted into an ncurses menu so I can just copy all of this
to a new system and get it up to speed, or to several machines.

There are also raspbian, open wrt, and android chroot linux
machines which this system is designed to work on, and there
is some code for similar functionality with ESP8266's running
micropython.

In addition to these are scripts I wrote to fulfill console
needs I couldn't find, such as 'apls' and 'leases' - which
show current users on a hostapd access point, and which leases
they've acquired from a dnsmasq dns server.

Another set of files of interest is the screen config files.
These will launch several apps in various layouts in the CLI,
and some will automatically switch back and forth, making
network and service monitoring very convienent.

Programs such as htop, ntop, iftop, xtail/ccze, ttyload, etc
are used for this purpose, along with parallel ssh.

Example apls output:

#pre
AP "default" Ch.1 (99:aa:8c:ee:ff:ff - ISP Systems Ltd.) up 19 days  [In:32.4G/Out:29.2G]

[ #] IP           MAC                  RSSI     CONNECTED        INACTIVE     RX       TX       DNS        VENDOR

[ 1] 192.168.33.11    03:22:42:97:67:aa    -66      2 days ago       a second     4.2G     215.7M   xp7        Internet Systems INC.
[ 2] 192.168.33.16    21:s8:a0:29:29:aa    -44      21 minutes ago   27 seconds   76.2M    2.3M     ipod3      WebLink LLC
[ 3] 192.168.33.9     aa:2b:e0:b4:3f:aa    -58      2 days ago       8 seconds    175.6M   122.6M   wrt9       Machineworx
[ 4] 192.168.33.24    a3:a2:02:e9:57:aa    -31      4 hours ago      a moment     6.0M     4.2M     int2       IBM Netweb
#pre
