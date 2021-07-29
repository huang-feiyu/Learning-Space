# The Missing Semester of Your CS Education

这是MIT课程`The Missing Semester of Your CS Education`的笔记，并不是很详尽。

[Website](https://missing-semester-cn.github.io/)

### Course 1: Overview + The Shell
[Frank:步入Linux的现代方法](https://www.yuque.com/frank-93a7b/fuck/vn5gqk)是我学习Linux的入门课程，涵盖了所有这节课所讲的东西。
* We need to use shell to do nearly everything.
* 环境变量：可以直接读取，全局变量、局部变量
* 路径：位置，相对路径、绝对路径
* 参数: tag, path, filename, etc.
* 使用`<` `>`管道
* root: 超级用户, 一般不会使用root身份——可能会干掉计算机

### Course 2: Shell Tools and Scripting

* bash script
* `convert` 转换
* {foo, a}/{d, g}           # 笛卡尔积
* python script
* mv -i   # 确认是否移动
* tldr : 简单阅读manual
* find : 查找文件
* locate : 大量查找文件
* history : 查找之前使用过的命令
* CTRL + r : 向后查找命令

### Course 3: Editor(Vim)

* I cannot live without vim.

### Course 4: Data Wrangling

* 过滤数据：正则表达式

### Course 5: Command Line Environment

* Job Control

  * Ctrl + c : terminate process  SIGINT
  * Ctrl + z : terminate process  SIGSTOP
  * Ctrl + \ : terminate process  SIGQUIT

* Terminal Multiplexers

  sessions=>windows=>panes

  * tmux: 窗口内创建新的terminal进程

* Dotfiles and How to configure your shell

  * alias: 重映射
  * .dotfiles [github](https://dotfiles.github.io/), 配置文件

* Remote machines

  * ssh xxx@xxx.xxx.xxx.xxx

### Course 6: Version Control(git)

git的底层模型简单介绍

* 数据模型：git使用有向无环图

  * blob = array\<byte>
  * tree = map<String, tree | blob>
  * commit = string + someting

    * parents: array\<commit>

    * author: String

    * message: String

    * snapshot: tree
  * object = blob|tree|commit
  * objects = map<String, object>  (use hash-function)
  * reference = map<String, String>

```pseudocode
def store(0)
	id = sha-1(0)
	Objects[id] = 0
def load(id)
return Objects[id]
```

```bash
git log --all --graph --decorate # 图形化查看更改
git log --all --graph --decorate --oneline
```

[Git学习笔记](https://huang-feiyu.github.io/2021/07/28/Learning-Git/)

### Course 7: Debugging and Profilling

这个人印度口音太重了，而且我也没有学过Python，所以算了

### Course 8: Metaprogramming

对软件系统的测评，并不是真正的Programming.

* `make`
* 版本号
* 锁定文件

### Course 9: Security and Cryptography

* 熵：衡量密码随机性
* 哈希函数：不可逆、少冲突====>SHA-1
* open-ssl: 加密
* 双向

### Course 10: Potpourri

* 键盘映射
* 守护进程
* 云
* 备份
* api
* 命令行工具
* VPN
* markdown
* BIOS
* 虚拟机、docker
* notebook programming
* github
