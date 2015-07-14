# READ 操作
# 对任何数据库的 READ 操作是指从数据库中获取有用的信息。
# 一旦建立了数据库连接，我们就可以准备查询数据库。我们可以使用 do 方法或 prepare 和 execute 方法从数据库表中获取值。
# 获取记录的步骤如下：
#     基于所需的条件准备 SQL 查询。这将通过使用 prepare 方法来完成。
#     执行 SQL 查询，从数据库中选择所有的结果。这将通过使用 execute 方法来完成。
#     逐一获取结果，并输出这些结果。这将通过使用 fetch 方法来完成。
#     释放语句句柄。这将通过使用 finish 方法来完成。
require "dbi"
    begin 
        dbh = DBI.connect("DBI:Mysql:testdb:localhost","root","rootroot")
        sth = dbh.prepare("select * from employee where income>? ")
        sth.execute(1000)
        sth.fetch do |row|
            printf "First Name: %s, LastName: %s\n",row[0],row[1]
            printf "Age: %d, Sex: %s\n",row[2],row[3]
            printf "Salary: %d\n\n",row[4]
        end
        sth.finish
    rescue DBI::DatabaseError => e
        puts "An error occurred"
        puts "Error code: #{e.err}"
        puts "Error message: #{e.errstr}"
    ensure
        dbh.disconnect if dbh
    end
