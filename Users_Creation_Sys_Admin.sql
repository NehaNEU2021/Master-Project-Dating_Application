CREATE OR REPLACE PROCEDURE create_users
is
userexist integer;

begin
-- creating admin
  select count(*) into userexist from dba_users where username='ADMIN_DATING_APP';
  if (userexist = 0) then
    execute immediate 'create user admin_dating_app identified by DeFz8yQfpZVz';
    execute immediate 'GRANT create session TO admin_dating_app';
    execute immediate 'grant create view, create procedure, create sequence to admin_dating_app';
    execute immediate 'grant create table to admin_dating_app';
    execute immediate 'alter user admin_dating_app quota unlimited on users';

  end if;
  
-- creating data_operator
  select count(*) into userexist from dba_users where username='DATA_OPERATOR';
  if (userexist = 0) then
    execute immediate 'create user DATA_OPERATOR identified by NxXPY6boUurG9';
    execute immediate 'GRANT create session TO DATA_OPERATOR';
    execute immediate 'grant create view, create procedure, create sequence to DATA_OPERATOR';

  end if;
--- creating user_dating_app
select count(*) into userexist from dba_users where username='USER_DATING_APP';
  if (userexist = 0) then
    execute immediate 'create user USER_DATING_APP identified by UserPassword123';
    execute immediate 'GRANT create session TO USER_DATING_APP';
    execute immediate  'alter user USER_DATING_APP quota unlimited on users';

  end if;
end;
/
execute create_users();
/
