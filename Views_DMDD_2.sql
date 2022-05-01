----View_1

CREATE VIEW MEMBERSHIP_TYPE_VIEW AS 
SELECT MEMBERSHIP_TYPE, COUNT(*)*100/(SELECT COUNT(*) FROM USER_DETAIL_U) AS PERCENTAGE_OF_MEMBER_TYPE FROM USER_DETAIL_U GROUP BY MEMBERSHIP_TYPE

SELECT * FROM MEMBERSHIP_TYPE_VIEW




----View_2
CREATE VIEW AVERAGE_RATING_RECEIVED_VIEW AS 
SELECT DISTINCT(RATE_RECEIVER) ,AVG(RATE) AS AVERAGE_RATING FROM RATING_R GROUP BY RATE_RECEIVER;

SELECT * FROM AVERAGE_RATING_RECEIVED_VIEW


----View_3

CREATE VIEW RATING_RANKING_BY_CITY_VIEW AS 
select user_id, city,Rate,
DENSE_RANK() OVER (PARTITION by city  ORDER BY Rate DESC) as City_Rank
from user_detail_u a
join rating_r b
on b.rate_receiver=a.user_id

--VIEW_4

CREATE VIEW RATING_RANKING_BY_STATE_VIEW  AS 
select user_id, a.state,Rate,
DENSE_RANK() OVER (PARTITION by a.state  ORDER BY Rate DESC) as STATE_RANK
      
from user_detail_u a
join rating_r b
on b.rate_receiver=a.user_id


----View_5
CREATE VIEW NUMBER_OF_TOTAL_BLOCKS AS
SELECT BLOCK_RECEIVER, COUNT(*) AS NUMBER_OF_BLOCKS FROM BLOCK_R GROUP BY BLOCK_RECEIVER;



---View_6
CREATE VIEW BLOCKED_PROFILES_PER_CITY_VIEW AS 
select count(user_id) as block_Users, city
from user_detail_u a
join Block_R b
on b.block_receiver=a.user_id
group by city

---View_7

CREATE VIEW  BLOCKED_PROFILES_PER_STATE_VIEW AS 
select count(user_id) as block_Users, state
from user_detail_u a
join Block_R b
on b.block_receiver=a.user_id
group by state


----View_8
CREATE VIEW CUSTOMER_RETENTION_VIEW AS
SELECT LAST_NAME, FIRST_NAME, EMAIL,TRUNC(LAST_LOGIN) AS LAST_LOGGED_IN FROM USER_DETAIL_U WHERE LAST_LOGIN > TRUNC(SYSDATE-30)



----View_9
select age_group , count(*)
from(
    select 
        case 
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 19) then 'TEENS'
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 29) then 'TWENTIES'
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 39) then 'THIRTIES'
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 49) then 'FORTIES'
            when (trunc( months_between(sysdate, DATE_OF_BIRTH) / 12 ) <= 59) then 'FIFTIES'
            

            else 'OTHERS'
        end age_group
    from USER_DETAIL_U
)
group by age_group
ORDER BY age_group
;



--View_10
CREATE VIEW  USER_GENDER_REPORT_VIEW  AS
select gender_id,
count(*) over (partition by gender_id order by gender_id) as total
from user_detail_u



