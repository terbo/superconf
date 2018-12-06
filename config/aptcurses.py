#!/usr/bin/python
import re

cats = []
shown = []

for l in open('apt-packages').readlines():
  l = re.sub(r'[\r\n]$','',l)
  
  if (not len(l)) or (l.startswith('## ') or l.startswith('# ')):
    continue

  if l.startswith('### ') or l.startswith('#'):
    continue

  if(len(cats) and (cats[-1] not in shown)):
    print('\n%s %s off\n' % ( cats[-1], cats[-1]))
    shown.append(cats[-1])

  print('%s %s off ' % ( l, l ))
