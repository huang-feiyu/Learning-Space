#!/usr/bin/env bash

echo "\n"
echo "====================Problem-6=================="
echo "Enter the file path :> "
read file_path
if [ -f "$file_path" ]
then
    echo "It is a regular file"
    ls -l $file_path
elif [ -d "$file_path" ]
then
    echo "It is a directory"
    ls -l $file_path
else
    echo "It is not a file or directory"
fi


echo "\n"
echo "====================Problem-7=================="
File_path=$1
if [ -f "$File_path" ]
then
    echo "It is a regular file"
    ls -l $File_path
elif [ -d "$File_path" ]
then
    echo "It is a directory"
    ls -l $File_path
else
    echo "It is not a file or directory"
fi


echo "\n"
echo "====================Problem-8=================="
# TODO: ZSH无法使用多个参数？
FILES=$@
for file in $FILES
do
    if [ -f "$file" ]
    then
        echo "It is a regular file"
        ls -l $File_path
    elif [ -d "$file" ]
    then
        echo "It is a directory"
        ls -l $File_path
    else
        echo "It is not a file or directory"
    fi
done

echo "\n"
echo "====================Problem-9=================="
echo "This script will exit with 0 exit status."
# exit 0

echo "\n"
echo "====================Problem-10=================="
# File_path=$1
if [ -f "$File_path" ]
then
    echo "It is a regular file"
    exit 0
elif [ -d "$File_path" ]
then
    echo "It is a directory"
    exit 1
else
    echo "It is not a file or directory"
    exit 2
fi
