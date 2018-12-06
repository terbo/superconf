#!/bin/bash

dialog --ascii-lines --visit-items --beep --shadow --ok-label "apt-get me" --cancel-label  "nah" --buildlist 'Select System Packages' 400 50 100  $(python aptcurses.py) 2> apt.packages
