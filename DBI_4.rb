# Update 操作
# 对任何数据库的 UPDATE 操作是指更新数据库中一个或多个已有的记录。下面的实例更新 SEX 为 'M' 的所有记录。在这里，我们将把所有男性的 AGE 增加一岁。这将分为三步：
#     基于所需的条件准备 SQL 查询。这将通过使用 prepare 方法来完成。
#     执行 SQL 查询，从数据库中选择所有的结果。这将通过使用 execute 方法来完成。
#     释放语句句柄。这将通过使用 finish 方法来完成。
#     如果一切进展顺利，则 commit 该操作，否则您可以 rollback 完成交易。

require 'dbi'
    begin
        dbh = DBI.connect("DBI:Mysql:testdb:localhost","root","rootroot")
        sth = dbh.prepare("update employee set age=age+1 where sex=? ")
        sth.execute('M')
        sth.finish
        dbh.commit
    rescue DBI::DatabaseError => e 
        puts "An error occurred "
        puts "error code: #{e.err}"
        puts "Error message: #{e.errstr}"
    ensure
        dbh.disconnect if dbh
    end
