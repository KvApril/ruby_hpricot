# 执行事务
# 事务是一种确保交易一致性的机制。事务应具有下列四种属性：
#     原子性（Atomicity）：事务的原子性指的是，事务中包含的程序作为数据库的逻辑工作单位，它所做的对数据修改操作要么全部执行，要么完全不执行。
#     一致性（Consistency）：事务的一致性指的是在一个事务执行之前和执行之后数据库都必须处于一致性状态。假如数据库的状态满足所有的完整性约束，就说该数据库是一致的。
#     隔离性（Isolation）：事务的隔离性指并发的事务是相互隔离的，即一个事务内部的操作及正在操作的数据必须封锁起来，不被其它企图进行修改的事务看到。
#     持久性（Durability）：事务的持久性意味着当系统或介质发生故障时，确保已提交事务的更新不能丢失。即一旦一个事务提交，它对数据库中数据的改变应该是永久性的，耐得住任何数据库系统故障。持久性通过数据库备份和恢复来保证。
# DBI 提供了两种执行事务的方法。一种是 commit 或 rollback 方法，用于提交或回滚事务。还有一种是 transaction 方法，可用于实现事务。接下来我们来介绍这两种简单的实现事务的方法：

require 'dbi'
    begin 
        dbh = DBI.connect("DBI:Mysql:testdb:localhost","root","rootroot")
        dbh['AutoCommit']=false
        dbh.transaction do |dbh|
            dbh.do("update employee set age=age+1 where first_name='Mac' ")
            dbh.do("update employee set age = age+1 where first_name='Zara' ")
        end
            dbh['AutoCommit'] = true
    rescue DBI::DatabaseError => e
        puts "An error occurred"
        puts "Error code:    #{e.err}"
        puts "Error message: #{e.errstr}"
        dbh.rollback
    ensure
        dbh.disconnect if dbh
    end