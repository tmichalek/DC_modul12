--1
update users set user_password =crypt(user_password,gen_salt('md5'));
alter table expense_tracker.users drop column password_salt;

--2
--Aby wykonaÃƒâ€žÃ¢â‚¬Â¡ zadania, sprÃƒÆ’Ã‚Â³bÃƒÆ’Ã‚Â³je podejÃƒâ€¦Ã¢â‚¬Âºc do analizy tabel tak jakbym wczeÃƒâ€¦Ã¢â‚¬Âºniej nie miaÃƒâ€¦Ã¢â‚¬Å¡ z nimi do czynienia
--sprawdzenie ile table jest w schemacie
select count(table_name)
from information_schema."tables" t 
         where table_schema='expense_tracker' and table_type ='BASE TABLE';
     
-- sprawdzenie czy wszytkie tabele posiadajÃƒâ€žÃ¢â‚¬Â¦ klucz gÃƒâ€¦Ã¢â‚¬Å¡owny
select count(distinct table_name) from information_schema.table_constraints tc2 where constraint_schema ='expense_tracker' and constraint_type ='PRIMARY KEY';

--znalezienie wszytkich tabel ktÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³re posiadaja klucz obcy, oraz wyÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Âºwetlenie
-- ich kluczy gÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³wnych aby znaleÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚ÂºÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¡ czy wystepuje w nich wartoÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚ÂºÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¡ -1 <unknown>
-- nie wiem czy dobrze zrozumiaÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡em twoje polecenie :)
with pk_table_with_fk as 
    (with pk_fk as 
        (
            select kcu.column_name ,kcu.table_name, kcu.constraint_name, tc.constraint_type,
            row_number() over (partition by kcu.table_name  ) as row_num
            from information_schema.key_column_usage kcu 
            inner join information_schema.table_constraints tc on (kcu.constraint_name =tc.constraint_name ) 
            order by kcu.table_name
         ) 
      select pk_fk.table_name,pk_fk.column_name,pk_fk.constraint_type,
      sum(pk_fk.row_num) over (partition by pk_fk.table_name ) as sum__
      from pk_fk 
    )
select pk_table_with_fk.table_name, 
       pk_table_with_fk.column_name, 
       pk_table_with_fk.constraint_type, 
       pk_table_with_fk.sum__ from main 
       where sum__>1 and pk_table_with_fk.constraint_type = 'PRIMARY KEY';
        
  -- sprawdzenie kolejno kluczy gÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ownych w tabelech 
  select count(*) from expense_tracker.bank_account_types bat where id_ba_type =-1;
  select count(*) from expense_tracker.transaction_bank_accounts tba where id_trans_ba =-1;
  select count(*) from expense_tracker.transaction_subcategory ts where id_trans_subcat =-1;
  select count(*) from expense_tracker.transactions t where id_transaction =-1;
  
--nie wiem dokÃƒÆ’Ã¢â‚¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡adnie czy o to Ci chodziÃƒÆ’Ã¢â‚¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡o ?:)
  
 --b
 --
  select count(*) from expense_tracker.transactions t;
  --w tabeli transactions caÃƒâ€¦Ã¢â‚¬Å¡a kolumna id_users posuiada wartoÃƒâ€¦Ã¢â‚¬ÂºÃƒâ€žÃ¢â‚¬Â¡ nieokreslonÃƒâ€žÃ¢â‚¬Â¦ null
  
 --ilosc kolumn
 select count(*) from information_schema."columns" c  where table_name ='transactions';
 -- ilosc id users
 select count(coalesce(t.id_user, -1)) from expense_tracker.transactions t ;
--ilosc wszystkich wierszy
 select count(*) from expense_tracker.transactions t; 
--obliczenie jaki procent wszytkich rekordÃƒÂ³w stanowiÃ„â€¦ wartoÃ…â€ºci null
 with stat_trans_table as
( select
 (select count(*) from information_schema."columns" c  where table_name ='transactions') *(select count(*) from expense_tracker.transactions t) as all_records,
 (select count(coalesce(id_user, -2)) from expense_tracker.transactions t)users_row
 )
 select *, ((cast(users_row as numeric)/cast(all_records as numeric)*100)::numeric(10,2)) perc_of_null_rec
 from stat_trans_table;
 
--3
--a) dla kaÃ…Â¼dego gospodarstwa domowego tworzony jest odzielny schemat.
--b) uÃ…Â¼ytkanikami bÃ„â„¢dÃ„â€¦ osoby w danej rodzinie, ktÃƒÂ³re sÃ„â€¦ wÃ…â€šaÃ…â€ºcicielami bÃ„â€¦dÃ…Âº wspÃƒÂ³Ã…â€š wÃ…â€šaÃ…â€ºcicielami konta/kont.
--c) hashowane hasÃ…â€šo przechowywane bÃ„â„¢dzie w tabeli users, kaÃ…Â¼dy uÃ…Â¼ytkownik dostanie hasÃ…â€šo domyÃ…â€ºlne, ktÃƒÂ³re podczas
--   pierwszego logowania zostanie zmienione przez uÃ…Â¼ytkownika.
--d) ostateczny strukturÃ„â„¢ bazy danaych wykonam w oparciu o zmainy zaproponowane przeze mnie  w module 6 z drobnymi poprawkami.

 
 --4
--utworzenie schematu
drop schema if exists expense_tracker cascade;
create schema if not exists expense_tracker; 
---------------------------------------------------------------------------------
--role
---------------------------------------------------------------------------------
create role app_users;
revoke create on schema public from public;
revoke all on database postgres from public;
grant usage on schema expense_tracker to app_users;

create role user1 with login password 'user1';
create role user2 with login password 'user1';
grant user1 to app_users;
grant user2 to app_users;

--tabele
----------------------------------------------------------------------------------
CREATE EXTENSION pgcrypto;
drop table if exists expense_tracker.users;
create table expense_tracker.users
            ( 
            id_user          serial, 
            user_login       varchar(25) not null, 
            user_name        varchar(50) not null, 
            user_password    varchar(100) not null,  
            active           boolean default true not null, 
            insert_date      timestamp default current_timestamp, 
            update_date      timestamp default current_timestamp,
 constraint users_pk primary key(id_user)         
            );


drop table if exists expense_tracker.transaction_type;
create table expense_tracker.transaction_type
            ( 
            id_trans_type         serial, 
            transaction_type_name varchar(50) not null, 
            active                boolean default true not null, 
            insert_date           timestamp default current_timestamp, 
            update_date           timestamp default current_timestamp,
constraint transaction_type_pk primary key(id_trans_type)             
            );


drop table if exists expense_tracker.transaction_category;
create table expense_tracker.transaction_category
            ( 
            id_trans_cat         serial, 
            category_name        varchar(50) not null, 
            category_description varchar(250), 
            active               boolean default true not null, 
            insert_date          timestamp default current_timestamp, 
            update_date          timestamp default current_timestamp,
constraint transaction_category_pk primary key(id_trans_cat)
            );


drop table if exists expense_tracker.bank_account_owner;
create table expense_tracker.bank_account_owner
            ( 
            id_ba_own    serial, 
            id_user      int,
            active       boolean default true not null,  
            insert_date  timestamp default current_timestamp, 
            update_date  timestamp default current_timestamp,
constraint bank_account_owner_pk primary key(id_ba_own),
constraint bank_account_owner_users_fk foreign key(id_user) references expense_tracker.users(id_user)
            );

drop table if exists expense_tracker.transaction_subcategory;
create table expense_tracker.transaction_subcategory
            (
            id_trans_subcat          serial,  
            id_trans_cat             integer, 
            subcategory_name         varchar(50) not null, 
            subcategory_description  varchar(250), 
            active                   boolean default true not null, 
            insert_date              timestamp default current_timestamp, 
            update_date              timestamp default current_timestamp,
constraint transaction_subcategory_pk primary key(id_trans_subcat),
constraint transaction_subcategory_transaction_category_fk foreign key (id_trans_cat) references 
            expense_tracker.transaction_category(id_trans_cat)
            );

drop table if exists expense_tracker.bank_account_types;
create table expense_tracker.bank_acount_types
            ( 
            id_ba_type        serial, 
            ba_type           varchar(50)not null, 
            ba_desc           varchar(250), 
            active            boolean default true not null, 
            id_ba_own         integer, insert_date timestamp default current_timestamp, 
            update_date       timestamp default current_timestamp,
constraint bank_acount_types_pk primary key (id_ba_type),
constraint bank_acount_types_bank_account_owner_fk foreign key(id_ba_own) references 
            expense_tracker.bank_account_owner(id_ba_own)
            );

drop table if exists expense_tracker.transaction_bank_account;
create table expense_tracker.transaction_bank_account
            ( 
            id_trans_ba       serial,
            id_ba_type        integer,  
            active            boolean default true not null, 
            insert_date       timestamp default current_timestamp, 
            update_date       timestamp default current_timestamp,
constraint transaction_bank_account_pk primary key(id_trans_ba),            
constraint transaction_bank_account_bank_acount_types_fk foreign key(id_ba_type) references 
            expense_tracker.bank_acount_types(id_ba_type)
            );


drop table if exists expense_tracker.transactions_partitioned;
create table  expense_tracker.transactions_partitioned ( 
  id_transaction  serial, 
  id_trans_ba     integer, 
  id_trans_cat    integer, 
  id_trans_subcat integer, 
  id_trans_type   integer, 
  id_user         integer, 
  transaction_date date default current_date, 
  transaction_value numeric(9,2), 
  transaction_description text,
  insert_date      timestamp default current_timestamp, 
  update_date      timestamp default current_timestamp,
  constraint transactions_partitioned_pk1 primary key(id_transaction,transaction_date),
  constraint transactions_partitioned_transaction_bank_account_fk foreign key(id_trans_ba) references 
             expense_tracker.transaction_bank_account(id_trans_ba),
  constraint transactions_partitioned_transaction_category_fk foreign key(id_trans_cat) references 
             expense_tracker.transaction_category(id_trans_cat),
  constraint transactions_partitioned_transaction_subcategory_fk foreign key(id_trans_subcat) references 
             expense_tracker.transaction_subcategory(id_trans_subcat),
  constraint transactions_partitioned_transaction_type_fk foreign key(id_trans_type) references 
             expense_tracker.transaction_type(id_trans_type),
  constraint transactions_partitioned_users_fk foreign key(id_user) references 
             expense_tracker.users(id_user)
  )partition by range(transaction_date); 
  
  create table transactions_y2015 partition of expense_tracker.transactions_partitioned for values from ('2015-01-01') to ('2016-01-01'); 
  create table transactions_y2016 partition of expense_tracker.transactions_partitioned for values from ('2016-01-01') to ('2017-01-01'); 
  create table transactions_y2017 partition of expense_tracker.transactions_partitioned for values from ('2017-01-01') to ('2018-01-01'); 
  create table transactions_y2018 partition of expense_tracker.transactions_partitioned for values from ('2018-01-01') to ('2019-01-01'); 
  create table transactions_y2019 partition of expense_tracker.transactions_partitioned for values from ('2019-01-01') to ('2020-01-01'); 
  create table transactions_y2020 partition of expense_tracker.transactions_partitioned for values from ('2020-01-01') to ('2021-01-01');
 
------------------------------------------------------------------------------------------------------------------------------------------
--uprawnienia do tabel
grant select, insert, update, delete on table expense_tracker.transactions_partitioned to app_users;
grant update(user_password, user_login) on table expense_tracker.users to app_users;
  
-- poprawa wydajnosci
---------------------------------------------------------------------------------------
--sprawdzic czy kozysta z indexu
----indeksy
create index transac_year_indx on expense_tracker.transactions_partitioned (extract(year from transaction_date));
create index transac_quart_indx on expense_tracker.transactions_partitioned (extract(quarter from transaction_date));
create index subcat_name_indx on expense_tracker.transaction_subcategory (subcategory_name); 
create index cat_name_indx on expense_tracker.transaction_category (category_name);

----- funkcje

------------------------
--funkcja zwracająca wartośc transakcji w podanym roku roku 
create or replace function expense_tracker_.transac_sum(y integer)
    RETURNS float
    LANGUAGE plpgsql
    AS $$   
        declare trans_sum float;
        begin 
        select sum(expense_tracker.transactions_partitioned.transaction_value) into trans_sum  from transactions_partitioned 
        where extract(year from expense_tracker_.transactions_partitione.transaction_date)=$1;       
        return trans_sum;
        END
    $$;


create or replace function expense_tracker.transac_sum_for_owner(y integer, n text)
    RETURNS float
    LANGUAGE plpgsql
    AS $$   
        declare trans_sum_for_person float;
        begin 
        select sum(tp.transaction_value) into trans_sum_for_person 
        from transactions_partitioned tp
        inner join expense_tracker.users u on (u.id_user=tp.id_user) and u.user_name = $2 
        where extract(year from tp.transaction_date)=$1;       
        return trans_sum_for_person;
        END
    $$;

------chciałem przygotować funkcje zwracającą widok oraz tabele, niestety w przypadku widoku wogóle mi to nie wyszło
---- w przypadku tabeli do końca nie wiem ja zrobić aby zwracane był wiele wierszy
--- jeśli podesłał byś jakieś linki lub materiały jak to zrobić , będę bardzo wdzięczny
---- nie wiem czy takie funkcję zwracający widoki nie podpadają pod jakieś antywzorce


create or replace function expense_tracker.view_for_year(y integer, n text)
    RETURNS table (category_name varchar, subcategory_name varchar, transaction_type_name varchar, 
                    transaction_date date,trans_year float, transaction_value numeric, ba_type varchar)
    LANGUAGE plpgsql
    AS $$   

        begin 
      return query 
       select
            tc.category_name, ts.subcategory_name, tt.transaction_type_name, t.transaction_date,
            extract (year from t.transaction_date) trans_year, t.transaction_value, bat.ba_type
            from expense_tracker.transactions_partitioned t 
                inner join expense_tracker.transaction_type tt on (t.id_trans_type =tt.id_trans_type) and extract(year from t.transaction_date)=$1
                inner join expense_tracker.transaction_subcategory ts on (t.id_trans_subcat= ts.id_trans_subcat)
                inner join expense_tracker.transaction_category tc on (t.id_trans_cat=tc.id_trans_cat)
                inner join expense_tracker.users u on (u.id_user =t.id_user)and u.user_name = $2
                inner join expense_tracker.bank_account_owner bao on (bao.id_user =u.id_user)
                inner join expense_tracker.bank_acount_types bat on (bat.id_ba_own =bao.id_ba_own)
                inner join expense_tracker.transaction_bank_account tba on (tba.id_ba_type =bat.id_ba_type );
            return;
        END
    $$;


            



            