#! /bin/bash

# bash script for i3lock config

import -window root /tmp/screenshot.png
convert /tmp/screenshot.png -spread 3 /tmp/screenshotblur.png

i3lock -u -i /tmp/screenshotblur.png
