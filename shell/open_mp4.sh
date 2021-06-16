#!/bin/bash
readlink -f "$1" | sed -e 's|/mnt/c|c:|' -e 's|/|\\\\|g' | xargs /mnt/c/Program\ Files\ \(x86\)/Windows\ Media\ Player/wmplayer.exe &
