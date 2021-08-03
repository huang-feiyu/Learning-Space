# Linux Shell

<a href="https://www.wangchujiang.com/linux-command">查看命令</a> 

<a href="https://www.pathname.com">Linux所有目录</a>

### 0. Others

##### 1. 根目录解析

~目录：home目录/用户=》户目录

/目录：根目录

/home: 其中有用户，户目录

/bin: 二进制文件

/cdrom 光盘文件

/etc 系统配置文件(注册表plus)

/lib 库目录，存放系统应用程序库文件(library) 

/lib64 64位

/lib32 32位

/lost+found 断电了，文件在这里

/mnt 挂载目录，外在设备连接显示在这里（一切皆文件）

/proc 虚拟文件系统

/run 运行目录，存放运行程序产生的临时文件

/tmp 临时目录

/var 可变目录，存放log文件之类的经常变化的文件

/boot 启动目录

/dev 设备目录（device），驱动程序、网络端口、显示屏等等

/media 媒体目录(mp3等等)，主要挂载目录是/mnt

/opt 可选目录，第三方软件包之类的

/root 管理员主目录

/sbin 系统二进制目录，存放GNU高级管理员使用的命令工具（super）

/srv 服务目录（service）

/usr 用户二进制目录,GNU工具与自己的二进制文件等等

##### 2. Linux下的路径

绝对路径与相对路径的学习

##### 3. 组合命令

```bash
#         并且
cd ../doc && ls -alF
```

##### 4. 终端光标移动方法

`Tab`: 补全

`CTRL` + 方向键：跳过单词（使用下划线命名法更迅捷）

`CTRL` + a: 开头

`CTRL` + e: 结尾

`CTRL` + b: 前移一个光标

`CTRL` + f: 后移一个光标

`CTRL` + h: BackSpace

`CTRL` + t: 后挪字母

`CTRL` + r: 寻找曾经的命令

`CTRL` + u: 干掉前面的所有

`CTRL` + k: 干掉后面的所有

##### 5. 挂载mouting

linux不会创建虚拟盘，而是直接加入到media或者mnt中

##### 6. 父子Shell

一层shell套一层

ppid 是父亲的PID

![image-20210509160204756](F:\Pictures\img_typora\image-20210509160204756.png)

##### 7. 分号的作用

```bash
# 依次执行,可以带括号生成子Shell执行
ls ; pwd ; cd /;

(ls ; pwd ; cd /; echo $BASH_SUBSHELL)
==>1

(ls ; pwd ; (cd /) ; (echo $BASH_SUBSHELL))
===>2
```

##### 8. 外部命令与内建命令

外部命令：单独创建一个进程,脱离原来的bash shell

内建命令

##### 9. 环境变量

* Windows 环境变量：预约，提前写到了内存中。被写入path环境变量的路径，路径中这些程序能够在任何地方都可以访问。

	* 用户变量：当前用户才能使用
	* 系统变量：所有用户都可以使用
* Linux环境变量：
  * 全局变量：
  * 局部变量：单个shell可以使用

```bash
# 定义局部变量,不得写成大写,z
~$ fuck="NNGT"
~$ echo $fuck

# 定义全局变量,不得写为大写
~$ export fuck="NNGT"
# 删除全局变量
~$ unset fuck
```

* 追加系统PATH变量

```bash
# 临时
PATH=$PATH:/home/frank/Project/
# 永久系统变量
# 修改~/.bashrc
```

* 开机的时候默认读取环境变量等等文件`/etc/bash.bashrc`  `/etc/zsh/zshrc` ,最好不要修改/etc中文件
* 一般修改用户目录下的`.bashrc`,`.bash_profile`,`.profile`,`.bash_login`

##### 10. 软件相关

* package management system: PMS
  * 包管理系统: 软件管理，安装、更新、卸载
  * 不同发行版本使用不同的包管理系统
  * 工具依赖，早期Linux的弊端可以通过PMS解决
  * 自动配置环境变量
  * dpkg(Debian, Ubuntu)
    * apt 推荐使用
    * apt-get
    * apt-cache
    * apt-file
    * aptitude: 彻底解决工具依赖问题,现在无人维护
  * yum

```bash
# 安装软件
sudo apt install st_name
# 显示可以安装的软件
apt list
# 查找更新
apt update
# 一键更新 先使用update命令
apt upgrade
# 卸载
apt remove st_name
```

##### 11. 用户和权限

linux是相对安全的, 可以创建几个系统用户以防止root泄露导致整个系统安全完全被干掉。

* UID: User ID，一个数字
* GID: Group ID, 组ID


```bash
cat /etc/passwd

cat /etc/shadow    # 影子文件，存放密码
```

##### 12. 组

* 目的：共享资源的权限
* 不同发行版本对组的不同组织方式

```bash
grep /cat/group
```

##### 13. 权限
* 第一个字母
  * d: directory
  * -: file
  * l: link file
  * b: 接口设备，可随机存取装置
  * c: 一次性装置
* 三个一组的字母, 每组三个字母
  * rwx: r——read, w——write, x——excute
  * 这三个字母的位置不会改变，如果没有权限就会出现`-`
  * 第一组: 组创始人权限 u
  * 第二组: 组下属成员权限 g
  * 第三组: 其他组成员权限 o

还有八进制的权限模式，R=4, W=2, X=1，类似于哈夫曼编码。


### 1. `ls`

列出文件目录

-a 所有

-r 子目录

-t 按时间排列

-l 输出信息

-1 竖列输出

-F 文件夹

-R 递归显示文件夹下面的文件

路径参数: 与cd命令的路径用法一致

**文件过滤**

```bash
#             *匹配多个字符
ls -l fhs-2.3_*.pdf

#              ?匹配一个字符
ls -l fhs-2.3_c?py.pdf
// above是文件拓展名匹配

// below是通配符匹配
# 元通配符匹配
#		a到x范围内	
ls -l f[a-x]ck.txt

#       非a到x范围内
ls -l f[!a-x]ck.txt
```

### 2.` ll`

列出文件和很多信息

### 3. `man`

manual帮助手册

### 4. `clear`  OR `<CTRL>+L` 

清屏

### 5. `cd`

cd  切换到用户当前工作目录

cd 路径   切换到指定目录

cd .    切换到当前目录

cd ..   切换到上一层目录

cd  /   根目录

cd ../..   上一个目录的上一个目录 

### 6. `<CTRL> + c`

强制退出

`<CTRL> + <Shift> + c` 复制

`<CTRL> + <Shift> + v` 粘贴

**命令没有办法撤销**

### 7. `touch`

创建文件

touch name.fix

touch 存在的文件可以更新最后一次时间

### 8. `cp`

复制文件

```bash
#  源文件 目标文件（没有则创建）
// 企业中不允许使用有风险的命令
cp 1.txt 2.txt

#  -i 表示覆盖既有文件时询问用户
cp -i 1.txt 2.txt
# 覆盖文件时也会改变时间

# 复制文件夹下面的文件
cp /home/frank/Documents/doc/* /home/frank/Downloads/

# 复制文件夹 -r递归
cp -r /home/frank/Documents/doc/ /home/frank/Downloads/

# -R 递归 复制当前目录的Java文件到temp
cp -R ./*.java ~/Documents/temp
```

### 9. `pwd`

输出当前绝对路径

### 10. Linux快捷方式

.lnk     Windows快捷方式

### 11.file

查看文件格式

```bash
file 2.txt
=> ASCII text

file -i 2.txt 
// MIME 媒体类型 
```

### 12. cat

```bash
cat 1.txt
// 所有的数据

cat -A 1.txt
// 回车,tab显式化
```

### 13. more

```bash
more 1.txt
// vi类似展示
// <space>下一页   b 上一页     h 帮助      q 退出
```

### 14. less

```bash
less 1.txt
// vi类似操作
// 作用不大
```

### 15. tail  head

```bash
tail abc.log
// 看最后十行

tail -n 2 demo.c
// 后两行
```

### 16. top

查看任务

Ubuntu自带的System Monitor: /ma:netor/

### 17. ps

process status

查看用户进程

PID: 进程id(process id)

```bash
// 参数
ps -aux | grep named # 查看进程详细信息

ps -l

ps -A
```

### 18. kill

直接干掉

```bash
kill 2974
//    PID
kill -l 
// 列出进程
kill -9 
#   强制停止
```

### 20. df

查看一些信息

![image-20210425152558047](F:\Pictures\img_typora\image-20210425152558047.png)

### 21. mount

查看挂载信息

```bash
# 查看挂载的位置
sudo fdisk -l

# 改变挂载位置
sudo mount /dev/usb /mnt/
```

### 22. umount

```bash
# 移除挂载
umount /media/frank/USB
```

### 23. df

查看磁盘空间

```bash
# 带单位
df -h
```

### 24. du

当前目录的大小

```bash
# 带单位
du -h
```

### 25. sort

```bash
# 文本文件排序
sort test.txt
# 按数字排序
sort -n
# 逆序
sort -r
# 按照日期排序
sort -M time.log

du -sh * | sort -nr
```

### 26. grep

查询搜索

```bash
grep Hello ./test
```

### 27. gzip 

.gz

.tar.gz打包后压缩

### 28. tar

打包多个文件、文件夹成一个文件

-z: gizp属性

-v: 压缩过程

-c: 创建一个新归档

-f: 使用档案名

-x: 解压缩

```bash
# 打包压缩成一个log.tar.gz
tar -zcvf log.tar.gz log_dir
# 打包不压缩
tar -cvf log.tar log_dir
# 解压
tar -zxvf log.rat.log /mnt/f
```

### 29. zip

.zip

### 30. bzip2

.bz2

### 31. echo

打印一个参数代表的东西

### 32. sleep

终端睡眠10s后再执行

```bash
sleep 3 # 睡眠3秒
sleep 300& #   &放在后台
```

### 33. jobs

查看进程在后台运行

```bash
jobs -l #可以看到进程的Pid
```

### 34. coproc

协程

子shell后台运行,花括号两边有空格，最后用;结尾

```bash
coproc frank_av { sleep 10; }
```

### 35. type

查看命令的类型,内建还是外部

### 36. history

查看之前运行过的命令

```bash
!100 # history显示的命令序号
```

### 37. !!

上一个命令

### 38. alias

```bash
alias -p # 查看别名

# 创建自己的别名,暂时
alias li='ls -li'
```

### 39. printenv

```bash
#打印所有环境变量
printenv
#打印用户
printenv USER
# $HOME 任何地方都替换为/home/huang/
printenv $HOME
```

### 40. useadd, userdel
```bash
useradd huang   # 添加用户
userdel huang   # 删除用户
```

### 41. passwd
```bash
passwd huang    # 设置密码
```

### 42. chpasswd

```bash
chpasswd huang   # 修改单个用户密码

chpasswd < passwd.txt   # 从文件中读取信息修改多个用户密码
```

### 43. chmod

```bash
chmod 777 file   # 删除所有权限
# 每个数字分别代表u, g, o
```

### 44. usemod, groupadd, groupdel, groupmod

对于组的处理方式

