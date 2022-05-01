set serveroutput on;
BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                   FROM user_objects
                   WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'MATERIALIZED VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE 'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE 'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ('FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
   FOR cur_rec IN (SELECT * 
                   FROM all_synonyms 
                   WHERE table_owner IN (SELECT USER FROM dual))
   LOOP
      BEGIN
         EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || cur_rec.synonym_name;
      END;
   END LOOP;
END;

/


-- Table: BLOCK_R
CREATE TABLE BLOCK_R (
    BLOCK_INITIATER number(10)  NOT NULL,
    BLOCK_RECEIVER number(10)  NOT NULL,
    CONSTRAINT BLOCK_R_pk PRIMARY KEY (BLOCK_INITIATER,BLOCK_RECEIVER)
) ;

-- Table: CONVERSATION_C
CREATE TABLE CONVERSATION_C (
    CONVERSATION_INITIALIZER number(10)  NOT NULL,
    CONVERSATION_RECEIVER number(10)  NOT NULL,
    TIME_STAMP TIMESTAMP NOT NULL,
    TEXT_MESSAGE clob  NOT NULL,
    CONSTRAINT CONVERSATION_C_pk PRIMARY KEY (CONVERSATION_INITIALIZER,CONVERSATION_RECEIVER,TIME_STAMP)
) ;

-- Table: GENDER_PREFERENCE_U
CREATE TABLE GENDER_PREFERENCE_U (
    GENDER_ID number(10)  NOT NULL,
    USER_ID number(10)  NOT NULL,
    CONSTRAINT GENDER_PREFERENCE_U_pk PRIMARY KEY (GENDER_ID,USER_ID)
) ;

-- Table: GENDER_U
CREATE TABLE GENDER_U (
    GENDER_ID number(10)  NOT NULL,
    GENDER varchar2(10) UNIQUE NOT NULL CHECK(GENDER IN ('MALE','FEMALE'
    ,'TRANS'
    ,'PANGENDER'
    ,'POLYGENDER'
    ,'OTHERS')),
    CONSTRAINT GENDER_U_pk PRIMARY KEY (GENDER_ID)
    
) ;

-- Table: INTERESTED_IN_RELATION_U
CREATE TABLE INTERESTED_IN_RELATION_U (
    USER_ID number(10)  NOT NULL,
    RELATIONSHIP_TYPE_ID number(10)  NOT NULL,
    CONSTRAINT INTERESTED_IN_RELATION_U_pk PRIMARY KEY (USER_ID,RELATIONSHIP_TYPE_ID)
) ;

-- Table: RATING_R
CREATE TABLE RATING_R (
    RATE_INITIATER number(10)  NOT NULL,
    RATE_RECEIVER number(10)  NOT NULL,
    RATE number(2)  NOT NULL CHECK(RATE IN (1,2,3,4,5,6,7,8,9,10)),
    CONSTRAINT RATING_R_pk PRIMARY KEY (RATE_INITIATER,RATE_RECEIVER)
) ;

-- Table: RELATIONSHIP_TYPE_U
CREATE TABLE RELATIONSHIP_TYPE_U (
    RELATIONSHIP_TYPE_ID number(10)  NOT NULL,
    RELATIONSHIP_TYPE varchar2(20)  NOT NULL CHECK(RELATIONSHIP_TYPE IN ('CASUAL'
     ,'SERIOUS'
     ,'COMMITTED'
     ,'NSA'
     ,'NOT SURE')),
    CONSTRAINT RELATIONSHIP_TYPE_U_pk PRIMARY KEY (RELATIONSHIP_TYPE_ID)
) ;

-- Table: USER_DETAIL_U
CREATE TABLE USER_DETAIL_U (
    USER_ID number(10)  NOT NULL,
    GENDER_ID number(10)  NOT NULL,
    LAST_NAME varchar2(50),
    FIRST_NAME varchar2(50)  NOT NULL,
    PHONE_NUMBER number(10)  NOT NULL,
    EMAIL varchar2(100)  NOT NULL,
    REGISTRATION_TIMESTAMP timestamp NOT NULL,
    DATE_OF_BIRTH date  NOT NULL,
    BIO varchar2(400),
    HOBBY varchar2(30),
    HEIGHT number(3),
    CITY varchar2(40)  NOT NULL,
    STATE varchar2(2)  NOT NULL,
    INSTAGRAM_LINK varchar2(500) UNIQUE NOT NULL,
    PASSWORD varchar2(100)  NOT NULL,
    LAST_LOGIN timestamp NOT NULL,
    PASSPORT_NUMBER varchar2(10) UNIQUE NOT NULL,
    MEMBERSHIP_TYPE varchar2(15)  NOT NULL CHECK(MEMBERSHIP_TYPE IN ('FREE','PREMIUM')),
    CONSTRAINT USER_DETAIL_U_pk PRIMARY KEY (USER_ID)
) ;

-- Table: USER_LIKE_U
CREATE TABLE USER_LIKE_U (
    INITIATOR_ID number(10)  NOT NULL,
    RECEIVER_ID number(10)  NOT NULL,
    STATUS number(1)  NOT NULL CHECK(STATUS IN (1,0)),
    CONSTRAINT USER_LIKE_U_pk PRIMARY KEY (RECEIVER_ID,INITIATOR_ID)
) ;

-- Table: USER_PHOTO_U
CREATE TABLE USER_PHOTO_U (
    PHOTO_ID number(10)  NOT NULL,
    USER_ID number(10)  NOT NULL,
    TIME_UPLOADED timestamp  NOT NULL,
    PHOTO_LINK varchar2(500)  NOT NULL,
    CONSTRAINT USER_PHOTO_U_pk PRIMARY KEY (PHOTO_ID)
) ;

-- foreign keys
-- Reference: BLOCK_USER_DETAIL_U (table: BLOCK_R)
ALTER TABLE BLOCK_R ADD CONSTRAINT BLOCK_USER_DETAIL_U
    FOREIGN KEY (BLOCK_RECEIVER)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: BLOCK_USER_DETAIL_U_1 (table: BLOCK_R)
ALTER TABLE BLOCK_R ADD CONSTRAINT BLOCK_USER_DETAIL_U_1
    FOREIGN KEY (BLOCK_INITIATER)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: CONVERSATION_C_USER_DETAIL_U (table: CONVERSATION_C)
ALTER TABLE CONVERSATION_C ADD CONSTRAINT CONVERSATION_C_USER_DETAIL_U
    FOREIGN KEY (CONVERSATION_INITIALIZER)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: CONVERSATION_C_USER_DETAIL_U_1 (table: CONVERSATION_C)
ALTER TABLE CONVERSATION_C ADD CONSTRAINT CONVERSATION_C_USER_DETAIL_U_1
    FOREIGN KEY (CONVERSATION_RECEIVER)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: GENDER_PREFERENCE_U_GENDER_U (table: GENDER_PREFERENCE_U)
ALTER TABLE GENDER_PREFERENCE_U ADD CONSTRAINT GENDER_PREFERENCE_U_GENDER_U
    FOREIGN KEY (GENDER_ID)
    REFERENCES GENDER_U (GENDER_ID)
    ON DELETE CASCADE;

-- Reference: GENDER_PREFERENCE_U_U_1 (table: GENDER_PREFERENCE_U)
ALTER TABLE GENDER_PREFERENCE_U ADD CONSTRAINT GENDER_PREFERENCE_U_U_1
    FOREIGN KEY (USER_ID)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: INTERESTED_IN_RELATION_U_USER_DETAIL_U (table: INTERESTED_IN_RELATION_U)
ALTER TABLE INTERESTED_IN_RELATION_U ADD CONSTRAINT INTERESTED_IN_RELATION_U_USER_DETAIL_U
    FOREIGN KEY (USER_ID)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;
-- Reference: RATING_USER_DETAIL_U (table: RATING_R)
ALTER TABLE RATING_R ADD CONSTRAINT RATING_USER_DETAIL_U
    FOREIGN KEY (RATE_RECEIVER)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: RATING_USER_DETAIL_U_1 (table: RATING_R)
ALTER TABLE RATING_R ADD CONSTRAINT RATING_USER_DETAIL_U_1
    FOREIGN KEY (RATE_INITIATER)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: RELATIONSHIP_TYPE_INTERESTED_IN_RELATION_U (table: INTERESTED_IN_RELATION_U)
ALTER TABLE INTERESTED_IN_RELATION_U ADD CONSTRAINT RELATIONSHIP_TYPE_INTERESTED_IN_RELATION_U
    FOREIGN KEY (RELATIONSHIP_TYPE_ID)
    REFERENCES RELATIONSHIP_TYPE_U (RELATIONSHIP_TYPE_ID)
    ON DELETE CASCADE;

-- Reference: USER_DETAIL_U_GENDER_U (table: USER_DETAIL_U)
ALTER TABLE USER_DETAIL_U ADD CONSTRAINT USER_DETAIL_U_GENDER_U
    FOREIGN KEY (GENDER_ID)
    REFERENCES GENDER_U (GENDER_ID)
    ON DELETE CASCADE;

-- Reference: USER_DETAIL_U_USER_LIKE_U (table: USER_LIKE_U)
ALTER TABLE USER_LIKE_U ADD CONSTRAINT USER_DETAIL_U_USER_LIKE_U
    FOREIGN KEY (RECEIVER_ID)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: USER_DETAIL_U_USER_LIKE_U_2 (table: USER_LIKE_U)
ALTER TABLE USER_LIKE_U ADD CONSTRAINT USER_DETAIL_U_USER_LIKE_U_2
    FOREIGN KEY (INITIATOR_ID)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;

-- Reference: USER_PHOTO_U_USER_DETAIL_U (table: USER_PHOTO_U)
ALTER TABLE USER_PHOTO_U ADD CONSTRAINT USER_PHOTO_U_USER_DETAIL_U
    FOREIGN KEY (USER_ID)
    REFERENCES USER_DETAIL_U (USER_ID)
    ON DELETE CASCADE;
    /
DECLARE
count_s number;
begin
select count(*) into count_s from user_sequences where sequence_name =upper('user_id_seq'); 
IF (count_s = 0) then
EXECUTE IMMEDIATE 'CREATE SEQUENCE user_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE  9999999999
 NOCACHE
 NOCYCLE';
ELSE 
EXECUTE IMMEDIATE 'DROP SEQUENCE user_id_seq';
EXECUTE IMMEDIATE 'CREATE SEQUENCE user_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE  9999999999
 NOCACHE
 NOCYCLE';
END IF;
END;
/
DECLARE
count_s number;
begin
select count(*) into count_s from user_sequences where sequence_name =upper('photo_id_seq'); 
IF (count_s = 0) then
EXECUTE IMMEDIATE 'CREATE SEQUENCE photo_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE  9999999999
 NOCACHE
 NOCYCLE';
ELSE 
EXECUTE IMMEDIATE 'DROP SEQUENCE photo_id_seq';
EXECUTE IMMEDIATE 'CREATE SEQUENCE photo_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE  9999999999
 NOCACHE
 NOCYCLE';
END IF;
END;
/

CREATE OR REPLACE FUNCTION gender_id_name(gender_i IN varchar2)
RETURN number
IS
gender_id_value number;
BEGIN
select gender_id into gender_id_value from GENDER_U  where gender = gender_i;
RETURN gender_id_value;
EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20101, 'Invalid Gender entered.');
END;
/

-- Function to get the Relationship type ID --
CREATE OR REPLACE FUNCTION relation_id_name(relation_i IN varchar2)
RETURN number
IS
relation_id_value number;
BEGIN
select relationship_type_ID into relation_id_value from RELATIONSHIP_TYPE_U  where relationship_type = relation_i;
RETURN relation_id_value;
EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20101, 'Invalid Relationship Type entered.');
END;
/

-- Function to get the USER ID --
CREATE OR REPLACE FUNCTION get_user_id(email_value IN varchar2, password_value IN varchar2)
RETURN number
IS
user_id_value number;
BEGIN
select user_id into user_id_value from user_detail_u  where email = email_value  and password_value=password;
RETURN user_id_value;
EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20101, 'Please check your credentials OR sign up to the platform.');
END;
/

-- Function to get the USER ID without password --
CREATE OR REPLACE FUNCTION get_user_id_wp(email_value IN varchar2)
RETURN number
IS
user_id_value number;
BEGIN
select user_id into user_id_value from user_detail_u  where email= email_value ;
RETURN user_id_value;
EXCEPTION
WHEN NO_DATA_FOUND THEN
            raise_application_error(-20101, 'Please check the email reciever you have entered.');
END;
/
CREATE OR REPLACE PACKAGE INSERT_MODULE AS 
-- INSERT USER
PROCEDURE INSERT_USER_PRIMARY(gender_i IN varchar2,last_name_i IN varchar2,
first_name_i IN varchar2,phone_number_i IN number,email_i IN varchar2,
dob_i IN date,bio_i in varchar2,hobby_i in varchar2,
height_i in number,city_i in varchar2,state_i in varchar2,
iglink_i in varchar2,password_i in varchar2,passport_number_i in varchar2);
-- INSERT RELATIONSHIP TYPE
procedure INSERT_RELATIONSHIP_TYPE(email_value IN varchar2, password_value IN varchar2, preference IN varchar2);
-- INSERT BLOCK
procedure INSERT_BLOCK(email_initiator IN varchar2, password_initiator IN varchar2, email_receiver IN varchar2);
-- INSERT PHOTO
procedure INSERT_PHOTO(email_initiator IN varchar2, password_initiator IN varchar2,photolink in varchar);
-- INSERT CONVERSATION
procedure INSERT_CONVERSATION(email_initiator IN varchar2, password_initiator IN varchar2, email_receiver IN varchar2,text_message in clob);
-- INSERT LIKE
procedure INSERT_LIKE(email_initiator IN varchar2, password_initiator IN varchar2, email_receiver IN varchar2);
-- INSERT GENDER_PREFERENCE
procedure INSERT_GENDER_PREFERENCE(email_value IN varchar2, password_value IN varchar2, preference IN varchar2);
-- INSERT RATE
procedure INSERT_RATING(email_initiator IN varchar2, password_initiator IN varchar2, email_receiver IN varchar2, val IN number); 
END INSERT_MODULE; 
/
CREATE OR REPLACE PACKAGE BODY INSERT_MODULE AS
PROCEDURE INSERT_USER_PRIMARY(gender_i IN varchar2,last_name_i IN varchar2,
first_name_i IN varchar2,phone_number_i IN number,email_i IN varchar2,
dob_i IN date,bio_i in varchar2,hobby_i in varchar2,
height_i in number,city_i in varchar2,state_i in varchar2,
iglink_i in varchar2,password_i in varchar2,passport_number_i in varchar2)
IS
gender_id_val number;
photo_count number;
gender_pref number;
count_val number;
count_val2 number;
count_val3 number;
count_val4 number;
BEGIN
gender_id_val := gender_id_name(gender_i);
select count(*) into count_val from USER_DETAIL_U where email = email_i;
select count(*) into count_val2 from USER_DETAIL_U where PASSPORT_NUMBER = upper(passport_number_i); 
select count(*) into count_val3 from USER_DETAIL_U where instagram_link = upper(iglink_i);
select count(*) into count_val4 from user_detail_u where phone_number = phone_number_i;
if count_val > 0 or count_val2 > 0 or count_val3 > 0 or count_val4 > 0 then
dbms_output.put_line('You have already signed up');
else
merge into admin_dating_app.USER_DETAIL_U u using sys.dual on (u.email = email_i OR u.PASSPORT_NUMBER = upper(passport_number_i) OR u.instagram_link = upper(iglink_i) )
WHEN NOT MATCHED THEN INSERT(user_id,gender_id,last_name,first_name,phone_number,email,last_login,DATE_OF_BIRTH,bio,hobby,height,city,state,INSTAGRAM_LINK,PASSWORD,REGISTRATION_TIMESTAMP,PASSPORT_NUMBER,membership_type)
VALUES(user_id_seq.NEXTVAL,gender_id_val,last_name_i,first_name_i,phone_number_i,email_i,sysdate,dob_i,bio_i,hobby_i,height_i,city_i,state_i,upper(iglink_i),password_i,sysdate,upper(passport_number_i),'FREE');
commit;
select count(*) into photo_count from  USER_PHOTO_U where user_id = get_user_id_wp(email_i);
select count(*) into gender_pref from  GENDER_PREFERENCE_U where user_id = get_user_id_wp(email_i);
if photo_count < 1 and gender_pref < 1 then
dbms_output.put_line('Please insert atleast 1 photo,1 gender preference and 1 relationship preference');
end if;
end if;
COMMIT;
END INSERT_USER_PRIMARY;
procedure INSERT_RELATIONSHIP_TYPE(email_value IN varchar2, password_value IN varchar2, preference IN varchar2) 
is
userid number;
RELATIONID number;
user_id_relation_id_uniqueEx exception;
user_id_relation_id_unique number;
begin
userid := get_user_id(email_value,password_value);
RELATIONID := relation_id_name(preference);
merge into INTERESTED_IN_RELATION_U u using sys.dual on (u.user_id = userid and u.relationship_type_id = RELATIONID)
WHEN NOT MATCHED THEN INSERT(user_id,relationship_type_id)
VALUES(userid,RELATIONID);
update user_detail_u set last_login = sysdate where user_id = userid ;
commit;
END INSERT_RELATIONSHIP_TYPE;
procedure INSERT_BLOCK(email_initiator IN varchar2, password_initiator IN varchar2, email_receiver IN varchar2) 

is

userid_initiator number;
userid_receiver number;
initiator_id_receiver_id_unique number;
initiator_id_receiver_id_uniqueEx exception;
count_val number;

begin

userid_initiator := get_user_id(email_initiator,password_initiator);
userid_receiver := get_user_id_wp(email_receiver);
userid_initiator := get_user_id(email_initiator,password_initiator);
userid_receiver := get_user_id_wp(email_receiver);
select count(*) into count_val from block_r where block_initiater = userid_initiator and block_receiver =  userid_receiver;
if count_val > 0 then
dbms_output.put_line('You cant block same person more than once');
else
merge into BLOCK_R B using sys.dual on (B.BLOCK_INITIATER = userid_initiator and B.BLOCK_RECEIVER = userid_receiver)
WHEN NOT MATCHED THEN INSERT(BLOCK_INITIATER,BLOCK_RECEIVER)
VALUES(userid_initiator,userid_receiver);
update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
COMMIT;
end if;
end INSERT_BLOCK;
procedure INSERT_PHOTO(email_initiator IN varchar2, password_initiator IN varchar2,photolink in varchar) 

is

userid_initiator number;
photo_id_unique number;
photo_id_uniqueEx exception;
photo_count number;
begin
userid_initiator := get_user_id(email_initiator,password_initiator);
select count(*) into photo_count from  USER_PHOTO_U where user_id = userid_initiator;
if photo_count < 5 THEN
merge into USER_PHOTO_U u using sys.dual on (u.user_id = userid_initiator and u.photo_link = photolink)
WHEN NOT MATCHED THEN INSERT(photo_id,user_id,time_uploaded,photo_link)
VALUES(photo_id_seq.NEXTVAL,userid_initiator,sysdate,photolink);
update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
commit;
else 
dbms_output.put_line('You have already inserted 5 picture, deleting your oldest photo ');
DELETE FROM USER_PHOTO_U WHERE user_id = userid_initiator
and time_uploaded = (select min(time_uploaded) from USER_PHOTO_U where user_id = userid_initiator);
merge into USER_PHOTO_U u using sys.dual on (u.user_id = userid_initiator and u.photo_link = photolink)
WHEN NOT MATCHED THEN INSERT(photo_id,user_id,time_uploaded,photo_link)
VALUES(photo_id_seq.NEXTVAL,userid_initiator,sysdate,photolink);
update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
commit;

END if;

END INSERT_PHOTO;
procedure INSERT_CONVERSATION(email_initiator IN varchar2, password_initiator IN varchar2, email_receiver IN varchar2,text_message in clob)
is

userid_initiator number;
userid_receiver number;
x number;
y number;
begin

userid_initiator := get_user_id(email_initiator,password_initiator);
userid_receiver := get_user_id_wp(email_receiver);

    select count(*) into x from Block_r
    where (block_initiater=userid_initiator and block_receiver=userid_receiver) or (block_receiver=userid_initiator and block_initiater=userid_receiver);
    if x>0 then 
        raise_application_error(-20102, 'There is a block, you cannot converse with them.');
        update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
    end if;

    select count(*) into x from user_like_u
    where (initiator_id=userid_initiator and receiver_id=userid_receiver and status=1) or (receiver_id=userid_initiator and initiator_id=userid_receiver and status=1 );
    if x=2 then 
        select count(*) into y FROM CONVERSATION_C where CONVERSATION_INITIALIZER=userid_initiator and CONVERSATION_RECEIVER=userid_receiver and TIME_STAMP=sysdate;
        if y !=0 then raise_application_error(-20102, 'You cannot send two messeges at the same time.');
        else
        INSERT INTO CONVERSATION_C (CONVERSATION_INITIALIZER,CONVERSATION_RECEIVER,TIME_STAMP,TEXT_MESSAGE)
        VALUES(userid_initiator,userid_receiver,sysdate,text_message);
        end if;
        update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
        commit;
    else x:=0; 
        raise_application_error(-20101, 'You have not matched with each other so you cannot converse with each other');
        update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
    end if;
end INSERT_CONVERSATION;
procedure INSERT_LIKE(email_initiator IN varchar2, password_initiator IN varchar2, email_receiver IN varchar2) 
is
userid_initiator number;
userid_receiver number;
x number;
y number;
begin
userid_initiator := get_user_id(email_initiator,password_initiator);
userid_receiver := get_user_id_wp(email_receiver);
if email_initiator = email_receiver then raise_application_error(-20101, 'You cannot like yourself, input another email-id');
end if;
select count(*) into y from user_photo_u where user_id=userid_initiator;
if y=0 then raise_application_error(-20106, 'You cannot proceed with the like as you do not have any photo. Please upload atleat one photo.');
end if;    
    select COUNT(*) INTO X from user_detail_u a 
    inner join gender_preference_u b 
        on a.user_id=b.user_id
    inner join interested_in_relation_u c 
        on a.user_id=c.user_id
    where a.GENDER_ID in (select gender_id from gender_preference_u where user_id=userid_initiator)
    and b.GENDER_ID in (select gender_id from user_detail_u where user_id=userid_initiator)
    and a.email!=email_initiator 
    AND a.email=email_receiver
    AND c.relationship_type_id in (select relationship_type_id from interested_in_relation_u where user_id=userid_initiator);
   if x=0 then raise_application_error(-20104, 'You cannot proceed with the like');
end if;

merge into user_like_u u using sys.dual on (u.initiator_id = userid_initiator and u.receiver_id = userid_receiver)
WHEN NOT MATCHED THEN INSERT(initiator_id,receiver_id,status)
VALUES(userid_initiator,userid_receiver,1);
commit;
end INSERT_LIKE;
procedure INSERT_GENDER_PREFERENCE(email_value IN varchar2, password_value IN varchar2, preference IN varchar2) 
is
userid number;
GENDERID number;
user_id_gender_id_uniqueEx exception;
user_id_gender_id_unique number;
begin
userid := get_user_id(email_value,password_value);
GENDERID := gender_id_name(preference);
merge into GENDER_PREFERENCE_U u using sys.dual on (u.user_id = userid and u.gender_id = GENDERID)
WHEN NOT MATCHED THEN INSERT(user_id,gender_id)
VALUES(userid,GENDERID);
update user_detail_u set last_login = sysdate where user_id = userid ;
commit;
end INSERT_GENDER_PREFERENCE;
procedure INSERT_RATING(email_initiator IN varchar2, password_initiator IN varchar2, email_receiver IN varchar2, val IN number) 

is

userid_initiator number;
userid_receiver number;
x number;
count_val number;
begin

userid_initiator := get_user_id(email_initiator,password_initiator);
userid_receiver := get_user_id_wp(email_receiver);
select count(*) into count_val from rating_r where rate_initiater = userid_initiator and rate_receiver =  userid_receiver;
if count_val > 0 then
dbms_output.put_line('You cant rate same person more than once');
else
    select count(*) into x from Block_r
    where (block_initiater=userid_initiator and block_receiver=userid_receiver) or (block_receiver=userid_initiator and block_initiater=userid_receiver);
    if x>0 then 
        raise_application_error(-20102, 'User is blocked, you cannot rate them.');
        update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
    end if;

    select count(*) into x from user_like_u
    where (initiator_id=userid_initiator and receiver_id=userid_receiver and status=1) or (receiver_id=userid_initiator and initiator_id=userid_receiver and status=1 );
    if x=2 then 
        merge into RATING_R R using sys.dual on (R.RATE_INITIATER = userid_initiator and R.RATE_RECEIVER = userid_receiver)
        WHEN NOT MATCHED THEN INSERT(RATE_INITIATER,RATE_RECEIVER,RATE)
        VALUES(userid_initiator,userid_receiver,val);
        update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
        commit;
    else x:=0; 
        raise_application_error(-20101, 'You have not matched with each other so you cannot rate.');
        update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
    end if;

end if;
end INSERT_RATING;


END;
/

CREATE OR REPLACE PACKAGE UPDATE_MODULE AS 
   -- update bio
   PROCEDURE UPDATE_BIO(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2); 
   -- update city
   PROCEDURE UPDATE_CITY(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2);
   -- update height
   PROCEDURE UPDATE_HEIGHT(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN VARCHAR2);
   -- update hobby
   PROCEDURE UPDATE_HOBBY(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN VARCHAR2);
   -- update membeship type
   PROCEDURE UPDATE_MEMBERSHIP_TYPE(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN VARCHAR2);
   -- update password
   PROCEDURE UPDATE_PASSWORD(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN VARCHAR2);
   -- update passport number
   PROCEDURE UPDATE_PASSPORT_NUMBER(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN VARCHAR2);
   -- update state
   PROCEDURE UPDATE_STATE(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN VARCHAR2);
END UPDATE_MODULE; 
/

CREATE OR REPLACE PACKAGE BODY UPDATE_MODULE AS
PROCEDURE UPDATE_BIO(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2) IS
userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  update user_detail_u set bio=update_this where user_id=userid_initiator;
  dbms_output.put_line('Your bio has been updated');
  commit;
 END UPDATE_BIO;
PROCEDURE UPDATE_CITY(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2) IS
userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  update user_detail_u set city=update_this where user_id=userid_initiator;
  dbms_output.put_line('Your city has been updated');
  commit;
 END UPDATE_CITY;
PROCEDURE UPDATE_HEIGHT(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN VARCHAR2) IS
userid_initiator number;
BEGIN
  if (LENGTH(TRIM(TRANSLATE(update_this, ' +-.0123456789', ' ')))) is not null then
          raise_application_error(-20108, 'Height should be in numeric only.');
  elsif update_this is null then 
    raise_application_error(-20101, 'Height cannot be null.');
  end if;
  IF LENGTH(update_this) > 3 THEN
    raise_application_error(-20101, 'Enter appropriate height.');
  end if;
  userid_initiator := get_user_id(email_initiator,password_initiator);
  update user_detail_u set height=update_this where user_id=userid_initiator;
  dbms_output.put_line('Your height has been updated');
  commit;
 END UPDATE_HEIGHT;
 PROCEDURE UPDATE_HOBBY(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2) IS
userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  update user_detail_u set hobby=update_this where user_id=userid_initiator;
  dbms_output.put_line('Your hobby has been updated');
  commit;
 END UPDATE_HOBBY;
PROCEDURE UPDATE_MEMBERSHIP_TYPE(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2) IS
userid_initiator number;
BEGIN
  IF update_this != 'FREE' and update_this != 'PREMIUM' THEN
  dbms_output.put_line('please enter valid membership type');
  else
  userid_initiator := get_user_id(email_initiator,password_initiator);
  update user_detail_u set membership_type=update_this where user_id=userid_initiator;
  dbms_output.put_line('Your membership type has been updated');
  commit;
  end if;
  if (update_this='PREMIUM') then dbms_output.put_line('And your invoice has been sent to your email.'); end if;
 END UPDATE_MEMBERSHIP_TYPE;
PROCEDURE UPDATE_PASSPORT_NUMBER(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2) IS
userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  update user_detail_u set passport_number=update_this where user_id=userid_initiator;
  dbms_output.put_line('Your passport number has been updated');
 END UPDATE_PASSPORT_NUMBER;
PROCEDURE UPDATE_PASSWORD(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2) IS
userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  update user_detail_u set password=update_this where user_id=userid_initiator;
  dbms_output.put_line('Your password has been updated');
  commit;
 END UPDATE_PASSWORD;
PROCEDURE UPDATE_STATE(email_initiator IN varchar2, password_initiator IN varchar2, update_this IN varchar2) IS
userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  update user_detail_u set state=update_this where user_id=userid_initiator;
  dbms_output.put_line('Your state has been updated');
  commit;
 END UPDATE_STATE;
END;
/

create or replace TRIGGER AGE_CHECK 
BEFORE INSERT OR UPDATE ON USER_DETAIL_U
FOR EACH ROW
BEGIN
    IF :NEW.DATE_OF_BIRTH >  add_months(sysdate , -12*18)  then
       RAISE_APPLICATION_ERROR(-20001, 'Your age is less than 18, you cannot sign up');
    END IF;
END;
/

CREATE OR REPLACE PACKAGE USER_VIEW_MODULE AS 
   -- view matches
   procedure VIEW_MATCHES(email_initiator in varchar2, password_initiator in varchar2);
   -- view messages received
   procedure VIEW_MESSAGES_RECEIVED(email_initiator IN varchar2, password_initiator IN varchar2);
   -- view messages sent
   PROCEDURE VIEW_MESSAGES_SENT(email_initiator IN varchar2, password_initiator IN varchar2);
   -- view other users
   PROCEDURE VIEW_OTHER_USERS(email_initiator IN varchar2, password_initiator IN varchar2);
   -- view photos of matched users
   PROCEDURE VIEW_PHOTOS_MATCHES(email_initiator IN varchar2, password_initiator IN varchar2,email_receiver in varchar2);
END USER_VIEW_MODULE; 
/

CREATE OR REPLACE PACKAGE BODY USER_VIEW_MODULE AS
procedure VIEW_MATCHES(email_initiator in varchar2, password_initiator in varchar2) is
userid_initiator number;
begin
userid_initiator := get_user_id(email_initiator,password_initiator);
declare 
cursor eid is select a.email,a.first_name,a.last_name,a.city,a.state,a.date_of_birth,a.bio,a.hobby,a.instagram_link,a.height from 
(select  f1.receiver_id as user2
from user_like_u f1,user_like_u f2
     where f1.initiator_id = f2.receiver_id 
     AND f2.initiator_id = f1.receiver_id
     and f1.initiator_id = userid_initiator)temp,
     user_detail_u a 
where temp.user2 = a.user_id;
    v_mgr eid%ROWTYPE;  
  BEGIN
    OPEN EID;

  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;

    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Name: ' ||v_mgr.first_name||' ' || v_mgr.last_name);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Email: ' ||v_mgr.email || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Age: ' ||FLOOR(MONTHS_BETWEEN(TRUNC(SYSDATE, 'DD'), v_mgr.DATE_OF_BIRTH)/12) || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Height: ' ||v_mgr.Height || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Bio: ' ||v_mgr.bio || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Hobby: ' ||v_mgr.email || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('City,State: ' ||v_mgr.city||', ' || v_mgr.state);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Instagram Link: ' ||v_mgr.instagram_link ||'');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;DBMS_OUTPUT.NEW_LINE;DBMS_OUTPUT.NEW_LINE;
    commit;
  END LOOP;

  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No match found.');
   end if;
  CLOSE EID;
 END;
END VIEW_MATCHES;
PROCEDURE VIEW_MESSAGES_RECEIVED(email_initiator IN varchar2, password_initiator IN varchar2) IS 
userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
DECLARE
  cursor eid is select u.first_name as sender_first_name,u.last_name as sender_last_name,temp.text_message ,temp.time_stamp,u.email
from 
(select c.conversation_initializer as sender,c.time_stamp,c.text_message  
from conversation_c c
where c.conversation_receiver = userid_initiator)temp,
user_detail_u u
where temp.sender = u.user_id
;
   v_mgr eid%ROWTYPE;
BEGIN
    OPEN EID; 
  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;
    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Sender Name: ' ||v_mgr.sender_first_name||' ' || v_mgr.sender_last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' ||v_mgr.email);
    DBMS_OUTPUT.PUT_LINE('Time:' || v_mgr.time_stamp);
    DBMS_OUTPUT.PUT_LINE('Text Message:' ||v_mgr.text_message);
END LOOP;

  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No match found.');
   end if;
  CLOSE EID;
 END;

END VIEW_MESSAGES_RECEIVED;
PROCEDURE VIEW_MESSAGES_SENT(email_initiator IN varchar2, password_initiator IN varchar2) IS 
userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
DECLARE
  cursor eid is select u.first_name as receiver_first_name,u.last_name as receiver_last_name,temp.text_message ,temp.time_stamp,u.email
from 
(select c.conversation_receiver as receiver,c.time_stamp,c.text_message  
from conversation_c c
where c.conversation_initializer = userid_initiator)temp,
user_detail_u u
where temp.receiver = u.user_id
;
   v_mgr eid%ROWTYPE;
BEGIN
    OPEN EID; 
  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;
    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Receiver Name: ' ||v_mgr.receiver_first_name||' ' || v_mgr.receiver_last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' ||v_mgr.email);
    DBMS_OUTPUT.PUT_LINE('Time:' || v_mgr.time_stamp);
    DBMS_OUTPUT.PUT_LINE('Text Message:' ||v_mgr.text_message);
END LOOP;

  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No match found.');
   end if;
  CLOSE EID;
 END;

END VIEW_MESSAGES_SENT;
PROCEDURE VIEW_OTHER_USERS(email_initiator IN varchar2, password_initiator IN varchar2) IS

userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  declare
    cursor eid is select distinct a.email,a.first_name,a.last_name,a.city,a.state,a.date_of_birth,a.bio,a.hobby,a.instagram_link,a.height from user_detail_u a 
    inner join gender_preference_u b 
        on a.user_id=b.user_id
    inner join interested_in_relation_u c 
        on a.user_id=c.user_id
    where a.GENDER_ID in (select gender_id from gender_preference_u where user_id=userid_initiator)
    and b.GENDER_ID in (select gender_id from user_detail_u where user_id=userid_initiator)
    and a.email!=email_initiator 
    AND c.relationship_type_id in (select relationship_type_id from interested_in_relation_u where user_id=userid_initiator);
    v_mgr eid%ROWTYPE;

  BEGIN
    OPEN EID;

  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;

    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Name: ' ||v_mgr.first_name||' ' || v_mgr.last_name);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Email: ' ||v_mgr.email || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Age: ' ||FLOOR(MONTHS_BETWEEN(TRUNC(SYSDATE, 'DD'), v_mgr.DATE_OF_BIRTH)/12) || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Height: ' ||v_mgr.Height || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Bio: ' ||v_mgr.bio || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Hobby: ' ||v_mgr.hobby || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('City,State: ' ||v_mgr.city||', ' || v_mgr.state);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Instagram Link: ' ||v_mgr.instagram_link ||'');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;DBMS_OUTPUT.NEW_LINE;DBMS_OUTPUT.NEW_LINE;
  END LOOP;

  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No match found.');
   end if;
  CLOSE EID;
 END;

END VIEW_OTHER_USERS;
PROCEDURE VIEW_PHOTOS_MATCHES(email_initiator IN varchar2, password_initiator IN varchar2,email_receiver in varchar2) IS
userid_initiator number;
USERID_RECEIVER number;
x number;
begin
userid_initiator := get_user_id(email_initiator,password_initiator);
USERID_RECEIVER := get_user_id_wp(email_receiver);

select count(*) into x from Block_r
    where (block_initiater=userid_initiator and block_receiver=userid_receiver) or (block_receiver=userid_initiator and block_initiater=userid_receiver);
    if x>0 then 
        raise_application_error(-20102, 'There is a block, you cannot view thier photos.');
        update user_detail_u set last_login = sysdate where user_id = userid_initiator ;
    end if;
declare 
cursor eid is select a.email,a.first_name,a.last_name,p.photo_link,p.time_uploaded from 
(select  f1.receiver_id as user2
from user_like_u f1,user_like_u f2
     where f1.initiator_id = f2.receiver_id 
     AND f2.initiator_id = f1.receiver_id
     and f1.initiator_id = userid_initiator)temp,
     user_detail_u a,
     user_photo_u p
where temp.user2 = a.user_id
and a.user_id = p.user_id;
    v_mgr eid%ROWTYPE;  
  BEGIN
    OPEN EID;

  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;

    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Name: ' ||v_mgr.first_name||' ' || v_mgr.last_name);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Email: ' ||v_mgr.email || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Photo Link: ' ||v_mgr.photo_link || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Time of photo: ' ||v_mgr.time_uploaded || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;DBMS_OUTPUT.NEW_LINE;DBMS_OUTPUT.NEW_LINE;
  END LOOP;

  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No match found.');
   end if;
  CLOSE EID;
 END;
END VIEW_PHOTOS_MATCHES;
END;
/

CREATE OR REPLACE PACKAGE DELETE_MODULE AS 
-- delete photo
PROCEDURE DELETE_PHOTO(email_initiator IN varchar2, password_initiator IN varchar2,photo_link_i in varchar2);
-- delete user
PROCEDURE DELETE_USER(email_initiator IN varchar2, password_initiator IN varchar2);
END DELETE_MODULE; 
/

CREATE OR REPLACE PACKAGE BODY DELETE_MODULE AS
PROCEDURE DELETE_PHOTO(email_initiator IN varchar2, password_initiator IN varchar2,photo_link_i in varchar2) is
userid_initiator number;
min_time number;
BEGIN
userid_initiator := get_user_id(email_initiator,password_initiator);
select count(*) into min_time from USER_PHOTO_U WHERE user_id = userid_initiator AND photo_link = photo_link_i;
if min_time =0 then dbms_output.put_line('Please check the photo link!');
else
DELETE FROM USER_PHOTO_U WHERE user_id = userid_initiator AND photo_link =  photo_link_i;
dbms_output.put_line('Deleting photo!');
end if;
commit;
END DELETE_PHOTO;
PROCEDURE DELETE_USER(email_initiator IN varchar2, password_initiator IN varchar2) is
userid_initiator number;
BEGIN 
 userid_initiator := get_user_id(email_initiator,password_initiator);
 dbms_output.put_line('Deleting your profile from Dating App!');
 DELETE FROM user_detail_u where user_id = userid_initiator;
commit;
END DELETE_USER;

END;
/

--delete gender pref
create or replace 
PROCEDURE DELETE_GENDER_PREFERENCE(email_initiator IN varchar2, password_initiator IN varchar2,preference in varchar2) is
userid_initiator number;
gender_pref number;
x number;
BEGIN
gender_pref := gender_id_name(preference);
userid_initiator := get_user_id(email_initiator,password_initiator);

select count(*) into x from gender_preference_u WHERE user_id = userid_initiator AND gender_id = gender_pref;
if x=0 then dbms_output.put_line('You do not have this gender as your preference!');
ELSIF x=1 then 
DELETE FROM gender_preference_u WHERE user_id = userid_initiator AND gender_id =  gender_pref;
dbms_output.put_line('Deleting gender preference!');
commit;
end if;
END DELETE_GENDER_PREFERENCE;
/

--delete rel pref
create or replace 
PROCEDURE DELETE_RELATIONSHIP_PREFERENCE(email_initiator IN varchar2, password_initiator IN varchar2,preference in varchar2) is
userid_initiator number;
rel_pref number;
x number;
BEGIN
rel_pref := relation_id_name(preference);
userid_initiator := get_user_id(email_initiator,password_initiator);

select count(*) into x from interested_in_relation_u WHERE user_id = userid_initiator AND RELATIONSHIP_TYPE_ID = rel_pref;
if x=0 then dbms_output.put_line('You do not have this relation type as your preference!');
ELSIF x=1 then 
DELETE FROM interested_in_relation_u WHERE user_id = userid_initiator AND RELATIONSHIP_TYPE_ID =  rel_pref;
dbms_output.put_line('Deleting relationship preference!');
commit;
end if;
END DELETE_RELATIONSHIP_PREFERENCE;
/

--view user details
create or replace PROCEDURE VIEW_USER_DETAILS(email_initiator IN varchar2, password_initiator IN varchar2) IS

userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  declare
    cursor eid is select a.email,a.first_name,b.gender,a.last_name,a.city,a.state,a.date_of_birth,a.bio,a.hobby,a.instagram_link,a.height,a.phone_number,a.passport_number,a.membership_type from user_detail_u a 
    inner join gender_u b on b.gender_id=a.gender_id
    where a.user_id=userid_initiator;
    v_mgr eid%ROWTYPE;
    
  BEGIN
    OPEN EID;
     
  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;
   
    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Name: ' ||v_mgr.first_name||' ' || v_mgr.last_name);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Email: ' ||v_mgr.email || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Phone Number: ' ||v_mgr.phone_number || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Age: ' ||FLOOR(MONTHS_BETWEEN(TRUNC(SYSDATE, 'DD'), v_mgr.DATE_OF_BIRTH)/12) || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Gender: ' ||v_mgr.gender || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Height: ' ||v_mgr.Height || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Bio: ' ||v_mgr.bio || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Hobby: ' ||v_mgr.email || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('City,State: ' ||v_mgr.city||', ' || v_mgr.state);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Instagram Link: ' ||v_mgr.instagram_link ||'');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Passport Number: ' ||v_mgr.passport_number || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Membership Type: ' ||v_mgr.membership_type || '');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;DBMS_OUTPUT.NEW_LINE;DBMS_OUTPUT.NEW_LINE;
  END LOOP;
  
  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No match found.');
   end if;
  CLOSE EID;
 END;
 commit;
END VIEW_USER_DETAILS;
/
--view GENDER_PREFERENCE
create or replace PROCEDURE VIEW_GENDER_PREFERENCE(email_initiator IN varchar2, password_initiator IN varchar2) IS

userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  declare
    cursor eid is select b.gender from gender_preference_u a 
    inner join gender_u b on b.gender_id=a.gender_id
    where a.user_id=userid_initiator;
    v_mgr eid%ROWTYPE;
    
  BEGIN
    OPEN EID;
     
  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;
   
    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Gender: ' ||v_mgr.gender || '');
    DBMS_OUTPUT.NEW_LINE;
  END LOOP;
  
  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No preferred gender found.');
   end if;
  CLOSE EID;
 END;
 commit;
END;
/


--view relation_PREFERENCE
create or replace PROCEDURE VIEW_relation_PREFERENCE(email_initiator IN varchar2, password_initiator IN varchar2) IS

userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  declare
    cursor eid is select b.RELATIONSHIP_TYPE from interested_in_relation_u a 
    inner join relationship_type_u b on b.RELATIONSHIP_TYPE_ID=a.RELATIONSHIP_TYPE_ID
    where a.user_id=userid_initiator;
    v_mgr eid%ROWTYPE;
    
  BEGIN
    OPEN EID;
     
  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;
   
    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Relationship Type: ' ||v_mgr.RELATIONSHIP_TYPE || '');
    DBMS_OUTPUT.NEW_LINE;
  END LOOP;
  
  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No preferred relationship found.');
   end if;
  CLOSE EID;
 END;
 commit;
END;
/

--view photos
create or replace PROCEDURE VIEW_photos(email_initiator IN varchar2, password_initiator IN varchar2) IS

userid_initiator number;
BEGIN
  userid_initiator := get_user_id(email_initiator,password_initiator);
  declare
    cursor eid is select photo_link from user_photo_u a 
    where a.user_id=userid_initiator;
    v_mgr eid%ROWTYPE;
    
  BEGIN
    OPEN EID;
     
  LOOP
    -- fetch information from cursor into record
    FETCH eid INTO v_mgr;
   
    EXIT WHEN eid%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Photo Link: ' ||v_mgr.photo_link || '');
    DBMS_OUTPUT.NEW_LINE;
  END LOOP;
  
  if eid%ROWCOUNT=0 then
      DBMS_OUTPUT.PUT_LINE('No photos found.');
   end if;
  CLOSE EID;
 END;
 commit;
END;
/
----View_1
CREATE OR REPLACE VIEW MEMBERSHIP_TYPE_VIEW AS 
SELECT MEMBERSHIP_TYPE, COUNT(*)*100/(SELECT COUNT(*) FROM USER_DETAIL_U) AS PERCENTAGE_OF_MEMBER_TYPE FROM USER_DETAIL_U GROUP BY MEMBERSHIP_TYPE;
/
----View_2
CREATE or replace VIEW AVERAGE_RATING_RECEIVED_VIEW AS 
select u.user_id,u.first_name,u.last_name,u.email,temp.average_rating from
(SELECT DISTINCT(RATE_RECEIVER) ,AVG(RATE) AS AVERAGE_RATING FROM RATING_R GROUP BY RATE_RECEIVER)temp,user_detail_u u
where temp.rate_receiver = u.user_id;
/
----View_3

CREATE OR REPLACE VIEW RATING_RANKING_BY_CITY_VIEW AS 
select u.user_id,u.first_name,u.last_name,u.email,temp.average_rating as AVERAGE_RATING, DENSE_RANK() OVER (PARTITION by u.city  ORDER BY temp.average_rating DESC) as City_Rank,u.city
from
(SELECT DISTINCT(RATE_RECEIVER) ,AVG(RATE) AS AVERAGE_RATING FROM RATING_R GROUP BY RATE_RECEIVER)temp,user_detail_u u
where temp.rate_receiver = u.user_id;
/
--VIEW_4

CREATE OR REPLACE VIEW RATING_RANKING_BY_STATE_VIEW AS 
select u.user_id,u.first_name,u.last_name,u.email,temp.average_rating as AVERAGE_RATING, DENSE_RANK() OVER (PARTITION by u.state  ORDER BY temp.average_rating DESC) as State_Rank,u.state
from
(SELECT DISTINCT(RATE_RECEIVER) ,AVG(RATE) AS AVERAGE_RATING FROM RATING_R GROUP BY RATE_RECEIVER)temp,user_detail_u u
where temp.rate_receiver = u.user_id;
/
----View_5
CREATE OR REPLACE VIEW NUMBER_OF_TOTAL_BLOCKS AS
select u.user_id,u.first_name,u.last_name,u.email,temp.NUMBER_OF_BLOCKS
from
(SELECT BLOCK_RECEIVER, COUNT(*) AS NUMBER_OF_BLOCKS FROM BLOCK_R GROUP BY BLOCK_RECEIVER)temp,user_detail_u u
where temp.block_receiver = u.user_id;
/
---View_6
CREATE or replace VIEW BLOCKED_PROFILES_PER_CITY_VIEW AS 
with unique_blocks as(select distinct block_receiver from block_r)
select count(b.block_receiver) as block_Users, city
from user_detail_u a
join unique_blocks b
on b.block_receiver=a.user_id
group by a.city;
/
---View_7
CREATE or replace VIEW BLOCKED_PROFILES_PER_STATE_VIEW AS 
with unique_blocks as(select distinct block_receiver from block_r)
select count(b.block_receiver) as block_Users, a.state
from user_detail_u a
join unique_blocks b
on b.block_receiver=a.user_id
group by a.state;
/
----View_8
CREATE VIEW CUSTOMER_RETENTION_VIEW AS
SELECT LAST_NAME, FIRST_NAME, EMAIL,TRUNC(LAST_LOGIN) AS LAST_LOGGED_IN FROM USER_DETAIL_U WHERE LAST_LOGIN > TRUNC(SYSDATE-30);

/
----View_9
CREATE OR REPLACE VIEW USERS_AGE_REPORT_VIEW AS
select age_group as "AGE_GROUP_NAME" , count(*) as "AGE_GROUP_COUNT"
from(select case when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 19) then 'TEENS'
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 29) then 'TWENTIES'
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 39) then 'THIRTIES'
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 49) then 'FORTIES'
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 59) then 'FIFTIES'
            else 'OTHERS'
            end age_group
    from USER_DETAIL_U)
group by age_group
ORDER BY age_group;

/
--View_10
CREATE OR REPLACE VIEW  USER_GENDER_REPORT_VIEW  AS
SELECT g.gender,temp.total from
(select gender_id,
count(*) as total
from user_detail_u
GROUP BY GENDER_ID)temp,gender_u g
where temp.gender_id = g.gender_id ;
/
-- View_11
CREATE OR REPLACE VIEW FLAGGED_PROFILE_VIEW AS
with cte1 as
(
select count(user_id) as block_Users, a.User_id
from user_detail_u a
join Block_R b
on b.block_receiver=a.user_id
group by User_id
)
select * 
from cte1
where cte1.block_Users >=10;

/

GRANT EXECUTE ON INSERT_MODULE TO USER_DATING_APP;

GRANT EXECUTE ON UPDATE_MODULE TO USER_DATING_APP;

GRANT EXECUTE ON USER_VIEW_MODULE TO USER_DATING_APP;

GRANT EXECUTE ON DELETE_MODULE TO USER_DATING_APP;

GRANT EXECUTE ON DELETE_GENDER_PREFERENCE TO USER_DATING_APP;

GRANT EXECUTE ON DELETE_RELATIONSHIP_PREFERENCE TO USER_DATING_APP;

GRANT EXECUTE ON VIEW_USER_DETAILS TO USER_DATING_APP;

GRANT EXECUTE ON DELETE_GENDER_PREFERENCE TO USER_DATING_APP;

GRANT EXECUTE ON DELETE_RELATIONSHIP_PREFERENCE TO USER_DATING_APP;

GRANT EXECUTE ON VIEW_GENDER_PREFERENCE TO USER_DATING_APP;

GRANT EXECUTE ON VIEW_PHOTOS TO USER_DATING_APP;

GRANT EXECUTE ON VIEW_RELATION_PREFERENCE TO USER_DATING_APP;

GRANT EXECUTE ON VIEW_USER_DETAILS TO USER_DATING_APP;
/
GRANT ALL PRIVILEGES ON GENDER_U TO DATA_OPERATOR;
GRANT ALL PRIVILEGES ON RELATIONSHIP_TYPE_U TO DATA_OPERATOR;
/
GRANT SELECT ON AVERAGE_RATING_RECEIVED_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON MEMBERSHIP_TYPE_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON AVERAGE_RATING_RECEIVED_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON RATING_RANKING_BY_CITY_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON RATING_RANKING_BY_STATE_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON NUMBER_OF_TOTAL_BLOCKS TO REPORTING_ANALYST;
GRANT SELECT ON BLOCKED_PROFILES_PER_CITY_VIEW TO  REPORTING_ANALYST;
GRANT SELECT ON BLOCKED_PROFILES_PER_STATE_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON CUSTOMER_RETENTION_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON USERS_AGE_REPORT_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON USER_GENDER_REPORT_VIEW TO REPORTING_ANALYST;
GRANT SELECT ON FLAGGED_PROFILE_VIEW TO REPORTING_ANALYST;
/