#!/bin/bash
### every exit != 0 fails the script
set -e
#set -u     # do not use

## print out help
help() {
echo "
USAGE:
docker run <run-options> accetto/<image>:<tag> <option> <optional-command>

OPTIONS:
-w, --wait      (default) Keeps the UI and the vnc server up until SIGINT or SIGTERM are received.
                An optional command can be executed after the vnc starts up.
                example: docker run -d -P accetto/xubuntu-vnc
                example: docker run -it -P --rm accetto/xubuntu-vnc bash

-s, --skip      Skips the vnc startup and just executes the provided command.
                example: docker run -it -P --rm accetto/xubuntu-vnc --skip echo $BASH_VERSION

-d, --debug     Executes the vnc startup, prints some additional info and tails the VNC logs.
                Any parameters after '--debug' are ignored. CTRL-C stops the container.
                example: docker run -it -P --rm accetto/xubuntu-vnc --debug

-t, --tail-log  similar to '--debug' but no additional diagnostic info

-h, --help      Prints out this help.
                example: docker run --rm accetto/xubuntu-vnc

Fore more information see: https://github.com/accetto/xubuntu-vnc
"
}

### correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM

if [[ $1 =~ -h|--help ]]; then
    help
    exit 0
fi

if [[ $1 =~ -d|--debug ]]; then
    echo -e "\n\n------------------ DEBUG VNC STARTUP -----------------"
    export DEBUG=true
fi

### create current container user
"${STARTUPDIR}"/generate_container_user.sh

### add `--skip` to startup args, to skip the VNC startup procedure
if [[ $1 =~ -s|--skip ]]; then
    echo -e "\n\n------------------ SKIP VNC STARTUP -----------------"
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '${@:2}'"
    exec "${@:2}"
fi

### resolve_vnc_connection
VNC_IP=$(hostname -i)

### report the user in any case
echo "Script: $0"
id

### only in debug mode
if [[ $DEBUG ]] ; then
    echo "DEBUG: ls -la /"
    ls -la /
    echo "DEBUG: ls -la /home"
    ls -la /home
    echo "DEBUG: ls -la /home/headless"
    ls -la /home/headless
    echo "DEBUG: ls -la ."
    ls -la .
fi

### change vnc password
echo -e "\n------------------ change VNC password  ------------------"
### first entry is control, second is view (if only one is valid for both)
mkdir -p "$HOME"/.vnc
PASSWD_PATH="$HOME/.vnc/passwd"

if [[ "$VNC_VIEW_ONLY" == "true" ]]; then
    echo "start VNC server in VIEW ONLY mode!"
    ### create random pw to prevent access
    echo $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20) | vncpasswd -f > "$PASSWD_PATH"
fi

echo "$VNC_PW" | vncpasswd -f >> "$PASSWD_PATH"
chmod 600 "$PASSWD_PATH"

echo -e "\n------------------ start VNC server ------------------------"
echo "remove old vnc locks to be a reattachable container"
vncserver -kill $DISPLAY &> "$STARTUPDIR"/vnc_startup.log \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> "$STARTUPDIR"/vnc_startup.log \
    || echo "no locks present"

echo -e "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."
if [[ $DEBUG == true ]]; then 
    echo "vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION"
fi

vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION -BlacklistTimeout $VNC_BLACKLIST_TIMEOUT -BlacklistThreshold $VNC_BLACKLIST_THRESHOLD &> "$STARTUPDIR"/vnc_startup.log
echo -e "start window manager\n..."

### log connect options
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"

if [[ $DEBUG == true ]] || [[ $1 =~ -t|--tail-log ]]; then
    echo -e "\n------------------ $HOME/.vnc/*$DISPLAY.log ------------------"
    ### if option `-t` or `--tail-log` block the execution and tail the VNC log
    tail -f "$STARTUPDIR"/*.log "$HOME"/.vnc/*$DISPLAY.log
fi

if [ -z "$1" ] || [[ $1 =~ -w|--wait ]]; then
    sleep infinity
else
    ### unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi
