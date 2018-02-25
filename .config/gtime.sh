#! /bin/bash

# sets date from google.com
date -s "$(curl -s --head http://google.com | grep ^Date: | sed 's/Date: //g')"
