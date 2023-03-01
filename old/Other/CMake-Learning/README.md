# CMake

> 1. 命令不区分大小写
> 2. 注释符号为 `#`

[CMake-tutorial](https://github.com/chaneyzorn/CMake-tutorial)

[CMake 入门实战](https://www.hahack.com/codes/cmake/)

简易流程：

1. 编写 CMake 配置文件 CMakeLists.txt 。
2. 执行命令 `ccmake PATH` 或者 `cmake PATH` **生成 Makefile**（`ccmake` 和 `cmake` 的区别在于前者提供了一个交互式的界面）。其中， `PATH` 是 CMakeLists.txt 所在的目录。
3. 使用 `make` 命令进行编译。

[TOC]

## 单个源文件

CMakeLists.txt 与源文件 `main.cc` 处于同一目录下：

```cmake
cmake_minimum_required (VERSION 2.6)

# 项目信息
project (Demo1)

# 指定生成目标
add_executable(Demo main.cc)
```


## 多个源文件

Directory Tree:

```tree
./Demo2
    |
    +--- main.cc
    |
    +--- MathFunctions.cc
    |
    +--- MathFunctions.h
```

CMakeLists.txt 编写如下：

```cmake
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)

# 项目信息
project (Demo2)

# 查找当前目录下的所有源文件，并将名称保存到 DIR_SRCS 变量
# DIR_SRCS variable
aux_source_directory(. DIR_SRCS)

# 指定生成目标
add_executable(Demo ${DIR_SRCS})
```

## 多个目录，多个源文件

Directory Tree:

```tree
./Demo3
    |
    +--- main.cc
    |
    +--- math/
          |
          +--- MathFunctions.cc
          |
          +--- MathFunctions.h
```

需要编写两个 CMakeLists.txt，分别位于根目录与 `math` 下：

1. 根目录

```cmake
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)

# 项目信息
project (Demo3)

# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)

# 添加 math 子目录
add_subdirectory(math)

# 指定生成目标 
add_executable(Demo main.cc)

# 添加链接库
target_link_libraries(Demo MathFunctions)
```

2. `math`

```cmake
# 查找当前目录下的所有源文件，并将名称保存到 DIR_LIB_SRCS 变量
aux_source_directory(. DIR_LIB_SRCS)

# 生成链接库——静态链接库
add_library (MathFunctions ${DIR_LIB_SRCS})
```

### 自定义编译选项

将 `MathFunctions` 设为一个可选的库：

```cmake
# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)

# 项目信息
project (Demo4)

# 加入一个配置头文件，用于处理 CMake 对源码的设置
configure_file (
  "${PROJECT_SOURCE_DIR}/config.h.in"
  "${PROJECT_BINARY_DIR}/config.h"
  )

# 是否使用自己的 MathFunctions 库
option (USE_MYMATH
       "Use provided math implementation" ON)

# 是否加入 MathFunctions 库
if (USE_MYMATH)
  include_directories ("${PROJECT_SOURCE_DIR}/math")
  add_subdirectory (math)  
  set (EXTRA_LIBS ${EXTRA_LIBS} MathFunctions)
endif (USE_MYMATH)

# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)

# 指定生成目标
add_executable(Demo ${DIR_SRCS})
target_link_libraries (Demo  ${EXTRA_LIBS})
```

同时在源文件中添加：

```c
#ifdef USE_MYMATH
  #include "math/MathFunctions.h"
#else
  #include <math.h>
#endif
```

编写 config.h.in 文件，CMake 读取该文件后会生成 config.h 文件：

```in
#cmakedefine USE_MYMATH
```

---

`ccmake` 命令能够提供一个会话式交互配置界面。

## 安装和测试

`make install` 与 `make test`，在 CMake 中需要简单地调用几条命令：

### 定制安装规则

首先先在 math/CMakeLists.txt 文件里添加下面两行：

```cmake
# 指定 MathFunctions 库的安装路径
install (TARGETS MathFunctions DESTINATION bin)
install (FILES MathFunctions.h DESTINATION include)
```

指明 MathFunctions 库的安装路径。之后同样修改根目录的 CMakeLists 文件，在末尾添加下面几行：

```cmake
# 指定安装路径
install (TARGETS Demo DESTINATION bin)
install (FILES "${PROJECT_BINARY_DIR}/config.h"
         DESTINATION include)
```

通过上面的定制，生成的 Demo 文件和 MathFunctions 函数库 libMathFunctions.o 文件将会被复制到 `/usr/local/bin` 中，而 MathFunctions.h 和生成的 config.h 文件则会被复制到 `/usr/local/include` 中。

### 为工程添加测试

CMake 提供了 CTest 测试工具，我们只需要调用 `add_test` 命令即可：

```cmake
# 启用测试
enable_testing()

# 测试程序是否成功运行
add_test (test_run Demo 5 2)

# 测试帮助信息是否可以正常提示
add_test (test_usage Demo)
set_tests_properties (test_usage
  PROPERTIES PASS_REGULAR_EXPRESSION "Usage: .* base exponent")

# 测试 5 的平方
add_test (test_5_2 Demo 5 2)

set_tests_properties (test_5_2
 PROPERTIES PASS_REGULAR_EXPRESSION "is 25")

# 测试 10 的 5 次方
add_test (test_10_5 Demo 10 5)

set_tests_properties (test_10_5
 PROPERTIES PASS_REGULAR_EXPRESSION "is 100000")

# 测试 2 的 10 次方
add_test (test_2_10 Demo 2 10)

set_tests_properties (test_2_10
 PROPERTIES PASS_REGULAR_EXPRESSION "is 1024")
```

使用宏简化：

```cmake
# 定义一个宏，用来简化测试工作
macro (do_test arg1 arg2 result)
  add_test (test_${arg1}_${arg2} Demo ${arg1} ${arg2})
  set_tests_properties (test_${arg1}_${arg2}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endmacro (do_test)
 
# 使用该宏进行一系列的数据测试
do_test (5 2 "is 25")
do_test (10 5 "is 100000")
do_test (2 10 "is 1024")
```

### 添加 GDB

```cmake
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")
```

## 添加环境检查

判断函数是否存在

1. 添加 CheckFunctionExists 宏

首先在顶层 CMakeLists 文件中添加 CheckFunctionExists.cmake 宏，并调用 `check_function_exists` 命令测试链接器是否能够在链接阶段找到 `pow` 函数。

```cmake
# 检查系统是否支持 pow 函数
include (${CMAKE_ROOT}/Modules/CheckFunctionExists.cmake)
check_function_exists (pow HAVE_POW)
# above `configure_file` command
```

2. 预定义宏变量

config.h.in 文件：

```in
// does the platform provide pow function?
#cmakedefine HAVE_POW
```

3. 在代码中使用宏和函数

```c
#ifdef HAVE_POW
    printf("Now we use the standard library. \n");
    double result = pow(base, exponent);
#else
    printf("Now we use our own Math library. \n");
    double result = power(base, exponent);
```

## 添加版本号信息

```cmake
# 版本号 1.0
set (Demo_VERSION_MAJOR 1)
set (Demo_VERSION_MINOR 0)
```

修改 config.h.in，添加两个预定义变量：

```in
// the configured options and settings for Tutorial
#define Demo_VERSION_MAJOR @Demo_VERSION_MAJOR@
#define Demo_VERSION_MINOR @Demo_VERSION_MINOR@
```

## 生成安装包

CMake 提供打包工具 CPack：

```cmake
# 构建一个 CPack 安装包
include (InstallRequiredSystemLibraries)
set (CPACK_RESOURCE_FILE_LICENSE
  "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set (CPACK_PACKAGE_VERSION_MAJOR "${Demo_VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR "${Demo_VERSION_MINOR}")
include (CPack)
```

生成包：

```bash
# 生成二进制包
cpack -C CPackConfig.cmake

# 生成源码安装包
cpack -C CPackSourceConfig.cmake
```

## 示例

```cmake
cmake_minimum_required(VERSION 2.6)
project(CMake_tutorial)
set(CMAKE_CXX_STANDARD 11)

# 设置有关版本号的两个变量，版本号 1.0
# 这两个变量将会在后面的操作中被插入到源代码中
set(Tutorial_VERSION_MAJOR 1)
set(Tutorial_VERSION_MINOR 0)

# 提供一个选项：是否使用提供的数学函数？
option(USE_MYMATH "Use tutorial provided math implementation" ON)
include(CMakeDependentOption)
# 提供一个依赖选项，当上一项开启时提供本项，默认开启：是否检查系统提供了 log 和 exp 函数？
CMAKE_DEPENDENT_OPTION(Check_Function "Check whether this system provide the log and exp functions"
        ON "USE_MYMATH" OFF)
# 检查并设置相关变量
if (Check_Function)
    include(CheckFunctionExists)
    check_function_exists(log HAVE_LOG)
    check_function_exists(exp HAVE_EXP)
endif (Check_Function)

# 以 TutorialConfig.h.in 为模版
# 以上设置的变量将会影响此处的处理
# 替换相关变量并输出到 TutorialConfig.h
configure_file(
        "${PROJECT_SOURCE_DIR}/TutorialConfig.h.in"
        "${PROJECT_BINARY_DIR}/TutorialConfig.h"
)
# 将构建目录添加到 include 的搜索路径中以便找到 TutorialConfig.h 文件
include_directories("${PROJECT_BINARY_DIR}")

if (USE_MYMATH)
    include_directories("${PROJECT_SOURCE_DIR}/MathFunctions")
    add_subdirectory(MathFunctions)
    set(EXTRA_LIBS ${EXTRA_LIBS} MathFunctions)
endif (USE_MYMATH)

set(SOURCE_FILES tutorial.cpp)
add_executable(CMake_tutorial ${SOURCE_FILES})
target_link_libraries(CMake_tutorial ${EXTRA_LIBS})

# 开启测试
# include(CTest)
enable_testing()

# 程序是否能够运行？
add_test(TutorialRuns CMake_tutorial 25)

# 使用信息是否正常？
add_test(TutorialUsage CMake_tutorial)
set_tests_properties(TutorialUsage
        PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number")

# 定义一个宏以简化测试的添加
# 使用 PASS_REGULAR_EXPRESSION 测试属性来验证测试的输出是否包含某些字符串
macro(do_test arg result)
    add_test(TutorialComp${arg} CMake_tutorial ${arg})
    set_tests_properties(TutorialComp${arg}
            PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endmacro(do_test)

# 一系列基础测试
do_test(4 "4 is 2")
do_test(9 "9 is 3")
do_test(5 "5 is 2.236")
do_test(7 "7 is 2.645")
do_test(25 "25 is 5")
do_test(-25 "-25 is 0")
do_test(0.0001 "0.0001 is 0.01")

# build a CPack driven installer package
include (InstallRequiredSystemLibraries)
set (CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
set (CPACK_PACKAGE_VERSION_MAJOR "${Tutorial_VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR "${Tutorial_VERSION_MINOR}")
include (CPack)
```

