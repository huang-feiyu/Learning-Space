### SQLite(二进制储存在本地电脑中)

##### datatype:

BLOB:Binary

INTETGER:integer, smallint,  bigint

NUMERIC

![image-20201029151620093](F:\Pictures\img_typora\image-20201029151620093.png)

REAL:精确储存数据

TEXT:char, varchar(选择的字节数), text(利用指针储存数据)

##### 关键字：

INSERT SELECT UPDATE DELETE CREATE

### PostgreSQL

# MySQL必知必会

```
mysql -uroot -p
```

### SQL

##### 数据库基础

###### 数据库（DATABASE）

保存有组织的数据的容器，通常是一个文件或者一组文件

###### 表（TABLE）

某种特定类型数据的结构化清单

表名：唯一性

模式（schema）：关于数据库和表的布局及特性的信息

###### 列和数据类型

表由列（column）组成，列是每一个数据类型

![image-20201028122840712](F:\Pictures\img_typora\image-20201028122840712.png)

![image-20201028122945434](F:\Pictures\img_typora\image-20201028122945434.png)

###### 行（ROW）

每一行代表一个对象

###### 主键(primary key)

唯一性类似于ID

![image-20201028123132200](F:\Pictures\img_typora\image-20201028123132200.png)

主键用来表示一个特定的行

![image-20201028123309869](F:\Pictures\img_typora\image-20201028123309869.png)

##### SQL

一种结构化查询语言，专门用来与数据库通信

![image-20201028123414351](F:\Pictures\img_typora\image-20201028123414351.png)

### MySQL

##### MySQL

MySQL是一种数据库软件（DBMS）

###### 客户机-服务器软件

![image-20201028123744108](F:\Pictures\img_typora\image-20201028123744108.png)

###### MySQL工具

1.mysql命令行实用程序

2.mysql administrator

![image-20201028141916066](F:\Pictures\img_typora\image-20201028141916066.png)

3.mysql query browser

​	![image-20201028164903094](F:\Pictures\img_typora\image-20201028164903094.png)

### 使用MySQL

##### 连接

##### 选择数据库

##### 了解数据库

显示所有的数据库,返回可用数据库的列表

```mysql
SHOW DATABASES;
SHOW TABLES;//显示表
SHOW COLUMNS FROM TABLENAME;//每个字段返回一行
```

![image-20201029145527693](F:\Pictures\img_typora\image-20201029145527693.png)

### 检索数据

![image-20201030131621986](F:\Pictures\img_typora\image-20201030131621986.png)
