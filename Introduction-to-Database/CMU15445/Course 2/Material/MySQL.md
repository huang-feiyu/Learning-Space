# MySQL

### 企业规范约束(更详细的见大一立项的需求分析)

##### 1.库表字段约束规范

1.数据类型如果需要表示是非，一定给上is

```规范约束
  名			  类型		  长度
is_vip    unsigned tinyint    1
```

2.字段名一定是小写字母，不能出现大写，若出现单词，使用下划线隔开

3.表名一定不能出现复数

4.不能使用关键字

5.主键索引名一定   pk_xxx

​    唯一键    uk_xxx      

​     其他       idx_xxx

6.凡是小数全部使用decimal数据类型

7.若字符串较短，就使用char类型

8.表里面必须有三个字段

| id              | create_time | update_time |
| --------------- | ----------- | ----------- |
| 主键            |             |             |
| bigint unsigned | datetime    | datetime    |

9.仓库名与应用名保持一致

10.允许适当冗余

11.单表容量太大(大于2G)要分库

##### 2.索引规范

1.需要唯一索引

2.关联查询一般不能够产生

##### 3.SQL开发约束

1.不要使用count(xxx,xx,xx) 代替 count(*)

前者无法统计null的值

2.不要使用where  name=null;

​        可以使用where  name is null;

​		ISNULL();函数判断是否为空

3.不要使用外键和级联

4.实际开发过程中不允许使用存储过程

5.先查再修改

6.in的操作能够避免就避免

7.utf8作为国际编码

##### 4.其他约束

### 0.数据库规范

##### 1.确保每列原子性

保证每一列不能再分

##### 2.非键字段必须依赖于键字段

##### 3.消除传递依赖

### 1.什么是数据库

将大量数据储存起来，数据仓库保存海量数据的仓库

### 2.数据库的诞生

scanner类放在内存中是瞬时状态的。

为了数据的持久性储存，但是还是有MongDB、NoSQL之类的缓存数据库。

最早的数据库的数据保存在文件中，然后加密。

配置文件一般保存在txt文件中。

### 3.CRUD

1.新增数据

2.删除数据

3.修改数据

4.查找数据

=》CRUD 就是增删改查

### 4.数据库模型

层次模型：![IMG20201101101444](D:\图片\img_typora\IMG20201101101444.jpg)crud很费解，因为可能存在多个相同的数据，数据的不完整性。

##### 网状结构：

可以表示很多复杂的关系，保证了数据的完整性，但是网状数据模型的结构复杂，使用不易，数据间关联较大，没有解决导航问题

##### 关系模型：

第二代数据库，主键作为唯一标识号,即ID。

通过共有的数据简化数据，完成数据的清晰使用。

1.各自之间存在关系，各管各的，互不影响

2.能够找到共有的字段id

### 5.数据库的选择

选择最基本的、通用的，学习SQL语句。

各种数据库之间是有联系的。

### 6.终端

终端是客户端，mysql是典型的c/s架构软件

### 7.连接命令详解

```sql
//   user  管理员   password
mysql -u   root    -p
```

退出

```
mysql> exit;

mysql> \q;

mysql> quit;
```

### 8.创建data folder

bin: 存放二进制文件

docs: 文档

include: 存放头文件

lib：依赖

share：存放字符编码

```cmd
C:\Program Files\MySQL\MySQL Server 5.7
该目录中没有data文件夹，进入有空格使用“”

使用我们的terminal，用管理员方法进入，进入上述文件路径
PS: C:\Program Files\MySQL\MySQL Server 5.7>mysqld --initialize-insecure --user=root

发现在上述目录下出现了data文件夹
```

### 9.数据库显示

```mysql
SHOW DATABASES;
// 会出现下面的所有仓库
```

基本的数据库

```mysql
+-----------------------+
|Database               |
+-----------------------+
|information_shcema     |仓库信息
|mysql                  |系统信息
|performance_shcema     |性能信息
|sys                    |系统文件之一
+-----------------------+
```

### 10.创建数据库

```mysql
//                    数据库名称
mysql> CREATE DATABASE student;

// 两个`强制使用关键字作为数据库名称
mysql> CREATE DATABASE `` DATABASE;

// 可去掉反引号
mysql> create database if not exists `student`; 
```

### 11.删除数据库

```mysql
mysql> drop database student;

// 可去掉反引号
mysql> drop database if exists `student`;
```

### 12.查看创建的库

```mysql
mysql>show create database student;

// 会出现一些信息
```

![image-20201101185423374](D:\图片\img_typora\image-20201101185423374.png)

### 13.字符编码

(中文GBK 国际UTF-8)



```mysql
// 创建时给定字符编码，Windows最好gbk
// 一般是utf8
create database if not exists `students` charset=utf8;

// 更新alter，修改字符编码
alter database student charset=gbk;

# 字符集与校对
create table mytable
(
	columnn1 int,
    columnn2 varchar(10) character set latin1 collate latin_general_ci,
    columnn3 varchar(10)
) default character set hebrew
  collate hebrew_general_ci;
```

### 14.表table

数据库中储存着表，表中储存着数据

### 15.引用数据库，查看其中的表

```mysql
mysql> use shool;
//下面是输出
Database changed
mysql> show tables;
```

### 16.创建表

```mysql
mysql> use student;
Database changed
mysql> create table student(
    -> id int,
    -> name varchar(30),
    -> age int
    -> );
mysql> show tables;
// 显示表
```

![image-20201101192036195](D:\图片\img_typora\image-20201101192036195.png)

### 17.主键的添加

auto_increment 自动增长

primary key 主键（唯一的）

comment 注释，描述这个属性（id、name、age 字段、列）

not null 不能为空

default 默认值,不填的话默认为空null

engine=innodb;之后可以看看

```mysql
mysql> create table if not exists teacher(
    -> id int auto_increment primary key comment 'id'，
    -> name varchar(30) not null comment'名字'，
    -> phone varchar(20) comment '电话号码',
    -> address varchar(100) default '未知' comment '住址'
    -> )engine=innodb;
```

### 18.查看表的结构

```mysql
// 显示表的sql语句
mysql> show create table student;
```

![image-20201101210426421](D:\图片\img_typora\image-20201101210426421.png)

```mysql
//     descend降序 
mysql> desc teacher;
```

![image-20201101210540513](D:\图片\img_typora\image-20201101210540513.png)

### 19.删除表

```mysql
mysql> drop table stu, oooo;

mysql> drop table if exists s;
```

![image-20201101210955295](D:\图片\img_typora\image-20201101210955295.png)

### 20.修改表

```mysql
mysql> create table ttt(
    -> id int(4)
    -> );
    
mysql> alter table ttt add aaa int(9);
```

![image-20201101211417178](D:\图片\img_typora\image-20201101211417178.png)

```mysql
//                                         放在name之后
mysql> alter table student add gender varchar(1) after name;
```

```mysql
// 放在第一个
mysql> alter table student add address varchar(100) first;

mysql> desc student;

//                 删除address
mysql> alter table student drop address;

mysql> desc student;
```

![image-20201101212115202](D:\图片\img_typora\image-20201101212115202.png)

```mysql
// 修改字段的类型与名称
mysql> alter table student change phone tel_phone int(11);

// modify只能修改类型
mysql> alter table student modify tel_phone varchar(13);
```

### 21.插入数据

```mysql
// 插入数据
mysql> insert into teacher (id, name, phone, address) values(1, 'Huang', '15972822422', 'Shenzhen')
```

```mysql
// 选择数据
//           所有
mysql> select * from teacher;
```

![image-20201102183042575](D:\图片\img_typora\image-20201102183042575.png)

```mysql
//                         如果不写这个就必须按照默认的来写
mysql> insert into teacher (phone, address, id, name) values('2121212121', 'China', 1221212, 'zhangsan');
```

```mysql
// 插入多条数据
mysql> insert into teacher values(NULL,'sksk',NULL,default),(NULL,'dsd',NULL,default);
```

```mysql
# 插入检索出来的数据，对应列的位置
INSERT INTO customers(cust_id,
cust_contact,
cust_emai1,
cust_name,
cust_address,
cust_city,
cust_state,
cust_zip,
cust_country)
SELECT cust_id，
cust_contact,
cust_emai1,
cust_name,
cust_address,
cust_city,
cust_state,
cust_zip,
cust_country
FROM custnew;
```



### 22.删除数据

```mysql
mysql> delete from teacher where id=121212;
```

一般where之后是主键，或者说是唯一的属性

```mysql
mysql> delete from student where age>30;
```

### 23.清空表

```mysql
//   这个比较缓慢，是利用类似循环的东西
mysql> delete from teacher;
// （清空）报废这个表
mysql> truncate table student;
```

之前的数据用delete删除时，还是有缓存（之前的自增）。

使用truncate销毁表，则不会有缓存。

### 24.更新表

```mysql
//多个用逗号连接，后面的where也可以使用and，or等逻辑运算符
mysql> update teacher set name='frank' where id=1;
#重命名
mysql> rename table t_1 to t_2;
```

### 25.查询表(基本方法)

```mysql
mysql> select id,name from teacher;
```

### 26.SQL语句区分

**数据定义语言：**

**DDL：data definition language**

create   alter  drop   show

**数据库操纵语言：**

**DML：data manipulation**

insert   update   delete   select  

**数据库控制语言：**

**DCL：data control language**

### 27.字符集编码问题

```mysql
mysql> show variables like 'character_set_%';
mysql> set character_set_%=gbk;
```

### 28.数据库的数据类型

使用十分适合的数据类型

### 29.int数值类型

TINYINT				-128~127

SMALLINT			-32768~32767

MEDIUMINT		-800万~+800万

INT / INTEGER	-21亿~21亿 

BIGINT    			大整型

UNSIGNED 		无符号整型（没有负数）

```mysql
mysql> create table emp(
	-> id smallint unsigned auto_increment primary key comment 'id',
	-> age tinyint unsigned,
	-> kkk int(6)
	-> );
```

### 30.浮点型

// 会丢失精度

FLOAT

DOUBLE 

```mysql
// （总数位，小数位位数）
mysql> create table abc(
	-> number_1 float(3,1),
	-> number_2 double(5,2)
	-> );
```

### 31.定点数 真值

DECIMAL 依赖于m,d的值

占用资源较多

```mysql
mysql> create table t_3(
	-> money decimal(20,19)
	-> );
```

### 32.字符串与文本类型

CHAR()		    		定长字符串

VARCHAR()     		变长字符串（回收多于空间，效率较char低）

TINYBOLOB   		二进制字符串

TINYTEXT 			   短文本字符串

TEXT  					   长文本类型

MEDIUMBLOB

MEDIUMTEXT

LONGBLOB

LONGTEXT

### 33.布尔类型

BOOLEAN

### 34.枚举类型enum

```mysql
mysql> create tabel t(
	-> gender enum('man', 'woman', '?')
	-> );
```

只能存储预先定义的东西,占用类型较小

```mysql
mysql> insert into t_5 values(1);
     //  ================>即man
```

### 35.set类型 集合类型

```mysql
mysql> create table t(
	-> hobby set('哲学'，'经济学', '文学'， 'IT')
    -> );
    
    // 多选
mysql> insert into t values('IT,经济学');
```

### 36.时间日期类型

DATE    YYYY-MM-DD

DATE    YYYY-MM-DD  YY-MIN-SS

```mysql
mysql> create table t(
	-> MyTime datetime
	-> );
```

### 37.列属性问题

not null 不能为空， default默认，               额外的auto_increment一定是主键primary, 主键primary key

### 38.主键primary key

标记唯一，是唯一的特性，保证数据完整性

查数据十分方便

可以通过主键关联多个表

```mysql
mysql> create tabel test(
    -> id int(30) primary key,
    -> name varchar(30)
    -> );
```

### 39.删除主键

```mysql
mysql> table ttt drop primary key;
```

### 40.复合键、组合键（多个字段组成一个主键）

```mysql
mysql> alter table ttt add primary key (id, name);
```

一般只会使用一个主键

扩容性不是很好

### 41.唯一键(防止数据重复)

```mysql 
mysql> create table ttt(
    ->id int primary key,
    -> phone varchar(20) unique
    -> );
// 添加唯一键
mysql> alter table ttt add unique(phone);
// 删除唯一键
mysql> alter table ttt drop index phone;
```

### 42.sql注释

```mysql
mysql> create table ttt(
    -> id int(20) # this is primary key!
    -> /*
   /*> zhishi
   /*> sajdjaskd
   /*> */ 
    -> );
```

```mysql
#句内注释
mysql> create table tabel ttt(
    -> phone int(222) comment 'phone'
    -> );
```

### 43.数据库的完整性

1.一般都有一个主键

2.保证实体的完整性

3.数据类型正确

4.default默认问题

### 44.表之间的交互

主表与从表，公共字段。

数据库关联之后就会出现许多麻烦。

### 45.外键

```mysql
mysql> create table stu(
    -> stuID int(4) primary key,
    -> name varchar(20)
    -> );
#创建食堂订单
mysql> create table order_1(
    -> id int primary key,
    -> money decimal(10,4),
    -> stuID int(4),
    -> foreign key (stuID) references stu(stuID) #外键取自之前的stu table
    -> );
#添加外键
mysql> alter table order_2 add foreign key (stuID) references stu(stuID);
```

并发项目一般不使用外键。

### 46.设计表的结构

在开发前一般将一切设计完成。

### 47.更新错误

```mysql
mysql> show create table ttt;
# 看下面的表名
mysql> alter table order_1 drop foreign key eatery_ibfk_1;
```

desc 无法查看外键

### 48.外键的操作

```mysql 
#置空操作：若主表删除一个主键元素，从表将已存在的东西改为null  
#cascade 级联
mysql> create table order_3(
    -> id int(20) primary key,
    -> money decimal(10,4),
    -> stuID int(4),
    -> foreign key(stuID) references stu(stuID) on delete set null on update cascade
    -> );
#级联操作：将所有有关的东西全部删除，所以一般用于更新,主表更新会使从表跟着更新
```

### 49.数据库设计

关系型数据库：通过两张表的共有字段去确定数据的完整性

行：就是一条数据,一条记录，实体

列：字段，属性

**数据库中还是需要数据冗余，为了提高性能**

**实体之间的关系：**

一对多，多对一

### 50.select

```mysql
# 没有数据
mysql> select '什么鬼'；
+------------+
|   什么鬼    |
+------------+
|   什么鬼    |
+------------+
mysql> select 2*5;
+------------+
|     10     |
+------------+
|     10     |
+------------+
#                      取别名
mysql> select 'Go fuck' as qnmd;
+---------+
| qnmd    |
+---------+
| Go fuck |
+---------+
```

### 51.from 从表中选取

```mysql
mysql> select * from t_1;
mysql> select * from t1, t2;
# 返回一个笛卡尔积
```

### 52.dual

```mysql
mysql>select 2*7 as res from dual;
# dual是伪表 与下面的等价
mysql> select 2*7 as res;
```

### 53.where条件筛选

```mysql
mysql> select * from teacher where  sth=33 or sth=43 and age<18 or adress='Shanghai' and not a!=2;
```

### 54.in 也可以使用not in

```mysql
mysql> select * from t4 where address in('beijing','shanghai');
```

### 55.between … and

```mysql
mysql> select * from t3 where age between 15 and 20;
```

### 56.is null是否为空 

或者is not null

```mysql
mysql> select * from t3 where age is null;
```

### 57.聚合函数

sum()  avg()  count()    min()   max()

```mysql
mysql> select avg(chinese) from score;
```

count(*)   count(1)  的优缺点

统计数量

### 58.like模糊查询

```mysql
mysql> select * from student where name like '张%';
# %一个或多个字符
mysql> select * from student where name like '张_';
```

### 59.order by 排序查询

```mysql
mysql> select * from score order by chinese asc;
# asc升序，desc降序
```

### 60.group by 分组查询

```mysql
mysql> select avg(age) as '年龄',gender as '性别' from ttt group by gender;
```

### 61.group_concat 聚合显示

```mysql
mysql> select group_concat(name),gender from ttt group by gender;
```

### 62.having再次筛选

```mysql
#在我们查询之后的表中再次查询
mysql> select avg(age) as '年龄', address as '地区' from ttt group by address having 年龄>24;
#一般不使用中文
```

### 63.limit限制

```MySQL
mysql>select * from ttt limit 1,3;
#限定起始的位置，之后的是长度
#从零开始
```

### 64.distinct去重

```mysql
mysql> count(distinct address) from ttt;
```

### 65.union联合查询

前后的字段数相同

```mysql
mysql> select age,gender from ttt union select name, phone from teacher;
```

### 66.inner join内连接

查询多个表

做一个连接，on公共字段，建立一个公共字段

```mysql
mysql> select name,score from student inner join score on student.id=score.stuid;
```

### 67.left join左连接

以左表为基准

```mysql
mysql> select name,score from student left join score on student.id=score.stuid;
```

### 68.right join 右连接

```mysql
mysql> select name,score from student left join score on student.id=score.stuid;
```

### 69.cross join 交叉连接

返回一个笛卡尔积

```mysql
mysql> select * from t1 cross join t3;
```

### 70.natural join 自然连接

```mysql
mysql> select * from t1 natural join t3;
# 通过同名字段相连接，也可自然左右连接
# 本质上是内连接
# 如果没有公共字段，则返回笛卡尔积
```

### 71.using 

```mysql
mysql> select * from t1 inner join t3 using(id);
# 若有多个共同字段，通过using
```

### 72.子查询语句 嵌套查询

```mysql
mysql> select * from student where id=(select stuid from score where score>=85);
# 若只有一行
```

```mysql
mysql> select * from student where id in(select stuid from score where score>=85);
# 有多行
```

还有not in

### 73.exits 和 not exits

```mysql
mysql> select * from student where not exits(select stuid from score where score>=85);
```

### 74.view视图

查看表，有意的隐藏表，降低了sql的复杂度。

```mysql
# 创建view视图
mysql> create view vm_stu as select name,phone from student;

mysql> create view vm_stu_all as select name,phone,score from student inner join score on student.id=score.stuid;

# 查看如何创建视图
mysql> show create view viewname;

# 终端上显示视图
mysql> show tables;
# =>视图会与表放在一起

# 修改视图
mysql> alter view vm_stu as select name from student;

# 删除视图
mysql> drop view vm_stu;

# 合并merge，临时表temptable 视图算法
mysql> create algorithm=temptable view vm_stu as select name,phone from student;
```

![image-20201202214940735](D:\图片\img_typora\image-20201202214940735.png)

### 75.事务Transaction

要么一起执行，要么一起回滚

```MySQL
# 开始事物
mysql> start transaction;

mysql> update wallet set balance=balance-50 where id=1;

mysql> update wallet set balance=balance+50 where id=2;

# 提交
mysql> commit;
```

```mysql
mysql> start transaction;
mysql> update wallet set balance=balance-50;
# 回滚
mysql> rollback;
```

```mysql
# 设置回滚点
mysql> start transaction;
mysql> insert into wallet values(4,1000);
mysql> savepoint four;

mysql> insert into wallet values(2,3333);
mysql> savepoint five;

mysql> rollback to four;
```

##### ACID

事务的四个特性

1.原子性 atomicity

2.一致性 consistency

3.隔离性 isolation

4.持久性 durability

事务只有在引擎是innodb时候才可以使用

### 76.索引index

用于查询，但是cru效率会变低

index 主键、唯一键、全文索引、普通索引

```mysql
mysql> create index balance_index on wallet(balance);

mysql> drop index balance_index on wallet;

mysql> create unique index balance_index on t2(bingming);

mysql> alter table balance add index balance_index(id);
```

### 77.存储过程  procedure

模块化设计，类似于函数

```mysql
# 改变MySQL的结尾
mysql> delimiter //
# 用完之后
mysql> delimiter ;

# 创建存储过程，可以有很多个语句,一般嵌套transaction
mysql> delimiter //
mysql> create procedure proc()
	-> begin
	-> update wallet set balance=balance+50;
	-> update t3 set name='tom';
	-> end //

mysql> delimiter ;
mysql> call proc();

mysql> drop procedure proc;
```

![image-20201202215234163](D:\图片\img_typora\image-20201202215234163.png)

![image-20201202215331982](D:\图片\img_typora\image-20201202215331982.png)

![image-20201202215533240](D:\图片\img_typora\image-20201202215533240.png)

### 78.函数Number

```mysql
# 随机数
mysql> select rand();
# 抽奖
mysql> select * from student order by rand() limit 3;
# 向上取整
mysql> select ceil(3.1);
=> 4
# 向下取整 高斯函数
mysql> select floor(3.1);
=> 3
# 四舍五入
mysql> select round(3.1);
=> 3
# 截取
mysql> select truncate(3.2323,2);
=> 3.23
# 随机排序
mysql> select * from student order by rand();
```

### 79.函数String

```MySQL
# 转大写
mysql> select ucase('fuck!');
=> FUCK!
# 转小写
mysql> select lcase('FUCK!');
=> fuck!
# 截取
mysql> select left('FUCK!',2);
=> FU
mysql> select right('FUCK!',2);
=> K!
mysql> select substring('FUCK',2,3);
=> UCK
mysql> select concat('FUCK','sk');
=> FUCKsk
```

### 80.函数其他

```MySQL
# 现在的时间
mysql> select now();
# unix时间戳
mysql> select unix_timestamp();

mysql> select year(now()) year, month(now()) month,day(now()) day;

#加密函数
mysql> select sha("sksk");
=> 加密后的东西

# 还有很多其他操作
```

### 81.多表查询实战

<a href="https://www.cnblogs.com/zjx304/p/9936142.html">多表查询题目</a>

1.![image-20201115092559872](D:\图片\img_typora\image-20201115092559872.png)

![image-20201115092633829](D:\图片\img_typora\image-20201115092633829.png)

2.![image-20201115093133930](D:\图片\img_typora\image-20201115093133930.png)

![image-20201115093148709](D:\图片\img_typora\image-20201115093148709.png)

3.<img src="D:\图片\img_typora\image-20201115093900034.png" alt="image-20201115093900034" style="zoom: 33%;" />

![image-20201115093913721](D:\图片\img_typora\image-20201115093913721.png)

![image-20201115093920050](D:\图片\img_typora\image-20201115093920050.png)

4.![image-20201115094357890](D:\图片\img_typora\image-20201115094357890.png)

![image-20201115094420277](D:\图片\img_typora\image-20201115094420277.png)

![image-20201115094430220](D:\图片\img_typora\image-20201115094430220.png)

5.![image-20201115094642558](D:\图片\img_typora\image-20201115094642558.png)

![image-20201115094651521](D:\图片\img_typora\image-20201115094651521.png)

![image-20201115094659721](D:\图片\img_typora\image-20201115094659721.png)

6.![image-20201115095025261](D:\图片\img_typora\image-20201115095025261.png)

![image-20201115095036539](D:\图片\img_typora\image-20201115095036539.png)

7.<img src="D:\图片\img_typora\image-20201115095301185.png" alt="image-20201115095301185" style="zoom: 50%;" />

![image-20201115095508542](D:\图片\img_typora\image-20201115095508542.png)

8.<img src="D:\图片\img_typora\image-20201115095708681.png" alt="image-20201115095708681" style="zoom: 80%;" />

109选修了3-105

![image-20201115095855593](D:\图片\img_typora\image-20201115095855593.png)

109没有选修3-105

![image-20201115100159942](D:\图片\img_typora\image-20201115100159942.png)

9.![image-20201115100223641](D:\图片\img_typora\image-20201115100223641.png)

![image-20201115100352996](D:\图片\img_typora\image-20201115100352996.png)

10.![image-20201115100556862](D:\图片\img_typora\image-20201115100556862.png)

![image-20201115100606941](D:\图片\img_typora\image-20201115100606941.png)

11.![image-20201115100900629](D:\图片\img_typora\image-20201115100900629.png)

![image-20201115100908704](D:\图片\img_typora\image-20201115100908704.png)

12.![image-20201115101259743](D:\图片\img_typora\image-20201115101259743.png)

![image-20201115101321372](D:\图片\img_typora\image-20201115101321372.png)

![image-20201115101445458](D:\图片\img_typora\image-20201115101445458.png)

13.![image-20201115101717706](D:\图片\img_typora\image-20201115101717706.png)

![image-20201115101724680](D:\图片\img_typora\image-20201115101724680.png)

14.![image-20201115102033916](D:\图片\img_typora\image-20201115102033916.png)

![image-20201115102041433](D:\图片\img_typora\image-20201115102041433.png)

15.all的应用![image-20201115102347974](D:\图片\img_typora\image-20201115102347974.png)

![image-20201115102404203](D:\图片\img_typora\image-20201115102404203.png)

16. ##### any的应用![image-20201115102424498](D:\图片\img_typora\image-20201115102424498.png)

![image-20201115102538078](D:\图片\img_typora\image-20201115102538078.png)

17.union的应用

##### ![image-20201115102629594](D:\图片\img_typora\image-20201115102629594.png)

![image-20201115102938490](D:\图片\img_typora\image-20201115102938490.png)

18.临时表的使用

![image-20201115103320215](D:\图片\img_typora\image-20201115103320215.png)

![image-20201115103330807](D:\图片\img_typora\image-20201115103330807.png)

19.![image-20201115103649647](D:\图片\img_typora\image-20201115103649647.png)

![image-20201115103645503](D:\图片\img_typora\image-20201115103645503.png)

20.![image-20201115103826569](D:\图片\img_typora\image-20201115103826569.png)

![image-20201115103900421](D:\图片\img_typora\image-20201115103900421.png)

21.![image-20201115104828154](D:\图片\img_typora\image-20201115104828154.png)

![image-20201115104819114](D:\图片\img_typora\image-20201115104819114.png)

![image-20201115104918112](D:\图片\img_typora\image-20201115104918112.png)

22.![image-20201115105453731](D:\图片\img_typora\image-20201115105453731.png)

![image-20201115105449555](D:\图片\img_typora\image-20201115105449555.png)

23.![image-20201115135519511](D:\图片\img_typora\image-20201115135519511.png)

![image-20201115135531114](D:\图片\img_typora\image-20201115135531114.png)

### 82.FULLTEXT

![image-20201202212743093](D:\图片\img_typora\image-20201202212743093.png)

![image-20201202212919982](D:\图片\img_typora\image-20201202212919982.png)

查询扩展（注释也算在其中）

![image-20201202213116677](D:\图片\img_typora\image-20201202213116677.png)

布尔文本搜索

![image-20201202213213799](D:\图片\img_typora\image-20201202213213799.png)

### 83.engine类型

InnoDB:事务处理引擎，不支持全文本

MyISAM：性能高，不能够处理事务，支持全文本

MEMORY:数据储存在内存上，迅速，类似于MyISAM

### 84.使用游标

```mysql
-- 游标是被select语句检索出来的结果集
# 创建游标
create procedure processorders()
begin
	declare ordernumbers CURSOR
	for
	select order_num from orders;
end;

# 打开游标
open ordernumbers;

# 关闭游标
close ordernumbers;

# 使用游标数据
# fentch语句
```

### 85.触发器

```mysql
# 创建从触发器
create trigger newproduct after insert on products 
for each row select 'Product added';

# 删除触发器
drop trigger newproduct;

# 使用insert触发器
create trigger neworder after insert on orders
for each row select NEW.order_num;
# 测试触发器
insert into orders(order_date, cust_id)
values( Now(), 10001);

# delete触发器
create trigger deleteorder()  before delete on orders
for each row
begin 
	insert into archive_orders(order_num, order_date, cust_id)
	values(OLD.order_num, OLD.order_date, OLD.cust_id);
end;

# update触发器
create trigger updatevendor before update on vendors
for each row set NEW.ven_state = Upper(NEW.vend_state);
```

### 86.管理用户

```mysql
# 创建用户账号
create user ben identified by '1w$%jdcojp';

# 重命名用户账号
rename user ben to bforta;

# 删除用户账号
drop user bforta;

# 查看访问权限
show grants for bforta;

# 设置权限（只读crashcourse）
grant select on crashcourse.* to bforta;

# 撤销权限
revoke select on crashcourse.* from bforta;

# 修改密码(传递密码到password函数加密)
set password for bforta = Password('sksk2k2h3hk4&&*');

# 修改自己的密码
set password = Password('jsk&hh%jj');
```

### 87.数据库维护

可以翻阅书籍

![image-20201202222657218](D:\图片\img_typora\image-20201202222657218.png)

![image-20201202222711485](D:\图片\img_typora\image-20201202222711485.png)

![image-20201202222721636](D:\图片\img_typora\image-20201202222721636.png)

![image-20201202222730298](D:\图片\img_typora\image-20201202222730298.png)

### 88.DML与DDL与DCL

DDL:数据定义语言

create  alter  drop

to database table view index

DML:数据操纵语言

insert  update  delete  select

DCL:数据控制语言

grant   revoke

