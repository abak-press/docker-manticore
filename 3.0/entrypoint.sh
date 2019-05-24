#!/bin/bash

set -ex

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "${1:0:1}" = '-' ]; then
    set -- sshd "$@"
fi

# check for the expected command
if [ "$1" = 'sshd' ]; then
    mkdir -p ${MANTICOREDATA}/{conf,data,binlog,log,pids}
    chmod -R 700 ${MANTICOREDATA}
    chown -R sphinx ${MANTICOREDATA}

    if [ -f "${MANTICOREDATA}/conf/sphinx.conf"  ]; then
      sudo -u sphinx searchd --config "${MANTICOREDATA}/conf/sphinx.conf" || true
    fi

    exec /usr/sbin/sshd -D -f /etc/ssh/sshd_config -E /var/log/ssh.log
fi

# else default to run whatever the user wanted like "bash"
exec "$@"
