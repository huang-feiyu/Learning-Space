# Introduction to Computer Science

## Before this course:
* Required Reading:  <a href=../Resources/Python编程导论.pdf>Chapters 2.2 & 2.3.1 & 2.4 & 3.2</a>

##### 程序分支

```python
if Boolean expression:
    block of code
else:
    block of code    
# 或者
if Boolean expression:
	block of code
# 或者
if x < y and x < z:
    print('x is least')
elif y < z:
	print('y is least')
else:
    print('z is least')
```

* 缩进：Python的缩进具有语义意义

##### 字符串

* `+`
* `*`
* 输入：
  * `input('String: ')` 函数，直接接受用户输入，返回用户输入的字符串

##### 迭代

```bash
x = 3
ans = 0
itersLeft = x 
while (iterLeft != 0):
	ans = ans + x
	itersLeft = itersLeft - 1
print(str(x) + '*' + str(x) + ' = ' + str(ans))	
```

##### `for`循环

* `range`: 接受三个整数参数 start、stop、step

```python
for variable in sequence:
    code block
```


## [In the Course:](https://www.youtube.com/watch?v=nykOeWgQcHM&list=PLUl4u3cNGP63WbdFxL8giv4yhgdMGaZNA&index=2&ab_channel=MITOpenCourseWare) 

* `String` type
* `if`: a control flow
* `while`
* `for`

```python
i = 0
for i in range(0, 3):
    print(i)
    i -= 1
"""
OUTPUT:
0
1
2
"""
#NOTICE: Rstop-1
```

