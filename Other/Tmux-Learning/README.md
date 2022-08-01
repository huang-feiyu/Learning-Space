# Tmux Learning
> 由于常常需要多开窗口，而Terminal背景常常会晃眼，我又舍不得换掉。
> 于是，我选择学习Tmux。——早有耳闻，从没用过。

我只准备学一个大概，并不期望用得非常熟练。(我的 Terminal 配置似乎不起效果，而且 vim
也没有颜色)

[Ruan Yifeng](https://www.ruanyifeng.com/blog/2019/10/tmux.html)

### 作用
窗口与会话解绑，将两者分离。

* 允许在单个窗口中，访问多个会话
* 支持窗口任意的垂直和水平拆分

### 使用
前缀键: `C-b`

* 会话管理
  * 新建会话: `tmux new -s {session-name}`
  * 分离会话: `tmux detach` / `C-b` then `d`
  * 查看所有会话: `tmux ls` / `C-b` then `s`
  * 接入会话: `tmux attach -t {session-name}`
  * 杀死会话: `tmux kill-session -t {session-name}`
  * 切换会话: `tmux switch -t {session-name}`
  * 重命名会话: `tmux rename-session -t 0 {new-name}` / `C-b` then `$`

### 操作流程
1. 新建会话tmux new -s my_session。
2. 在 Tmux 窗口运行所需的程序。
3. 按下快捷键Ctrl+b d将会话分离。
4. 下次使用时，重新连接到会话tmux attach-session -t my_session。

好麻烦，不如再开一个会话窗口。
