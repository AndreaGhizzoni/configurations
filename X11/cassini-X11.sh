#! /bin/sh

u=andrea
m=cassini.local

# lancia Xephyr su display :1
Xephyr :1 -ac -nolisten tcp -screen 1440x900 &
pid_xephyr=$!

# lancia lxde via ssh su display :1
exit_status=0
DISPLAY=:1 ssh "$u@$m" -X -C -- startlxde ||
   exit_status=$?

# termina Xephyr quando lxde termina
kill $pid_xephyr 2> /dev/null
{ sleep 5; kill -9 $pid_xephyr 2> /dev/null ; }&
wait $pid_xephyr 2> /dev/null

# esce con l'exit status di lxde
exit $exit_status
