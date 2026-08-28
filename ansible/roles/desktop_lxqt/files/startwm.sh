#!/bin/sh
# Isolated D-Bus session. startlxqt is the LXQt X11 entry point.
if [ -r /etc/profile ]; then
  . /etc/profile
fi
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-run-session -- /usr/bin/startlxqt
