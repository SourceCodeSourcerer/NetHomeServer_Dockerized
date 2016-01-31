#!/bin/bash

echo Running...
set -e

PID_ROOT=/var/run/nethome
PID_FILE=$PID_ROOT/nethome.pid
CONFIGURATION_ROOT=/etc/opt/nethome
LOG_ROOT=/var/log/nethome
SCRIPTFILE=$0
# cd lib
cd $PID_ROOT
PID=`ps -ef | grep ${SCRIPTFILE} | head -n1 |  awk ' {print $2;} '`
echo ${PID} > ${PID_FILE}
chmod a+w ${PID_FILE}
# java -Djava.library.path=. -jar home.jar -l$LOG_ROOT "$@" $CONFIGURATION_ROOT/config.xml


# if `docker run` first argument start with `--` the user is passing nethome launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
    CMD=(java)
    if [ ! -z "$JAVA_OPTS" ]; then
        CMD+=("$JAVA_OPTS")
    fi
    CMD+=(-Djava.library.path=.)
    CMD+=(-jar)
    CMD+=(/opt/nethome/lib/home.jar)
    CMD+=(-l$LOG_ROOT)
    exec "${CMD[@]}" "$@" "$CONFIGURATION_ROOT/config.xml"
fi

# As argument is not nethome, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"