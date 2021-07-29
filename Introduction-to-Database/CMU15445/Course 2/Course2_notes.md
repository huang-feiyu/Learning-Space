# CMU-154-45: 

## Before this course:

* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapters 3-5</a>

### Papers: (none)

### Chapter03
##### SQL concepts
* DDL: 定义关系模式、删除关系以及修改关系模式的命令
* DML: 查询信息，插入、删除、修改元组
* integrity: 完整i选哪个约束
* view definition
* transaction control
* embedded SQL and dynamic SQL: 嵌入到编程语言中去
* authorization

##### SQL data definition
Use DDL

##### Basic type
* char
* varchar
* int
* smallint
* numeric
* real
* double precision
* float

##### Basic schema
```sql
## 创建关系示例
create table department (
    dept_name varchar(20),
    building varchar(15),
    budget numeric(12, 2),
    primary key (dept_name)
);
```
* primary key: 非空并且唯一
* foreign key: 声明关系中任意元组在属性上的取值必须对应于s某元组在主码属性上的取值
* not null: 该属性不可为空

##### SQL Queries' structure
<a href=./Material/MySQL.md>more in this one</a>
* upper(string), lower(string), trim(string): 大写、小写、去除字符串后面的空白
* escape在使用like查询时定义转义字符
* similar to: 类似于正则表达式查询
* union, intersect, except: 并(union all)，交(intersect all保留所有重复)，差(expect all)
* with: 定义临时关系
* join ... using: 哪些需要

##### Modify Database
* delete: 删除元组
* insert into: 插入元组
* update: 更新元组信息
* case: 
  
  >case 
            when pred<sub>1</sub> then result<sub>1</sub>
            when pred<sub>2</sub> then result<sub>2</sub>
            ...
            else result<sub>0</sub>
  end
* set: 赋值

### Chapter04
##### Join Expression
* 连接条件：on条件
> select student.ID as ID, name, dept_name, tot_cred
> from student join on student.ID = takes.ID;

* outer join: 创建包含空值元组的方式，保留了那些在连接中丢失的元组
`left outer join` `right outer join` `full outer join`
* inner join: 常规连接

##### View 视图
**出于安全考虑，制造一个虚关系对于用户可见**

* definition: `create view v as <query expression>;`
* materialized view: 物化视图，能够保证每一次查询到的数据为最新的数据(view maintenance)
* update view: `update` `insert` `delete`
  * need to satisfy 
       * `from子句只有一个数据库关系` 
       * `select语句中只有关系的属性名` 
       * `查询中不能包含 group by和having`

##### transaction 事务
确保原子性
* commit work
* rollback work

##### 完整性约束
`alter table table_name add constraint` // 添加完整性约束，一般默认有
* not null
* unique
* check (<>)
* referential integrity 子集依赖：与外键有关
* assertion: `create assertion <assertion-name> check <predicate>`

##### SQL的数据类型和模式
* date: 'yyyy-mm-dd'
* time: 'hh:mm:ss'
* timestamp
* default: 创建表时指定
* index: 高效的寻找关系中那些索引属性上取得定值的元组
* blob: 大对象(Binary Large OBject)
* distinct type: 用户定义的独特类型
    * `create type Dollars as numberic (12, 2) final;`
    * drop, alter 可以修改以前创建过的类型
* create table的扩展: `create table temp_instructor like instructor;`
  
* 最顶层有目录(catalog)也就是database构成,每个目录都包含模式(schema)

##### 授权
* 权限的授予与收回：
    * `grant <权力列表> on <关系名/视图名> to <用户/角色列表>`
    * update, insert, delete 为权力
    * `revoke <权力列表> on <关系名/视图名> to <用户/角色列表>`
* 角色:
    * `create role instructor;`
    * 角色可以授予用户，也可以授予其他角色
* 视图的授权：
* 模式的授权：
* 权限转移：
    * grant select on department to Amit `with grant option`;

### Chapter05(没有读懂)
##### SQL with Program Language
* JDBC: 定义了Java的数据库访问API
* ODBC: Open DataBase Connectivity
```c++
void ODBCexample() 
{
    RETCODE error;
    HENV env; // 环境参数变量
    HDBC conn; // 数据库连接
    
    SQLAllocEnv(&env);
    SQLAllocConnect(env, &conn);
    SQLConnect(conn, "db.yale.edu", SQL_NTS, "avi". SQL_NTS,
               "avipasswd", SQL_NTS);
    {
        char deptname[80];
        float salary;
        int lenOut1, lenOut2;
        HSTMT stmt;
        
        char * sqlquery "select dept_name, sum(salary) from instructor group by dept_name";
        SQLAllocStrmt(conn, &stmt);
        error = SQLExecDirect(stmt, sqlquery, SQL_NTS);
        if (error == SQL_SUCCESS) {
            SQLBindCol(stmt, 1, SQL_C_CHAR, deptname, 80, &lenOut1);
            SQLBindCol(stmt, 2, SQL_C_FLOAT, &salary, 0, &lenOut2);
            while (SQLFetch(stmt) == SQL_SUCCESS) {
                printf("%s%g\n", deptname, salary);
            }
            SQLFreeStmt(stmt, SQL_DROP);  
        }
    } 
    SQLDisconnect(conn);
    SQLFreeConnect(conn);
    SQLFreeEnv(env);
}
```
* 嵌入式SQL: 在其他编程语言中使用的SQL

##### 函数和过程 (没有读懂)
* 声明和调用SQL函数和过程
```sql
create function dept_count(dept_name varchar(20))
    returns integer
    begin
    declare d_count integer;
        select count(*) into d_count
        from instructor
        where instructor.dept_name = dept_name
    return d_count;
    end

declare d_count integer;
call dept_count_proc('Physics', d_count);
```

##### 触发器Trigger(TODO)
- 在特定条件下z对用户发出警告或者自动开始执行某项任务
- `referencing new row as`: 建立过渡变量
- `for each row`: 显式的迭代
- `begin atomic ... end`: 多行SQL集成为一个符合语句
- `create trigger ... `

##### 递归查询(TODO)
```sql
with recursive rec_prereq(course_id, prereq_id) as (
    select course_id, prereq_id
    from prereq 
)
select * from rec_prereq;
```

##### 高级聚集特性(TODO)
* 排名：`select ID, rank() over(order by (GPA) desc) as s_rank from student_grades order by s_rank;`
* 分窗

##### OLAP(TODO)

## [In the Course:](https://www.youtube.com/watch?v=6VCHuLqfmV8&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=2&ab_channel=CMUDatabaseGroup)
### History

* SEQUEL => SQL

**Why do we use SQL? To follow the giant IBM-DB2.**

* There is standard: 92 > 99 > 03 > 08 > 11 > 16 (But no one follow it)

* SQL of DB depends on DB itself.
* SQL: based on bags algebra (no position and un-ordered, there could be duplicates)
* Relational Algebra: based on lists (position but un-ordered, there could be duplicates)

### Aggregations + Group By
##### Aggregations(聚集函数)
* AVG
* MIN
* MAX
* SUM
* COUNT
> To use it `COUNT(the tuple you want to count)`
* `*` refers to ALL
* COUNT, SUM, AVG support DISTINCT `COUNT(DISTINCT login)`

##### GROUP BY
Project tuples into subsets and calculate aggregates against each subset.
* HAVING is like a WHERE clause for a GROUP BY

### String/Date/Time Operations
##### String Operations
* only MySQL is insensitive with String Case. 大小写不敏感
* LIKE: '%' => any substrings;   '_' => one character
* String Functions:
    * SUBSTRING(name, 0, 5)
    * UPPER(e.name) 
    * LOWER() 
    * CONCAT(a.name, b.name) (MySQL)
    * SQL-92: a.name || b.name
    
##### DATE/TIME OPERATIONS
Operations to manipulate and modify DATE/TIME attributes.
* get current time:
  * SELECT NOW(); (SQL-92, MySQL)
  * SELECT CURRENT_TIMESTAMP(); (MySQL)
  * SELECT CURRENT_TIMESTAMP; (sqLite)
* EXTRACT (SQL-92, MySQL)   
* DATE (SQL-92)
* julianday (sqLite)

**SqLite is very good, it is everywhere.**

### Output Control + Redirection
* Store query results in another table: 
  > Table must not already be fined; Table will have the same # of columns with the same types as the input.
  > `SELECT DISTINCT cid INTO CourseIds FROM enrolled;` (SQL-92)
  > `INSERT INTO CourseIds (SELECT DISTINCT cid FROM enrolled);`
* ORDER BY <column*> [ASC|DESC]: Order the Output by the values in one or more of their columns.
* LIMIT: Limit the # of tuples returned in output; Can set an offset to return a "range"

### Nested Queries(嵌套查询)
Queries containing other queries. They are often difficult to optimize.
```sql
SELECT name FROM student
    WHERE sid IN (
        SELECT sid FROM enrolled
        WHERE cid = '15-445'
      )

SELECT name FROM student
WHERE sid ANY(
  SELECT sid FROM enrolled
  WHERE cid = '15-445'
) 

SELECT (SELECT S.name FROM student AS S 
    WHERE S.sid = E.sid) AS sname
    FROM enrolled AS E
    WHERE cid = '15-445'
```
* IN
* ALL
* ANY
* EXISTS

### Common Table Expressions
Provides a way to write auxiliary statements for use in a larger query.
> Think of it like a temp table just for one query.
* WITH ... AS
* RECURSION:
  > WITH RECURSIVE cteSource(counter) AS (
  > (SELECT 1)
  > UNION ALL
  > (SELECT counter + 1 FROM cteSource
  > WHERE counter < 10)
  >) 
  > SELECT * FROM cteSource;

### Window Function
Performs a calculation across a set of tuples that related to a single row.
> SELECT ... FUNC-NAME(...) OVER (...)
>   FROM tableName

* ROW_NUMBER(): # of the current row 
* RANK(): The # of a sort order
* OVER: specifies how to group together tuples when computing the window function.
* PARTITION BY: To specify group

### Conclusion
SQL is not a dead language.

You should always strive to compute your answer as a single SQL statement.

## Exercise

### <a href=https://15445.courses.cs.cmu.edu/fall2020/homework1/>15445</a>

<a href=../exercise/homework1/placeholder>Solutions</a>

<a href=../exercise/homework1/submission.zip>Solutions.zip</a>

![Relation](https://15445.courses.cs.cmu.edu/fall2020/files/schema2020.png)

### Q1 [0 POINTS] (Q1_SAMPLE):

The purpose of this query is to make sure that the formatting of your output matches exactly the formatting of our auto-grading script.

**Details:** List all types of work ordered by type ascendingly.

**Answer**: Here's the correct SQL query and expected output:

```
sqlite> select name from work_type order by name;
    Answer:
    Aria
    Audio drama
    Ballet
    Beijing opera
    Cantata
    Concerto
    Incidental music
    Madrigal
    Mass
    Motet
    Musical
    Opera
    Operetta
    Oratorio
    Overture
    Partita
    Play
    Poem
    Prose
    Quartet
    Sonata
    Song
    Song-cycle
    Soundtrack
    Suite
    Symphonic poem
    Symphony
    Zarzuela
    Etude
    
```



You should put this SQL query into the appropriate file (`q1_sample.sql`) in the submission directory (`placeholder`).

### Q2 [5 POINTS] (Q2_LONG_NAME):

List works with longest name of each type.

**Details:** For each work type, find works that have the longest names. There might be cases where there is a tie for the longest names - in that case, return all of them. Display work names and corresponding type names, and order it according to work type (ascending) and use work name (ascending) as tie-breaker.

### Q3 [5 POINTS] (Q3_OLD_MUSIC_NATIONS):

List top 10 countries with the most classical music artists (born or started before 1850) along with the number of associated artists.

**Details:** Print country and number of associated arists before 1850. For example, `Russia|191`. Sort by number of artists in descending order.

### Q4 [10 POINTS] (Q4_DUBBED_SMASH):

List the top 10 dubbed artist names with the number of dubs.

**Details:** Count the number of distinct names in `artist_alias` for each artist in the `artist` table, and list only the top ten who's from the United Kingdom and started after 1950 (not included). Print the artist name in the `artist` table and the number of corresponding distinct dubbed artist names in the `artist_alias` table.

### Q5 [10 POINTS] (Q5_VINYL_LOVER):

List the distinct names of releases issued in vinyl format by the British band Coldplay.

**Details:** Vinyl format includes ALL vinyl dimensions excluding `VinylDisc`. Sort the release names by release date ascendingly.

### Q6 [10 POINTS] (Q6_OLD_IS_NOT_GOLD):

Which decades saw the most number of official releases? List the number of official releases in every decade since 1900. Like `1970s|57210`.

**Details:** Print all decades and the number of official releases. Releases with different issue dates or countries are considered different releases. Print the relevant decade in a fancier format by constructing a string that looks like this: `1970s`. Sort the decades in decreasing order with respect to the number of official releases and use decade (descending) as tie-breaker. Remember to exclude releases whose dates are `NULL`.

### Q7 [15 POINTS] (Q7_RELEASE_PERCENTAGE):

List the month and the percentage of all releases issued in the corresponding month all over the world in the past year. Display like `2020.01|5.95`.

**Details:** The percentage of releases for a month is the number of releases issued in that month devided by the total releases in the past year from 07/2019 to 07/2020, both included. Releases with different issue dates or countries are considered different releases. Round the percentage to two decimal places using `ROUND()`. Sort by dates in ascending order.

### Q8 [15 POINTS] (Q8_COLLABORATE_ARTIST):

List the number of artists who have collaborated with Ariana Grande.

**Details:** Print only the total number of artists. An artist is considered a collaborator if they appear in the same artist_credit with Ariana Grande. The answer should include Ariana Grande herself.

### Q9 [15 POINTS] (Q9_DRE_AND_EMINEM):

List the rank, artist names, along with the number of collaborative releases of Dr. Dre and Eminem among other most productive duos (as long as they appear in the same release) both started after 1960 (not included). Display like `[rank]|Dr. Dre|Eminem|[# of releases]`.

**Details:** For example, if you see a release by A, B, and C, it will contribute to three pairs of duos: `A|B|1`, `A|C|1`, and `B|C|1`. You will first need to calculate a rank of these duos by number of collaborated releases (release with artist_credit shared by both artists) sorted descendingly, and then find the rank of `Dr. Dre` and `Eminem`. Only releases in English are considered. Both artists should be solo artists. All pairs of names should have the alphabetically smaller one first. Use artist names (asc) as tie breaker.

**Hint:** Artist aliases may be used everywhere. When doing aggregation, using artist ids will ensure you get the correct results. One example entry in the rank list is `9|Benj Pasek|Justin Paul|27`

### Q10 [15 POINTS] (Q10_AROUND_THE_WORLD):

Concat all dubbed names of The Beatles using comma-separated values(like "`Beetles, fab four`").

**Details:** Find all dubbed names of artist "`The Beatles`" in artist_alias and order them by id (ascending). Print a single string containing all the dubbed names separated by commas.

**Hint:** You might find [CTEs](https://sqlite.org/lang_with.html) useful.


