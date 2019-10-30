create database test;

create table test_table (_id serial not null, _val varchar(512), primary key (_id) );

INSERT INTO test_table VALUES(2, 'test-val');

update test_table set _val = 'something' where _id = 2;

ALTER TABLE test_table REPLICA IDENTITY FULL;