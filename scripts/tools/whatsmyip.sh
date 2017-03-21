#!/bin/bash
ifconfig -a | grep 'inet addr' | grep -v '127.0.0.1' | tr -d '[:space:]' | cut -d':' -f2 | egrep -oe [0-9.]+
exit 0
