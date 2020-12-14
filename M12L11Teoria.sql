--1 
 with database_adm as
 (
 select schemaname, tablename as tablename_viewname, tableowner as owner_, '-' as index_name, 't' as type_ from pg_catalog.pg_tables
 union all
 select schemaname, tablename as tablename_viewname,'-' as tableowner ,indexname , 'i' as type_ from pg_catalog.pg_indexes
 union all
 select schemaname, viewname as tablename_viewname,  viewowner as owner_,'-' as index_name, 'v' as type_ from pg_catalog.pg_views pv 
 )
 select * from database_adm where schemaname ='expense_tracker';
 
 --2
 -- aby nie tworzyc dodatkowych tabel uzyłem tabeli z expense_tracker
 CREATE EXTENSION pgcrypto;
 
 INSERT INTO expense_tracker.users
    (user_login, user_name, user_password,password_salt, active, insert_date, update_date)
    VALUES('tmichalek', 'Tomasz Michałek', crypt('ultraSilneHa3l0$567', gen_salt('md5')),'11111', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- podaj login : tmichalek
-- podaj haslo : 'ultraSilneHa3l0$567'
with login as
(select * from expense_tracker.users where user_login ='tmichalek')
select 
(case  
            when 
            login.user_password = crypt('ultraSilneHa3l0$567',login.user_password) 
            then 'Poprawne haslo'
            else 'Bledne haslo'
            end)             
        from login;
            
        
 --3
 --a
 select c_name, c_mail, c_phone, row_num 
 from (select row_number() over (partition by c_name, c_mail, c_phone) row_num, * from customers  ) as duplic
 where duplic.row_num <2;
 
 --b
 select regexp_matches(c_mail, '@[a-zA-Z0-9]+\.[a-z]') from customers;
 
 --c
 SELECT c_name, c_mail,
        replace(c_phone, substring(c_phone, 1 ,length(c_phone)-3) ,repeat('X',length(c_phone)-3)) phone_n    
  FROM customers;

 