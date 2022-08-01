# Introduction to Computer Science

## Before this course:
* Required Reading:  <a href=../Resources/Python编程导论.pdf>Chapters 3.1 & 3.2-3.5</a>

##### 简单数值程序

* 穷举法

```python
x = int(input("Enter an integer: "))
ans = 0
while ans**3 < abs(x):
    ans = ans + 1
if ans**3 != abs(x):
    print(x, 'is not a perfect cube')
else:
    if x < 0:
        ans = -ans
    print("Cube root of", x, "is", ans)
```

* 近似解和二分查找
* 浮点数
  * 二进制数和十进制数的差异导致浮点数并不能充当decimal
* 牛顿法

```python
epsilon = 0.01
k = 24.0
guess = k / 2.0
while abs(guess * guess - k) >= epsilon:
    guess -= ((guess**2) - k) / (2*guess)
```


## [In the Course:](https://www.youtube.com/watch?v=nykOeWgQcHM&list=PLUl4u3cNGP63WbdFxL8giv4yhgdMGaZNA&index=3&ab_channel=MITOpenCourseWare) 

* String:
  * a sequence of case sensitive characters
  * can compare strings with ==, >, <
  * `len()` to get the length of the string
  * use index to locate:`string_name[num]`
    * 可以使用负数定位
  * `temp[start, stop, step]`: 固定步长获得一个字符
  * 不可变
* 穷举法
* 近似解 epsilon = ε
* bisection search

