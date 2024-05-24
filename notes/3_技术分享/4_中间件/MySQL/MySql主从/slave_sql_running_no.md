## slave sql running no

```
STOP SLAVE;
SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1; 
START SLAVE;
```

https://serverfault.com/questions/872911/slave-sql-running-no-mysql-replication-stopped-working

https://www.cnblogs.com/l-hh/p/9922548.html