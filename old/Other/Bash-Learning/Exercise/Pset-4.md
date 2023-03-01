[Shell Scripting Exercises](https://medium.com/@sankad_19852/shell-scripting-exercises-5eb7220c2252)

### Problem 16-20

16. Created the start-up script for an application start and stop.
```bash
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
    if [ $? -eq "0" ]
      echo "conda stop"
    ;;
  *)
    echo "Error Input"
    ;;
esac
```

17. Write the shell script that displays one random number on the screen and also generates a system log message with that random number. Use the “user” facility and “info” facility for your messages.
```bash
MESSAGE="Random number is: $RANDOM"
echo "$MESSAGE"
logger -p user.info "$MESSAGE"
```

18. Modify the previous script to that it uses a logging function. Additionally, tag each syslog message with “randomly” and include process ID. Generate a 3 random numbers.
```bash
function logging() {
  Message=$@
  SET_MESSAGE="Random Number is:$MESSAGE"
  echo "$SET_MESSAGE"
  logger -i -p user.info "$SET_MESSAGE"
}
logging $RANDOM
logging $RANDOM
logging $RANDOM
```

19. Write a shell script that exits on error and displays command as they will execute, including all expansions and substitutions. Use 3 ls command in your script. Make the first one succeed, the second one fail, and third one succeed. If you are using the proper options, the third ls command not be executed.
```bash
#!/bin/bash -ex
# WSL不支持?
ls /mnt
ls /mnt/x
ls /mnt/f
```

20. Modify the previous exercise so that script continuous, even if an error occurs. This time, all three ls command will execute.
```bash
#!/bin/bash -x
# WSL不支持?
ls /mnt
ls /mnt/x
ls /mnt/f
```

