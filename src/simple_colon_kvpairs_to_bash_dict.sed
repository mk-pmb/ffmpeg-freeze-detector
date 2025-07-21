#!/bin/sed -urf
# -*- coding: UTF-8, tab-width: 2 -*-
s~\s+~ ~g
s~ \(([0-9.]+|inf)\) ?$~ dB:\1~
s~[^A-Za-z0-9_ :=.-]~?~g
s~^~\n~
: column
  s~\n([A-Za-z]+):([A-Za-z0-9.]+)( |$)~[\1]=\2 \n~
t column
s~ *\n$~~
/\n/s~^~# ?? ~
s~\n~¶~g
