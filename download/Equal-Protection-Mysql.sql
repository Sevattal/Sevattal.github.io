show plugins;
show variables like '%validate_password%';
show variables like '%connection_control%';
show global variables like '%authentication%';
show global variables like '%default_password_lifetime%';
show global variables like '%require_secure_transport%';
show global variables like 'max%';
show global variables like '%ssl%';
show global variables like '%log%';
show global variables like '%time%';
show variables;
select version();
use mysql;
select * from user;
SELECT * FROM db;
select * from tables_priv;
select * from columns_priv;
use information_schema;
select * from USER_PRIVILEGES;
select * from SCHEMA_PRIVILEGES;
select * from TABLE_PRIVILEGES;
select * from COLUMN_PRIVILEGES;