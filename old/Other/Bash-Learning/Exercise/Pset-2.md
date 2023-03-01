[Shell Scripting Exercises](https://medium.com/@sankad_19852/shell-scripting-exercises-5eb7220c2252)

### Problem 6-10

6. write a shell script that prompts the user for a name of a file or directory and reports if it is a regular file, a directory, or another type of file. Also perform an ls command against the file or directory with the long listing option.
```bash
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
```

7. Modify the previous script to that it accepts the file or directory name as an argument instead of prompting the user to enter it.
```bash
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
```

8. Modify the previous script to accept an unlimited number of files and directories as arguments.
```bash
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
```

9. Write a shell script that displays, “This script will exit with 0 exit status.” Be sure that the script does indeed exit with a 0 exit status.
```bash
echo "This script will exit with 0 exit status."
exit 0
```

10. Write a shell script that accepts a file or directory name as an argument. Have the script report if it is reguler file, a directory, or another type of file. If it is a directory, exit with a 1 exit status. If it is some other type of file, exit with a 2 exit status.
```bash
File_path=$1
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
```

