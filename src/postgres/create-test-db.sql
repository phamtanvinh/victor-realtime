create database inventory;
connect inventory;
create schema test;
set search_path to test;

create table test_table (test_id serial not null, test_val varchar(512), primary key (_id) );

insert into test_table VALUES(default, 'my name is pham tan vinh');
insert into test_table VALUES(default, 'hi there, I''m still alive);