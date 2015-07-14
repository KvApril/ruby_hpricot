#您可以使用 DBI 的 prepare 和 execute 方法来执行 Ruby 代码中的 SQL 语句。

# 创建记录的步骤如下：

#     准备带有 INSERT 语句的 SQL 语句。这将通过使用 prepare 方法来完成。
#     执行 SQL 查询，从数据库中选择所有的结果。这将通过使用 execute 方法来完成。
#     释放语句句柄。这将通过使用 finish API 来完成。
#     如果一切进展顺利，则 commit 该操作，否则您可以 rollback 完成交易。


require "dbi"

begin
    dbh = DBI.connect("DBI:Mysql:testdb:localhost","root","rootroot")
    sth = dbh.prepare( "insert into employee(first_name,last_name,age,sex,income) values(?,?,?,?,?)" )
    sth.execute('John','Poul',25,'M',2300)
    sth.execute('Zara','Ali',17,'F',1000)
    sth.finish
    dbh.commit
    puts "record has been created"

rescue DBI::DatabaseError => e
    puts "An error occurred"
    puts "Error code: #{e.err }"
    puts "Error message: #{e.errstr}"
    dbh.rollback
ensure
    dbh.disconnect if dbh
end