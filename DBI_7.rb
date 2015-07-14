# 特定驱动程序的函数和属性
# DBI 让数据库驱动程序提供了额外的特定数据库的函数，这些函数可被用户通过任何 Handle 对象的 func 方法进行调用。
# 使用 []= or [] 方法可以设置或获取特定驱动程序的属性。
# DBD::Mysql 实现了下列特定驱动程序的函数：
require "dbi"
begin
    dbh = DBI.connect("DBI:Mysql:testdb:localhost","root","rootroot")
    puts dbh.func(:client_info)
    puts dbh.func(:client_version)
    puts dbh.func(:host_info)
    puts dbh.func(:proto_info)
    puts dbh.func(:thread_id)
    puts dbh.func(:stat)
    puts dbh.func(:insert_id)
rescue DBI::DatabaseError => e
    puts "An error occurred"
    puts "Error code:    #{e.err}"
    puts "Error message: #{e.errstr}"
ensure
    dbh.disconnect if dbh
end