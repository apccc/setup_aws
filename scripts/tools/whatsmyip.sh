#!/bin/bash
~/ec2-metadata -v | cut -d':' -f2 | egrep -oe '[0-9.]+'
exit 0
