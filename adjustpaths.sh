#!/bin/bash
# Author       : Jan Larres <jan@majutsushi.net>

set -x

if [[ -z "$1" ]]; then
    echo "usage: $0 PREFIX"
    exit 1
fi

PREFIX=$(readlink -f $1)

GAME=nethack
GAMEDIR=${PREFIX}/games/lib/${GAME}dir
VARDIR=${GAMEDIR}/var
CHARDATA=$HOME/.nethack

mkdir -p $CHARDATA

sed -r -i -e "s;HACKDIR[[:blank:]]+\".*\";HACKDIR \"${GAMEDIR}\";" include/config.h
sed -r -i -e "s;/dgldir/userdata/%N/%n/dumplog/%t.nh343.txt;${CHARDATA}/%n-%t.dump;" include/config.h

sed -r -i -e "s;VAR_PLAYGROUND[[:blank:]]+\".*\";VAR_PLAYGROUND \"${VARDIR}\";" include/unixconf.h

sed -r -i -e "s;/dgldir/userdata/%N/%n/nh343.mapdump;${CHARDATA}/%n.mapdump;" src/cmd.c

sed -r -i -e "s;/dgldir/extrainfo-nh343/%n.extrainfo;${CHARDATA}/%n.extrainfo;" src/end.c

sed -r -i -e "s;PREFIX[[:blank:]]+=[[:blank:]].*;PREFIX = ${PREFIX};" sys/unix/Makefile.top
sed -r -i -e "s;GAME[[:blank:]]+=[[:blank:]].*;GAME = ${GAME};" sys/unix/Makefile.top
sed -r -i -e "s;GAMEDIR[[:blank:]]+=[[:blank:]].*;GAMEDIR = ${GAMEDIR};" sys/unix/Makefile.top
sed -r -i -e "s;VARDIR[[:blank:]]+=[[:blank:]].*;VARDIR = ${VARDIR};" sys/unix/Makefile.top
sed -r -i -e "s;CHOWN = chown;CHOWN = true;" sys/unix/Makefile.top
sed -r -i -e "s;CHGRP = chgrp;CHGRP = true;" sys/unix/Makefile.top

sed -r -i -e "s;GAME[[:blank:]]+=[[:blank:]].*;GAME = ${GAME};" sys/unix/Makefile.src
