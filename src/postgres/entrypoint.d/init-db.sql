create schema test;
set search_path to test;

create table testtable (test_id serial not null, test_val varchar(512), primary key (test_id) );

insert into testtable VALUES(default, 'my name is pham tan vinh');
insert into testtable VALUES(default, 'hi there, I''m still alive');