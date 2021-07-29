# C++语言学习笔记

> 前言
为什么学习c++,第一是因为学习CMU 15445需要使用cpp编程，并且学校在大二会开一门关于OOP的课程(c++为载体)。我已经大概了解了面向对象基本思想，现在需要的就是了解c++语言本身。

# c专家编程(c++快速入门)
### OOP 面向对象基础
* c++时ANSI C的一个超集
* abstraction 抽象：去除对象中不重要的细节的过程，只有那些描述了对象的本质特征的关键点才得以保留  
* class类: 用户定义类型
* object 对象：类的一个实例
* encapsulation 封装: 将类型数据函数组合在一起组成一个类
* inheritance 继承：从超类中接收数据结构和函数

##### 抽象
* 隐藏不重要的细节，关注本质特征
* 向外部世界提供一个黑盒子接口
* 将一个复杂的系统分成相互独立的组成部分，可以做到分工明确
* 重用和共享代码

##### 封装
* 将抽象数据类型和操作捆绑起来
* 保证了安全性和清晰性

##### 类
```c++
class classname {
    // 访问控制: 声明
};
/* 访问控制：
 * public 类的外部可用，一般不会使用public
 * protected: 只能够由该类本身的函数或者派生子类修改使用
 * private: 只能够由该类的成员函数访问
 * friend, virtual: 其他的两个控制访问符
*/
```

##### 声明
```c++
#include <iostream>
using namespace std;
// 正常的c语言声明
// 类的声明
class Fruit {
    public: peel(); slice(); juice();
    private: int weight, calories_per_oz;
};
// 类的一个实例
Fruit melon;

// 类的成员函数
class fruit {
    public: void peel() { cout << "in peel";}
            slice();
            juice();
    private: int weight, calories_per_oz;        
};

class Fruit {
    public: void peel();
                slice();
                juice();
    private: int weight, calories_per_oz;             
};
//    全局范围分解符
void Fruit::peel() {cout << "in peel";}


// 调用成员函数
Fruit melon, orange, banana;
main() {
    melon.slice();
    orange.juice();
    return 0;
}
```
##### 构造函数和析构函数
- 大多数类至少有一个构造函数，负责对象的初始化。
- 与构造函数对应，也存在一个析构函数用于清理delete
* 构造函数的名字总是和类的名字一致, 可以声明多个构造函数，使用参数来区分它们
* 析构函数名字也与类名一致，但是在前面加上一个 `~` 取反符 

##### 继承
```c++
//    Apple 继承了 Fruit， fruit是apple的超类
class Apple : public Fruit {
};
```
信条：c语言很容易让你开枪的时候伤到自己的脚，C++很少发生这种情况。但是一旦发生，它很可能轰掉你的整条腿。
**多重继承：一般不使用**

##### 重载
- 简单的服用一个现存的名字，但是使它操作一个不同的类型。
```c++
// 对操作符进行重载
class Fruit {
    public void peel(); slice(); juice();
            int operator+(Fruit &f); // 重载 +
    private: int weight, calories_per_oz;        
};

int Fruit::operator+(Fruit &f) {
    printf("calling fruit addition\n");
    
    return weight + f.weight;
}

Apple apple;
Fruit orange;
int ounces = apple + orange;
```

##### I/O
- c++的iostream.h头文件提供了IO接口，让IO操作更加方便
- `<<` 插入    `>>`提取 

##### 多态——运行时绑定
**polymorphism**

##### others
- 异常
- 模板：参数化类型
- 传递引用
- ...

### 对于c++的思考

> 尽量只使用C++
>
> * 类
> * 构造函数和析构函数
> * 重载
> * 单重继承和多态
>
> 避免使用
>
> * 模板
> * 异常
> * 虚基类
> * 多重继承

*或许它过于复杂，但是却是唯一可行的方案。*


# c++编程思想 第一卷

## c++语言基础

(编程方法：

XP极限编程：1. 先写测试（对类思考更加清楚） 2. 结对编程，一个人写代码，一人 思考)

### 声明

```c++
// 函数声明
// 返回int，两个int参数
int fuc1(int, int);
// 返回int, 不带参数
int fuc2();

// 函数定义
int func1(int length, int width){
}

// 变量
// 声明却不定义
extern int a;

// 包含头文件
#include <header.h>
#include "local.h"
// in cpp 没有后缀.h (部分有)
#include <iostream>
// 继承c的头文件标准库 
#include <cstdio>
```

### 第一个c++程序

```c++
// iostream类，iostream包自动定义一个名为count的对象，接受所有与标准输出绑定的数据
// count = cosole output
#include <iostream>

// << 发送到  (运载符的重载s)
cout << "howdy!"; // 将字符串发送到count对象中
```

##### 名字空间 namespace

```c++
// namespace会使相同名字的定义分数不同空间，不冲突
using namespace std;
// 我要使用std的名字空间中的声明

#include
<iostream.h>
// ===
#include
<iostream>
using namespace std;
```

##### 程序基本结构

```c++
// Hello world!

#include <iostream>
using namespace std;

int main() {
    // 预设输出流               end of line
    cout << "Hello, world!" << endl;
    int number;
    // 预设输入流
    cin >> number;
}
// 编译
// g++ helloc.cpp


// 字符串简介(不用在意存储空间)
#include <string>
#include <iostream>
using namespace std;

int main() {
    string s1, s2; // empty strings
    string s3 = "hello world";
    string s4("I am");
    s1 = s3 + " " + s4;
}

// 文件读写
#include <string>
#include <fstream>
using namespace std;

int main() {
    ifstream in("Scopy.cpp"); // open for reading
    ofstream out("Scopy2.cpp"); // Open for writing
    string s;
    while (getline(in, s)) // discard newline char
        out << s << "\n"; // ...must add it back
}

// vector类是一个template模板
#include <string>
#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

int main() {
    vector<string> v;
    ifstream in("Fillvector.cpp");
    string lin;
    while (getline(in, line))
        v.push_back(line); // add the line to the end
    for (int i = 0; i < v.size(); i++) {
        cout << i << ": " << v[i] << endl;
    }
}
```

### 与c的不同之处

- 说明符：`long`, `short`, `signed`, `unsigned`

- 引用：指针之外的给函数传递地址的途径

```cpp
#include
<iostream>
using namespace std;

// c++ 中使用的一种语法糖
void f(int& r) {
    cout << "r = " << r << endl;
    cout << "&r = " << &r < endl;
    r = 5;
    cout << "r = " << r << endl;
}
```

- **我们一般不使用 `void *`**

- `register` `static` `extern`  `const`(const有时候必须使用)

- `volatile` 不知道何时会改变，防止编译器根据变量稳定性做出任何优化

- c++显示转换： `static_cast`  `const_cast`  `reinterpret_casr` `dynamic_cast`

- - static_cast: 全部用于明确定义的变换
  - const_cast: 将const转换为非const 或者 将volatile转换为非volatile
  - reinterpret_cast: 重解释转换，当需要使用的时候所得到的东西已经不同了
  
- `asm` 关键字: 转义机制，允许在c++中编写汇编代码

##### 调试技巧
1. 使用预处理器 `#define` 定义一个或者多个调试标记.

2. 运行期调试标记

3. `assert()` 宏

##### 函数地址
```c++
// 定义函数指针
void (*funcPtr)();
```

#### cMake: 管理分段编译
make程序：按照一个名为makefile的文本文件中
的指令去管理一个工程中的单个文件。make仅仅编译
已经改变了的源代码，以及其他受到修改文件影响的源代码文件。

**学会make命令会减少很多挫折**

#####  make的行为
1. 输入make时，会寻找makefile文件。
2. 如果没有创建工程，有工程则选择需要编译的文件
3. makefile的所有注释都是从 `#` 起到本行的末尾

## 编码准则
- 先让程序运行，再优化
- 编写简洁的代码
- 分而治之的思想
- 不要用c++主动重写c
- 如果有许多c需要改变，首先隔离不需要修改的代码，封装
- 尽可能private
- 不要陷入到分析瘫痪中
- 首先编写测试代码，并和类代码一起提交
- 抽象是面向对象的本质特征
- 原子化类
- 减少长代码、长参数表
- 不要自我重复
- 注意不同点
- 接口应该尽可能小而精
- 当我们再类中放一个virtual函数时，将所有函数都定义成虚函数，定义一个虚析构函数
- 减少使用运算符重载
- 在构造函数中只做最必要的事情
- 减少创建类模板
- 尽量不要使用c中的函数和内部数据类型
- 充分利用编译器的错误检查功能，将所有的警告消除

## C++ Lecture
### Lecture 0
* Linux: Unix-like OS, Open-Source
    * stdin: 
    * stdout: command 1> out.txt
    * stderr: command 2> out.txt
    * use stdout & stderr programm 1> stdout.txt 2> stderr.txt
    * kill -9 <pid>: kill the process with id pid
    * killall <pname>: kill all processes with name pname
    * htop: shows an overview of running processes
    
#### Modern C++ 
> ** Within c++, there is a much smaller and cleaner language struggling to get out. **
* Good code style: ** Google Code Style Sheet **
    * clang_format: format the code
    * cpplint: check the style
* Everything starts with main: main-function
    0 means OK, [1, 255] means any error
* #include <>: system include files
    #include "": local include files
* <iostream>: part of C++ standardd library
    * std::cin      stdin
    * std::cout     stdout
    * std::cerr     stderr
    * std::endl     the end of this line
* GCC, Clang
    * c++ -std=c++11 -o hello_world hello_world.cpp

### Lecture 1
#### variables
**Always initialize variables if you can**

* Naming variables
    * Name must staty with a letter
    * Give variables meaningful names
    * Don't be afraid to use long names
    * Don't include type in the name
    * Don't use negation in the name
    * snake_case: all lowercase, underscores separate words
* build-in types
    * bool
    * char
    * int 
    * short
    * long 
    * float
    * double
    * auto
* Operations on arithmetic types
    * Avoid `==` for floating point types
#### Strings
* `#include <string>`    to use `std::string`
* there is + to concatenate
+ str.empty() to check the `str` is empty of not

#### std::array
* `#include <array>`   to use `std::array`
* array<float, 3> arr = { 1.0f, 2.0f, 2.0f};
* arr[i] begins with 0
* arr.clear() to remove alll elements
* arr.front() == arr[0]      arr.back() == arr[arr.size() - 1]

#### std::vector
* #include <vector> to use std::vector
* vector is implemented as a dynamic table
* add a new item:
    * vec.emplace_back(value)       [preferred, c++11]
    * vec.push_back(value)          [historically better know]
* Use it! It is fast and flexibale!
* Vector is a default container to store collections of items of any same type.
* push_back/emplace_back force vector to change its size many times
* reserve(n)   ensures that the vector has enough memory to store n items  (If you know what n is)

```c++
std::vector<int> vec_test_one = {1, 2};
std::cout << vec.front() << " " << vec.back() << std::endl;
vec_test_one.emplace_back(3);
vec_test_one.push_back(4);
std::cout << vec[0];
// add the vec after
vec_test_one.insert(5,2); // or (2,5), I don't know
```

#### Any variable can be const
* use `const` to declare a constant
* constant name: CamelCase starting with a small letter k,   like kImportantHello
* declare everything const unless it must to be changed

#### References to variables
* we can create a reference to any variable
* Use `&` to state that a variable is a reference
    * float& ref = original_variable;
    * std::string& hello_ref = hello;
* const with references:  To avoid unwanted changes use `const` and references are fast as well
    * const float& ref = original_variable;

#### for loop
* In c++ `for` loops are very fast. Use `for` when number of iterations is fixed and `while` otherwise
* Range for loop: c++11
    * for (const auto& value : container)
    * for (float num : vec)   : for number in vec, `num` is a new declared variable

#### git: software for distributed version control
* synchronizes local and remote files
    * synchronized:   
    * Local files on a computer
    * Remote Files in the repository
* stores a history of all changes
* fork a repository in Git means to create a copy of the repository for your user
* 
```bash
# cloning a repository
git clone <repo_url> <local_folder>
# in <local_folder>:
git add <files>
git status
git commit -am 'descriptive message'
git push origin master
```

#### some resources
* cpp core guidelines: github.com/isocpp/cppcoreguidelines
* google code styleguide
* git guide
* c++ tutorial
* code complete 2

### Lecture 2
#### compilation flags and debugging
* -std=c++11
* -o
* Enable all warnings, treat them as errors: -Wall, -Wextra, -Werror   (W means warnings)
* `-O3` or `-Ofast` full optimizations    (o means optimizations)
* keep debugging symbols: -g
* Debugging tools: `gdb`, there is a great video in youtube to teach you gdb
    * `break main`    breakpoint main-func 
    * `r`            run
    * `q`             quit
    * `next`          next line
    * use `gdbgui` for a user-friendly interface
    * gdbgui a.out
    * sudo pip3 install --upgrade gdbgui

#### Functions
* code can be organized into functions
* create a scope
* single return value from a function
* should do only one thing and do it right
* Name must show what the function does: CamelCase, write small functions
* declaration sets up an interface: void FuncName(int param);
* definition holds the implementation of that function that can even be hidden from the user
* Pass by reference to avoid copy which needs a lot of time, but it can make the variable change
    * Solution: pass const reference to the function
* Use snake_case for all function arguments
* Avoid using non-const refs
##### Function overloading
* compiler infers a function from arguments
* cannot overload based on return type
* return type plays no role at all
* avoid non-obvious overloads

##### Default arguments
* Functions can accept default arguments
* **Only set in declaration not in definition**
* Pro: simplify function calls
* Cons:
    * Evaluated upon every call
    * Values are hidden in declaration
    * Can lead to unexpected behavior when overused
* Only use default arguments when readability gets much better
```c++
int Sum(int a, int b = 10) {
    return a + b;
}
```
**Don't reinvent the wheel**

* When using vector, array, etc, try to avoid writing your own functions
* You can use `#include <algorithm>`

#### Header / Source Separation
* Move all declarations to header files (\*.h)
* Implementation goes to \*.cpp or \*.cc
* `#pragma once` // Ensure file is included only once

#### Libraries
* multiple object files that are logically connected
* static libraries: faster, take a lot of space, become part of the end binary, named: lib\*.a
* dynamic libraries: slower, can be copied, reference by a program, named lib\*.so
* create a static library with: ar rcs libname.a module.o module.o etc
* static libraries are just archives just like: zip/tar/...

* compile modules: c++ -std=c++11 -c tools.cpp -p tools.o
* organize modules into libraries: ar rcs libtools.a tools.o <other_modules>
* link libraries when building cod: c++ -std=c++11 main.cpp -L . -ltools -o main
* Run the code: ./main

##### linking
* The library is a binary object that contains the compiled implementation of some methods
* Linking maps a function declaration to its compiled implementation
* To use a library we need a header and the compiled library object

#### CMake Info
* One of the most popular build tools
* Does not build the code, generates files to feed into a build system
* Cross-platform
* Very powerful, still build receipt is readable
* The library creation and linking can be rewritten as follows:

```cmake
add_library(tools tools.cpp)
add_executable(main main.cpp)
target_link_libraries(main tools)
```
> structure:
> project_name/
>             CMakeLists.txt # defines the whole build
>             build/   #All generateed build files
>             bin/
>                 tools_demo
>             lib/
>                 libtools.a
>             src/
>                 CMakeLists.txt
>                 project_name/
>                             CMakeLists.txt
>                             tools.h
>                             tools.cpp
>                             tools_demo.cpp
>             tests/
>                  test_tools.cpp
>                  CMakeLists.txt
>             README.md     

```bash
cd <project_folder>
mkdir build
cd build
cmake ..
make -j4 # pass your number of cores here
```

```cmake
project(first_project)
cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_STANDARD 11)  # use c++11
# tell cmake to output binaries here:
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
# tell cmake where to look for *.h files
include_directories(include)
# create library "libtools"
add_library(tools src/tools.cpp)
# subdirectory needs a CMakeLists.txt as well
add_subdirectory(${PROJECT_SOURCE_DIR}/src}
# add executable main
add_executable(main src/tools_main.cpp)
# tell the linker to bin these objects together
target_link_libraries(main tools)
```
* just a scripting language
* set variables with set(VAR_VALUE)
* Get value of a variable with ${VAR}
* Show a message message(STATUS "message")

### Lecture 3
#### google tests(GTest)
**Keep calm and write Unit Tests**

* Catch bugs early to fix them with less pain
* Testing is crucial to catch bugs early
* Tested functions are easier to trust
* FOr every function write at least two tests
    * one for normal cases
    * one for extreme cases
* Make writing tests a habit

* A single dummy Google test:
> TEST(TestModule, FunctionName) {
>   EXPECT_EQ(4, FunctionName());
> }

##### Add GTests with CMake
* Install GTest source files (build them later): sudo apt install libgtest-dev
* Add folder `tests` to your CMake project: 

```cmake
# Must be in the top-most CMakeLists.txt file
enable_testing()
# Outsource tests to another folder
add_subdirectory(tests)
``` 

```cmake
add_subdirectory(/usr/src/gtest
                 ${PROJECT_BINARY_DIRECTORY}/gtest)
include(CTest) # Include testing cmake package
# Set binary name for convenience
set(TEST_BINARY ${PROJECT_NAME}_test)
# This is an executable that runs the tests
add_executable(${TEST_BINARY} test_tools.cpp)
# Link the executable to needed libraries
target_link_libraries(${TEST_BINARY}
    tools   # library we are testing
    gtest gtest_main  # GTest libraries
)
# Add Gtest to be able to run ctest
add_test(
    NAME ${TEST_BINARY}
    COMMAND ${EXECUTABLE_OUTPUT_PATH}/${TEST_BINARY})
```

```bash
# TO run the tests
cd project_folder
mkdir build
cd build
cmake ..
make
ctest -VV
```
    
#### Namespaces
* Helps avoiding name conficts
* Group the project into logical modules
* Avoid `using namespce my_namespace;` in the header file
* Only use what you need
```c++
namespace module_1 {
    void SomeFuc() {};
} // no ; in the end
```
##### Nameless namespaces
If you find yourself relying on some constants in a file and these constants should not be seen in any other file, put them into a nameless namespace on the top of this file.
```c++
namespace {
    const int kLocalImportantInteger = 1;
}
```

#### Classes
* Classes are used to encapsulate data along with methods to process them
* Every class or structs defines a new type
* Terminology:
    * Type or class to talk about the defined type
    * A variable of such type is an instance of class or an object
* Classes allow C++ to be used as an OOP language
* string, vector, etc. are all classes
* declarations in the class, implementation is out of the class

##### syntax
* Definition starts with the keyword `class`
* Classes have three access modifiers:
    * private: only the its own variable and function can access 
    * protected:
    * public: everything can access
* By default everything is private
* Classes can contain data and functions
* Access members with a `.`
* Have two types of special functions:
    * Constructor: creation of an instance of the class
        name is ClassName()
    * Destructor: destruction of an instance of the class
        name is ~ClassName()
* Use CamelCase for class name

##### struct
* everything is public
* no functions
* use struct as a simple data container, if it needs a function it should be a class instead

##### Data stored in a class
* class can store data of any type
* data must be private
* Use snake_case\_ with a trailing "\_" for private data members
* Data should be set in the Constructor
* Cleanup data in the Destructor if needed

##### Constructors and Destructor
* Classes always have at least a constructor and exactly one destructor
* Constructors          
    * Are functions with no return type
    * Named exactly as the class
    * There can be many constructors
    * If there is no explicit constructor an implicit default constructor will be generated
* Destructor
    * named exactly as ~ClassName
    * Last function called in the lifetime of an object
    * Generated automatically if not explicitly defined

You can use {} to create a struct or an object, like SomeClass var{10, 10.0}, SomeStruct var{10, 2}. or ().

##### Setting an getting data
* Use initializer list ot initialize data
* Name getter functions as the private member they return
* Make getters const
* Avoid stters, set data in the constructor

```c++
class Student {
    public: 
        Student(int id, string name) : id_{id}, name_{name} {}
        int id() const { return id_; }
        // const reference, no change and no copy
        const string& name() const { return name_; }
    private: 
        int id_;
        string name_;
};
```

##### Const correctness
* const after functioin states that this function does not change the object
* Mark all functions that should not change the state of the object as const
* Ensures that we can pass objects by a const reference and still call their functions
* Substantially reduces number of errors

##### Declaration and definition
* Data members belong to declaration
* Class methods can be defined elsewhere
* Class name becomes part of function name

##### Always initialize members for classes
* C++11 allows to initialize variables in-place
* Do not initialize them in the constructor
* No need for an explicit default constructor
**Leave the members of structs uninitialized as defining them forbids using brace initialization**


### Lecture 4

#### Move semantics
##### rvalue and lvalue
* lvalue: Anything can be written on the left of =
* rvalue: can not
* Explicit rvalue defined using &&
* Use std::move(...) to explicitly covert an lvalue to an rvalue
* The value after move is undefined

```c++
int a; // a is an lvalue
 int& a_ref = a; // a_ref is a reference to an lvalue
a = 2 + 2; // a is an lvalue, 2+2 is an rvalue
int b = a + 2; // b is an lvalue
int&& c = std::move(a); // c is an rvalue
```

##### std::move
* Think about ownership
* Entity owns a variable if it deletes it
    * A function scope owns a variable defined in it
    * An object of a class owns its data memebers
* Moving a variable transfers ownership of its resources to another variable
* Runtime: better than copying, worse than passing by reference

#### Operator overloading
* <RETURN_TYPE> operator<NAME>(<PARAMS>)
* <NAME> reprensents the target operation, <, >, =, ==, << etc.
* Have all attributes of functions
* Always contain word operator in name
```c++
bool operator<(const Human& other) const {
    return kindness_ < other.kindness_;
}
```

#### Making your class copyable
* Called automatically when the object is copied
* For a class MyClass has the signature: MyClass(const MyClass& other)
```c++
MyClass a;
MyClass b(a);   // calling copy constructor
MyClass c = a; // calling copy constructor
```
##### Copy assignment operator
* Called automatically, Lvalue
* For class MyClass has a signature: MyClass& operator=(const MyClass& other)
* Returns a reference to the changed object
* Use \*this from within a function of a class to get a reference to the current object
```c++
MyClass a;
MyClass b(a); // calling copy constructor
MyClass c = a; // calling copy constructor
a = b; // Calling copy assignment operator
```

#### Making your class movable
* Called automatically when object is moved
* For a class has a signature: MyClass(MyClass&& other)
```c++
MyClass a;
MyClass b(std::move(a)); // move constructor
MyClass c = std::move(a); // move construtor
```
##### Move assignment operator
* Called automatically,  Rvalue
* MyClass& operator=(MyClass&& other)
* Return a reference to the changed object 
```c++
MyClass a;
MyClass b(std::move(a)); // move constructor
MyClass c = std::move(a); // move constructor
b = std::move(c); // Move assignment operator
``` 

#### Rule of all or nothing
* The constructors and operators will be generated automatically
* Five special functions for class: above 4 and destructor
* None of them defined: all autogenerated
* Any of them defined: none autogenerated
* Try to define none of the special functions
* If you must define one of them define all
* Use `=default` to use default implementation

##### deleted functions
* Any function can be set as deleted: void SomeFunc(...) = delete;
* Calling such a function will result in compilation error
* Compiler marks some functions deleted automatically

#### Inheritance
* inherit data and functions from other classes
* 3 types of inheritance: but we will just use public
* public inheritance keeps all access specifiers of the base class
* Public inheritance stands for 'is a'
* allow derived to use all public and protected members of base
* derived still gets its own special functions: constructors, destructor, assignment operators

##### virtual  (to make class an interface or abstract class)
* A function can be declared virtual: virtual Func(<PARAMS>)
* If function is virtual in Base class it can be overridden in derived class: Func(<PARAMS>) override;
* Base can force all derived classes to overridr a function by making it pure virtual: virtual Func(<PARAMS>) = 0;

##### Overloading vs overriding
* Overloading: 重载,compile time
* Overriding: 重写，runtime

##### Abstract classes and interfaces
* Abstract class: class that has at least one pure virtual function
* Interface: class that has only pure virtual functions and no data members

##### How virtual works
* A class with virtual functions has a virtual table
* when calling a function the class checks which of the virtual functions that match the signature should be called
* called runtime polymorphism
* costs some time but is very convenient

### Lecture 5
#### Polymorphism
* Allows morphing derived classes into their base class type: const Base& base = Derived(...)
##### When to use it
* Working with all children of some base class in unified manner
* Enforcing an interface in multiple classes to force them to implement some functionality
* In strategy pattern, where some complex functionality is outsourced into separate classes and is passed to the object ina modular fashion 

##### Creating a class hierarchy
* Sometimes classes must form a hierarchy
* Distinguish between `is a` and `has a`
* Prefer shallow hierarchies
* Prefer composition, including an object of another class as a member of your class (一般更倾向于组合）

If the base class has a virtual function, it must be override.

##### Using interfaces
* when you must enforce other classes to implement some functionality
* allow thinking about classes in terms of abstract functionality
* hide implementation from the caller
* allow to easily extend functionality by simply adding a new class

##### Using strategy pattern
* If a class relies on complex external functionality use strategy pattern
* Allows to add/switch functionality of the class without changing its implementation
* All strategies must conform to one strategy interface

* Do not Overuse it
    * Only use these patterns when you need to 
    * If your class should have a single method for some functionality and will never need another implementation don't make it virtual
    * used mostly to avoid copying code and to make classes smaller by moving some functionality out


#### IO F stream
##### Reading and writing to files
* use stream from STL
* Syntax similar to cerr, cout
```c++
#include <fstream>
using std::string;
using Mode = std::ios_base::openmode;
// ifstream: input from file
std::ifstream f_in(string& file_name, Mode mode);
// ofstream: output from file
std::ofstream f_out(string& file_name, Mode mode);
// fstream: input and output from file
std::fstream f_in_out(string& file_name, Mode mode);
```
There is app, ate, binary, in, out, trunc mode, you can find from website.

* Use it when:
    * The file constains organized data
    * Every line has to have all columns
* Reading files one line at a time: getline(input, line)
    * Bind every line to a string
    * Afterwards parse the string
* wrting into text files
```c++
outfile << "just string" << endl;
outfile << setprecision(20) << a << endl;
```
##### String streams
* `stringstream`
* combine int, double, string, etc. into a single string
* Break up strings into int, double, string etc.

#### CMake find
* `find_path` and `find_library`
* We can use an external library
* Need headers and binary library files
```cmake
# Headers
find_path(SOME_PKG_INCLUDE_DIR include/some_file.h <path1> <path2> ...)
include_directories(${SOME_PKG_INCLUDE_DIR})

#Libraries
find_library(SOME_LIB NAMES <some_lib> PATHS <path1> <path2> ...)
target_link_libraries(target $(SOME_LIB})
```

##### find_package
* calls multiple find_path and find_library functions
* needs a file <Pkgname>\_pkg.cmake

### Lecture 6
#### Static variables and methods
* Static member variables of a class
    * Exist exactly *once* per *class*, not per object
    * The value is equal across all instances
    * Must be defined in \*.cpp files
* Static member functions of a class: 静态方法
    * Do not have an object of a class
    * Can access private menbers but need an object
    * Syntax for calling: ClassName::MethodName(<params>)
```c++
static float sqrt_func_name(const float a, const float b);
```

#### Representation of numbers in memory
* Alphanumerical: char/uint8_t (1 byte)
* Numerical: 
    * Floating point: 
        * Single precision float (4 bytes)
        * Double precision double (8 bytes)
    * Integers: int/int32_t (4 bytes)
* Use sizeof(<type>) to get size

#### Raw C arrays
* C style arrays
    * Base for std::array, std::vector, std::string
    * The length of the array is fixed固定
    * Indexing begins with 0
    * Elements of an array lie in continuous memory
* You should not use C style array
* Have no methods
* Do not explicitly store their size, but you can get from sizeof(<array>) = sizeof(<type>) * <array_length>

#### Non-owning pointers in C++
* Pointer
    * <TYPE>\* defines a pointer to type <TYPE>
    * Unitialized pointers point to a random address
    * Always intialize pointers to an address or a `nullptr`
* Non-owning pointers
    * Memory pointed to by a raw pointer is not removed when pointer goes out of scope
    * Pointers can either own memory or not
    * Owning memory means being reponsible for its cleanup
    * Raw pointers should never own memory
* Pointer dereferencing: 解引用
    * Oerator * returns the value of the variable to which the pointer points
    * Dereferencing of nullptr: segmentation fault
    * Dereferencing of unitialized pointer: undefined

Avoid segmentation fault: use `if` clause.

#### Classes in memory
* Usually Sequnentially
* The compiler can optimize memory

### Lecture 7
 
#### Using pointers
* You can use pointer to point classes

#### Pointers are polymorphic
* Pointers are just like references, but also:
    * can be reassigned
    * can point to "nothing"
    * can be stored in a vector or an array
* use pointers for polymorphism
> Derived derived;
> Base\* ptr = &derived;

#### Pointer `this`
* Every object of a class or a struct holds a pointer to itself
* This pointer is called `this`
* Allows the objects to:
    * Return a reference to themselves: `return *this;`
    * Create copies of themselves within a function
    * Explicitly show that a member belongs to the current object: `this->x();`

#### Using const with pointers
* const MyType\* const_var_ptr = &var; // point to a const
* MyType\* const var_const_ptr = &var; // a const pointer
* const MyType\* const const_var_const_ptr = &var; // a const pointer points to a const variable
* Read from right to left to see which const refers to what

#### Stack and Heap
Memory is divided into two parts: Stack and Heap

##### Stack
* Static memory
* Available for short term storage
* Small / limited(8MB Linux typisch)
* Memory allocation is fast
* LIFO: push for add, pop for remove

##### Heap
* Dynamic memory
* Available for long time (program runtime)
* Raw modifications possible with `new` and `delete` (usually encapsulated within a class)
* Allocation is slower than stack allocations

##### `new` and `new[]`
User controls memory allocation is unsafe
* use `new` to allocate data:
```c++
int* int_ptr = nullptr;
// return a pointer to memory in heap
int_ptr = new int;

float* float_ptr = nullptr;
// return a pointer to an array on heap
int number = 4;
float_ptr = new float[number];
```
* `new` returns an address of the variable on the heap
* **Prefer using smart poiners**
##### `delete` and `delete[]`
Memory is not freed automatically.
* delete int_ptr;
* delete[] float_array_ptr;

#### Memory leaks and dangling pointers
##### Memory leak
* can happen when working with Heap memory if we are not careful
* memory allocated on Heap access to which has been lost
* If we run out of memory an `std::bad_alloc` error is thrown
##### dangling pointer
* pointer to a freed memory: two pointer memory the same address, but one is be `delete`
* Dereferencing a dangling pointer causes undefined behavior

Memory leak if nobody has freed the memory. Dangling pointer if somebody has freed the memory in a function.

#### RAII: one of good things in C++11
* Resource Allocation Is Initialization
* New object => allocate memory
* Remove object => free memory
* Objects own their data

##### copy
* Shallow copy: just copy pointers, not data
* Deep copy: copy data, create new pointers
* Default copy constructor and assignment operator implement shallow copying
* RAII + shallow copy => dangling pointer
* RAII + Rule of 'All or Nothing' => correct

#### Smart pointers
* Smart pointers wrap a raw pointer into a class and manage its lifetime(RAII)
* Smart pointers are all about ownership
* Always use smart pointers when the pointer should own heap memory
* **Only use them with heap memory**
* Still use raw pointers for non-owning pointers and simple address storing
* `#include <memory>` to use smart pointers
* `std::unique_ptr`
* `std::shared_ptr`

* can be set to `nullptr`
* use `*ptr` to dereference `ptr`
* use `ptr->` to access methods
* Smart pointers are polymorphic
* `ptr.get()` returns a raw pointer that the smart pointer manages
* `ptr.reset(raw_ptr)` stops using currently managed pointer, freeing its memory if needed, sets `ptr` to `raw_ptr`


### Lecture 8
#### Smart pointers
* Smart pointers wrap a raw pointer into a class and manage its lifetime(RAII)
* Smart pointers are all about ownership
* Always use smart pointers when the pointer should own heap memory
* **Only use them with heap memory**
* Still use raw pointers for non-owning pointers and simple address storing
* `#include <memory>` to use smart pointers
* `std::unique_ptr`
* `std::shared_ptr`

* can be set to `nullptr`
* use `*ptr` to dereference `ptr`
* use `ptr->` to access methods
* Smart pointers are polymorphic
* `ptr.get()` returns a raw pointer that the smart pointer manages
* `ptr.reset(raw_ptr)` stops using currently managed pointer, freeing its memory if needed, sets `ptr` to `raw_ptr`

##### `std::unique_ptr`
* Constructor of a unique pointer takes ownership of a provided raw pointer
* No runtime overhead over a raw pointer
```c++
#include <memory>
// default constructor
auto p = std::unique_ptr<Type>(new Type);
// not default constructor
auto p = std::unique_ptr<Type>(new Type(<params>);

// c++14, this is recommended
auto p = std::make_unique<Type>(<params>);
```
* UNIQUE
    * has no copy construcor
    * cannot be copied, can be moved: change onwership
    * guarantees that memory is always owned by a *single* unique pointer
```c++
// a_ptr is unique
// b points to what a pointed, a does not point it any more
auto b_ptr = std::move(a_ptr);
```

##### `std::shared_ptr`
* Constructed just like a `unique_ptr`
* Can be copied
* Stores a usage counter and a raw pointer
    * Increases usage counter when copied
    * Decreases usage counter when destructed
* Frees memory when counter reaches 0
* Can be initialized from a `unique_ptr`
```c++
#include <memory>
auto p = std::shared_ptr<Type>(new Type);
auto p = std::make_shared<Type>();
auto p = std::shared_ptr<Type>(new Type<params>);
auto p = std::make_shared<Type>(<params>);
```

```c++
// a_ptr is shared_ptr, and a_ptr.use_count() return how many times it is used
a_ptr>use_count();
```

##### when to use
* By default use `unique_ptr`
* If multiple objects must share ownership over something, use a `shared_ptr` to it
* Using smart pointers allows to avoid having destructors in your own classes
* Think of `new` or `delete`:
    * Do not use `delete`
    * Allocate memory with `make_unique`, `make_shared`
    * Only use `new` in smart pointer constructor if cannot use the functions above

#### Associative containers

##### `std::map`
* `#include <map>`
* Stores items under unique keys
* Implemented usually as a red-black tree
* Key can be any type with operator< defined
* Create from data:
```c++
std::map<KeyT, ValueT> m = {
{key, value}, {key, value}};
```
* Add item to map: m.emplace(key, value);
* Modify or add item: m[key] = value;
* Get(const) ref to an item: m.at(key);
* Check if key present: m.count(key) > 0;
* Check size: m.size();

##### `std::unordered_map`
* `#include <unordered_map>
* Implemented as a hash table
* Key type has to be hashable
* Typically used with `int`, `string` as key
* Exactly same interface as `std::map`

```c++
// iterating
// stored element is a pair
for (const auto& kv : m) {
    const auto& key = kv.first;
    const auto& value = kv.second;
    // other code
}

#### Type casting
Used to like c, but after c++11 to make everything safe

##### `static_cast`
* `static_cast<NewType>(variable)`
* Convert type of a variable at compile time
* Rarely needed to be used explicitly
* Can happen implicitly for some types, like float to int
* Pointer to an object of a Derived class can be upcast to a pointer of a Base class
* Enum value can be caster to int or float

##### `reinterpret_cast` 重新解释
* `reinterpret_cast<NewType>(variable)
* Reinterpret the bytes of a variable as another type
* Mostly used when writing binary data

##### dynamic_cast
* `dynamic_cast<Base*>(derived_ptr)`
* used to convert a pointer to a variable of Derived type to a pointer of a Base type
* Conversion happens at runtime
* If derived_ptr cannot be converted to Base* returns a nullptr
* Avoid using dynamic casting

#### Enumeration classes
* Store an enumeration of options
* Usually derived from int type
* Options are assigned consequent numbers
* Mostly used to pick path in `switch`
* Use values as:
    EnumType::OPTION_1, EnumType::OPTION_2, ...
* name CamelCase
* Name values as constants kSomeConstant or in ALL_CAPS, 对象使用 k骆驼命名法 或者 全大写命名法

```c++
enum class Channel {STDOUT, STDERR};
```

* by default enum values start from 0
* Usually used with default values, but you can also specify custom values if needed

#### Read/write binary files

##### Write
* write a sequence of bytes
* know structur of the contents
* fast
* No precision loss for floating point types
* Substantially smaller than ascii-files
* Syntax: file.write(reinterpret_cast<char*>(&a), sizeof(a));

##### Read
* read a sequence of bytes
* know structur of the contents
* Syntax: file.read(reinterpret_cast<char*>(&a), sizeof(a));


### Lecture 9

#### Generic programming
**Separate algorithms from the data type**

##### `template` functions
```c++
template <typename T, typename S>
T awesome_function(const T& var_t, const S& var_s) {
    // some code
    T result = var_t;
    return result;
}
```
* `T` and `S` can be any type that is:
    * copy constructable
    * assignable
    * is defined (for custom classes)
* if the data type is not clear:
```c++
template <typename T> 
T DummyFunction{
    T result;
    return result;
}
// make it clear ourselves
DummyFunction<int>();
```

##### `template` classes
* use template type anywhere in class
```c++
template <class T>
class MyClass {
    public:
      MyClass(const T& smth) : smth_(smth) {}
    private:
      T smth_;
};
MyClass<int> my_object(10);
MyClass<double> my_double_object(10);
```

##### Template specialisation
```c++
template <typename T>
T DummyFuncion() {
    T result;
    return result;
}
template <>
int DummyFunction() {
    return 1;
}
```

##### template meta programming (模板元编程)
* templates are used for Meta programming
* The compiler will generate concrete instances of generic classes based on the classes we want to use

##### template classes headers/source
* Concrete template classes are generated instantiated at compile time
* Linker does not know about implementation
* There are three options for template classes:
    * Declare and define in header files
    * Declare in NAME.h file, implement in NAME.hpp file, add #include <NAME.hpp> in the end of NAME.h
    * Declare in \*.h file, implement in \*.cpp file, in the end of the \*.cpp add explicit instantiation for types you expect to use

#### Iterators
STL uses iterators to access data in containers.

* Iterators are similar to pointers
* Allow quick navigation through containers
* Most algorithms in STL use iterators
* Access current element with `*iter`
* Accepts `->` alike to pointers
* Move to next element in container `iter++`
* Prefer range-based for loops
* Compare iterators with `==`, `!=`, `<`
* Pre-defined iterators: `obj.begin()`, `obj.end()`

```c++
vector<double> x = {{1,2,3}};
for (auto it = x.begin(); it != x.end(); ++it) {
    cout << *it << endl;
}
map<int, string> m = {{1, "hello"}, {2, "world"}};
map<int, string>::iterator m_it = m.find(1);
cout << m_it->first << ":" << m_it->second << endl;
if (m.find(3) == m.end()) {
    cout << "Key 3 was not found\n";
}
```

#### Error handling
* We can "throw" an exception if there is an error
* STL defines classes that represent exceptions. Base class: `exception`
* `#include <stdexcept>`
* An exception can be "caught" at any point of the program (`try` `catch`) and even `throw`
* The constructor of an exception receives a string error message as a parameter
* This string can be called through a member function `what()`
* use try-catch to catch different exceptions

```c++
#include <stdexcept>
// runtime error
if (badEvent) {
    string msg = "specific error string";
    // throw error
    throw runtime_error(msg);
}

// logic error
throw logic_error(msg);


runtime_error &ex;
ex.what();
```

* Only used for "exceptional behavior"
* Often misused: e.g. wrong parameter should not lead to an exception
* **Don't use exceptions**

#### Program input parameters
* Originate from the declaration of main function
* Allow passing arguments to the binary
* `int main(int argc, char const *argv[]);`   
* `argc` defines number of input parameters
* `argv` is an array of string parameters
* By default:
    * argc == 1
    * argv == "<binary_path>"
#### Using for type aliasing
* use word `using` to declare new types from existing and create type aliases
* `using NewType = OldType;`
* `using` is a versatile word
* can be used inside of the scope

#### OpenCV
Popular library for Image Processing.

## Concurrency

### Data Race and how do we fix it

##### What is concurrency
* Concurrency means doing two things concurrently - "Running together"
* Parallelism means doing two things in parallel - simultaneously

* parallism: hardware problem, such as multiple CPUs
* concurrency: software problem, such as time-sharing

* C++: From C++11, there is `<thread>`
* Advantage: compiler and hardware can change your code more effectively
* memory model: 
    * Now a program consists of one or more threads of execution
    * Every write to a single memory location must synchronize-with all other
      reads or writes of that memory location, or else the program has undefined
      behavior
    * Synchronized-with relationships can be established by using various
      standard library facilities, such as `std::mutex` and `std::atomi<T>`
```c++
std::thread treadB = std::thread([](){
    puts("Hello from threadB!");
})
puts("Hello from threadA");
threadB.join();
```





