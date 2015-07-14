# 假设我们使用的是 MySQL 数据库，在连接数据库之前，请确保：

#     您已经创建了一个数据库 TESTDB。
#     您已经在 TESTDB 中创建了表 EMPLOYEE。
#     该表带有字段 FIRST_NAME、LAST_NAME、AGE、SEX 和 INCOME。
# INSERT 操作

# 当您想要在数据库表中创建记录时，需要用到 INSERT 操作。

# 一旦建立了数据库连接，我们就可以准备使用 do 方法或 prepare 和 execute 方法创建表或创建插入数据表中的记录。
# 使用 do 语句

# 不返回行的语句可通过调用 do 数据库处理方法。该方法带有一个语句字符串参数，并返回该语句所影响的行数。

require "dbi"

begin 
    dbh = DBI.connect("DBI:Mysql:testdb:localhost","root","rootroot")
    #row = dbh.select_one("select version()")
    #puts "Server version: "+row[0]

    dbh.do("create table user(
                                                    name char(16) not null,
                                                    age int ,
                                                    phone char(11)
                                                    )");

    dbh.do("insert into employee(first_name,last_name,age,sex,income) values
                                                        ('Mac','Mohan',20,'M',2000)")
    puts "Record has been created"
    dbh.commit

rescue DBI::DatabaseError=>e 
    puts "An error occurred"
    puts "Error code: #{e.err}"
    puts "Error message: #{e.errstr}"
ensure
    dbh.disconnect if dbh
end