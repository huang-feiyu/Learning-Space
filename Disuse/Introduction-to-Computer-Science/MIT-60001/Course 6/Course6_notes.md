# Introduction to Computer Science

## Before this course:
* Required Reading:  <a href=../Resources/Python编程导论.pdf>Chapters 4.3 & 5.6</a>

##### 递归

* 数学归纳法程序版

## [In the Course:](https://www.youtube.com/watch?v=nykOeWgQcHM&list=PLUl4u3cNGP63WbdFxL8giv4yhgdMGaZNA&index=6&ab_channel=MITOpenCourseWare) 

##### 递归

* 提出一个问题，使用简单的方法去解答
* 分治策略提出的一个编程方法
* 调用自身的函数是递归函数
* 数据归纳法程序模式
* 汉诺依塔
  * 将除最大的盘外的所有盘看作是一个盘

```python
def printMove(fr, to):
    print('move from ' + str(fr) + ' to ' + str(to))

def Towers(n, fr, to spare):
    if n == 1:
        printMove(fr, to)
    else:
        Towers(n-1, fr, spare, to)
        Towers(1, fr, to spare)
        Towers(n-1, spare, to, fr)
```

##### 字典

* 类似于哈希表

