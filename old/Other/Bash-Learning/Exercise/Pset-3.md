[Shell Scripting Exercises](https://medium.com/@sankad_19852/shell-scripting-exercises-5eb7220c2252)

### Problem 11-15
11. Write a script that executes the command `cat /etc/shadow`. If the command return a 0
exit status, report `command succeeded” and exit with a 0 exit status. If the command
returns a non-zero exit status, report `Command failed` and exit with a 1 exit status.
```bash
cat /etc/shadow

if [ "$?" -eq "0" ]; then
  echo "command succeeded"
  exit 0
else
  echo "Command failed"
  exit 1
fi
```

12. Write a shell script that consists of a function that displays the number of files
in the present working directory. Name this function `file_count` and call it in your
script. If you use variable in your function, remember to make it a local variable.
```bash
file_count() {
  local temp_file_count=$(ls -l | wc -l)
  echo "Numbers of files: $temp_file_count"
}
file_count
```

13. Modify the script from the previous exercise. Make the `file_count` function accept
a directory as an argument. Next, have the function display the name of the directory
followed by a colon. Finally display the number of files to the screen on the next line.
Call the function three times. First on the `/etc` directory, next on the `/var`
directory and finally on the `/usr/bin` directory.
```bash
File_count() {
  local file_count=$(ls $1 | wc -l)
  echo "Directory: $1"
  echo "Numbers of files: $file_count"
}
File_count /etc
File_count /var
File_count /usr/bin
```

14. Write the shell script that renames all files in the current directory that end in
`.jpg` to begin with today’s date in the following format: YYYY-MM-DD. For example, if
a picture of my cat was in the current directory and today was October 31,2016 it would
change name from “mycat.jpg” to “2016–10–31-mycat.jpg”.
```bash
DAY=$(date +%F)
cd /mnt/p/Project/Exercise/Shell/temp

for FILE in *.jpg
  do
  mv $FILE $DAY-$FILE
done
```

15. Write the script that renames files based on the file extension. Next,It should ask
the user what prefix to prepend to the file name(s). By default, the prefix should be
the current date in YYYY-MM-DD format. If the user simply press enter,the current date
will be used. Otherwise, whatever the user entered will be used as the prefix. Next,it
should display the original file name and new name of the file. Finally,it should
rename the file.
```bash
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
```

