[Shell Scripting Exercises](https://medium.com/@sankad_19852/shell-scripting-exercises-5eb7220c2252)

### Problem 1-5

1. Write a shell script that prints “Shell Scripting is Fun!” on the screen
```bash
echo "Shell Scripting is Fun!"
```

2. Modify the shell script from exercise 1 to include a variable. The variable will hold the contents of the message “Shell Scripting is Fun!”
```bash
msg="Shell Scripting is Fun!"
echo $msg
```

3. Store the output of the command “hostname” in a variable. Display “This script is running on _.” where “_” is the output of the “hostname” command.
```bash
HOSTNAME=$(hostname)
echo "This script is running on $HOSTNAME."
```

4. Write a shell script to check to see if the file “file_path” exists. If it does exist, display “file_path passwords are enabled.” Next, check to see if you can write to the file. If you can, display “You have permissions to edit “file_path.””If you cannot, display “You do NOT have permissions to edit “file_path””
```bash
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
```

5. Write a shell script that displays “man”,”bear”,”pig”,”dog”,”cat”,and “sheep” on the screen with each appearing on a separate line. Try to do this in as few lines as possible.
```bash
ANIMALS=( man bear pig dog cat sheep )
for i in "${ANIMALS[@]}"
do
  echo $i
done
```

