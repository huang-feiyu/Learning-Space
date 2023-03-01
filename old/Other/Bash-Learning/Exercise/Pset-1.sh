#!/usr/bin/env zsh

echo "\n"
echo "====================Problem-1=================="
echo "Shell Scripting is Fun!"

echo "\n"
echo "====================Problem-2=================="
msg="Shell Scripting is Fun!"
echo $msg

echo "\n"
echo "====================Problem-3=================="
HOSTNAME=$(hostname)
echo "This script is running on $HOSTNAME."

echo "\n"
echo "====================Problem-4=================="
FILE_PATH="/mnt/f/Videos/temp/Temp.md"
if [ -e "$FILE_PATH" ]
  then
    echo "$FILE_PATH passwords are enabled."
fi

if [ -w "$FILE_PATH" ]
  then
    echo "You have permissions to edit $FILE_PATH"
  else
    echo "You do NOT have permissions to edit $FILE_PATH"
fi


echo "\n"
echo "====================Problem-5=================="
ANIMALS=( man bear pig dog cat sheep )

for i in "${ANIMALS[@]}"
do
  echo $i
done
