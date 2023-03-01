#!/usr/bin/env zsh

echo "\n"
echo "====================Problem-11=================="
cat /etc/shadow

if [ "$?" -eq "0" ]; then
  echo "command succeeded"
  exit 0
else
  echo "Command failed"
  # exit 1
fi

echo "\n"
echo "====================Problem-12=================="
file_count() {
  local temp_file_count=$(ls -l | wc -l)
  echo "Numbers of files: $temp_file_count"
}
file_count

echo "\n"
echo "====================Problem-13=================="
File_count() {
  local file_count=$(ls $1 | wc -l)
  echo "Directory: $1"
  echo "Numbers of files: $file_count"
}
File_count /etc
File_count /var
File_count /usr/bin


echo "\n"
echo "====================Problem-14=================="
DAY=$(date +%F)
cd /mnt/p/Project/Exercise/Shell/temp

for FILE in *.jpg
  do
  mv $FILE $DAY-$FILE
done

ls -l


echo "\n"
echo "====================Problem-15=================="
echo "What Extension file do you want to change:>"
read Extension
DAY=$(date +%F)
echo "What Prefix do you want:>"
read Prefix

for FILE in *.$Extension
  do
    if [ $Prefix -eq "" ]
    then
      mv $FILE $DAY-$FILE
    else
      mv $FILE $Prefix-$FILE
    fi
done

