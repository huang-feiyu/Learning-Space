#!/usr/bin/env zsh 

echo "\n"
echo "====================Problem-16=================="
INPUT=$1
case $INPUT in
  start) 
    if [ -f "/home/huang/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/huang/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        xport PATH="/home/huang/anaconda3/bin:$PATH"
    fi
    ;;
  stop)
    PID_ID=$(ps -ef | grep conda | cut -d" " -f3 | sed '1!d')
    kill $PID_ID
    if [ $? -eq "0" ]; then
      echo "conda stop"
    fi
    ;;
  *)
    echo "Error Input"
    ;;
esac


echo "\n"
echo "====================Problem-17=================="
# WSL无法写入？
MESSAGE="Random number is: $RANDOM"
echo "$MESSAGE"
logger -p user.info "$MESSAGE"

echo "\n"
echo "====================Problem-18=================="
function logging() {
  Message=$@
  SET_MESSAGE="Random Number is:$MESSAGE"
  echo "$SET_MESSAGE"
  logger -i -p user.info "$SET_MESSAGE"
}
logging $RANDOM
logging $RANDOM
logging $RANDOM


echo "\n"
echo "====================Problem-19=================="
#!/bin/bash -ex
# WSL不支持?
ls /mnt
ls /mnt/x
ls /mnt/f


echo "\n"
echo "====================Problem-20=================="
#!/bin/bash -x
# WSL不支持?
ls /mnt
ls /mnt/x
ls /mnt/f


