# Shell

> A note on shell.

## sh-xv6.c

[sh-xv6.c](./sh-xv6.c)

```bash
make all   # compile
make run   # run sh
make clean
```

## man dash

* "-" turns the option on, "+" disables the option
* There's multiple redirections
* "#!" - Magic Number to indicate a executable file
* `PATH` should be separated by ":"
* "{}" grouping commands together

```bash
### Flow Control
# if command
if list
then list
[ elif list
then list ]
[ else list]
fi

# while command (there is also break/continue)
whle list
do   list
done

# for command (there is also break/continue)
for variable [ in [ word ... ] ]
do  list
done
```


