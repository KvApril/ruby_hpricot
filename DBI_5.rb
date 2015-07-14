# DELETE 操作
# 当您想要从数据库中删除记录时，需要用到 DELETE 操作。下面的实例从 EMPLOYEE 中删除 AGE 超过 20 的所有记录。该操作的步骤如下：
#     基于所需的条件准备 SQL 查询。这将通过使用 prepare 方法来完成。
#     执行 SQL 查询，从数据库中删除所需的记录。这将通过使用 execute 方法来完成。
#     释放语句句柄。这将通过使用 finish 方法来完成。
#     如果一切进展顺利，则 commit 该操作，否则您可以 rollback 完成交易。
require 'dbi'
    begin 
        dbh = DBI.connect("DBI:Mysql:testdb:localhost","root","rootroot")
        sth = dbh.prepare("delete from employee where age>?")
        sth1 = dbh.prepare("select * from employee")
        sth.execute(22) 
        #删除数据库字段之后再进行显示输出
        sth1.execute
        sth1.fetch do |row|
            printf "First Name: %s, LastName: %s\n",row[0],row[1]
            printf "Age: %d, Sex: %s\n",row[2],row[3]
            printf "Salary: %d\n\n",row[4]
        end
        sth.finish
        dbh.commit
    rescue DBI::DatabaseError => e
        puts "An error occurred"
        puts "Error code:    #{e.err}"
        puts "Error message: #{e.errstr}"
        dbh.rollback
    ensure
        dbh.disconnect if dbh
    end