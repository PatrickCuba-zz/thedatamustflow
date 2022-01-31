-- test multi-insert with current view--- checking for reversion

-- sample data
-- day 1 revert, no change
-- day 2 change, no change
-- day 3 revert, change

use role sysadmin;
use warehouse compute_wh;
create database if not exists test;
use database test;
create schema if not exists stage;
create schema if not exists vault;

-- create target tables and views
   create or replace transient table test.vault.hub_account 
  (dv_tenantid varchar(20) not null
   , dv_bkeycolcode varchar(20) not null
   , dv_hashkey_hub_account binary(20) not null
   , dv_loaddate datetime not null
   , dv_applieddate datetime not null
   , dv_recsource varchar(100) not null
   , account_id varchar(40) not null
   );

  create or replace transient table test.vault.sat_card_test 
  (dv_tenantid varchar(20) not null
   , dv_hashkey_hub_account binary(20) not null
   , dv_loaddate datetime not null
   , dv_applieddate datetime not null
   , dv_recsource varchar(100) not null
   , dv_hashdiff binary(20) not null
   , dv_sid int autoincrement(0, 1)
   , test_column varchar(20))
;
   
  insert into test.vault.sat_card_test (dv_tenantid, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, dv_hashdiff) 
  select ''
       , to_binary(repeat(0, 20))
       , to_timestamp('1900-01-01 00:00:00')
       , to_timestamp('1900-01-01 00:00:00')
       , 'GHOST'
       , to_binary(repeat(0, 20))
       ;
   
  create or replace view test.vault.vh_sat_card_test as
  select * 
       , coalesce(lead(dv_applieddate) over (partition by dv_hashkey_hub_account order by dv_applieddate, dv_loaddate)
       , cast('9999-12-31' as date)) as dv_applieddate_end
       , case when lead(dv_applieddate) over (partition by dv_hashkey_hub_account order by dv_applieddate, dv_loaddate) is null then 1
         else 0 end as dv_currentflag
  from test.vault.sat_card_test;
  
  create or replace view test.vault.vc_sat_card_test as
  select * 
       , coalesce(lead(dv_applieddate) over (partition by dv_hashkey_hub_account order by dv_applieddate, dv_loaddate)
       , cast('9999-12-31' as date)) as dv_applieddate_end
       , case when lead(dv_applieddate) over (partition by dv_hashkey_hub_account order by dv_applieddate, dv_loaddate) is null then 1
         else 0 end as dv_currentflag
  from test.vault.sat_card_test
  qualify row_number() over (partition by dv_hashkey_hub_account  order by dv_applieddate desc, dv_loaddate desc) = 1;
    
-- load samples
-- day 1
set my_loaddate = '2021-01-01 00:00:00';

create or replace table stage.card_test as
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'1-revert' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
, 'revert' as test_column
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/test.csv' as dv_recsource
  , sha1_binary(concat(coalesce(to_char(trim(test_column)), ''))) as dv_hashdiff_sat_card_test
union all
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'2-no change' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
, 'no change' as test_column
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/test.csv' as dv_recsource
  , sha1_binary(concat(coalesce(to_char(trim(test_column)), ''))) as dv_hashdiff_sat_card_test
;

-- load multi table insert 
insert all
when (select count(1) from test.vault.vc_sat_card_test tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account
      and tgt.dv_hashdiff = stg_dv_hashdiff_sat_card_test) = 0 
      then 
into test.vault.sat_card_test (dv_tenantid, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, dv_hashdiff, test_column)
values (
dv_tenantid
  , stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , stg_dv_hashdiff_sat_card_test
  , test_column
)
when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values (
dv_tenantid
  , dv_bkeycolcode_hub_account
  , stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , account_id
)
select 
dv_tenantid
, dv_bkeycolcode_hub_account
  , dv_hashkey_hub_account as stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , dv_hashdiff_sat_card_test as stg_dv_hashdiff_sat_card_test
  , test_column
  , account_id
  from test.stage.card_test stg;
  
-- day 2
set my_loaddate = '2021-01-02 00:00:00';

create or replace table stage.card_test as
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'1-revert' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
, 'change' as test_column
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/test.csv' as dv_recsource
  , sha1_binary(concat(coalesce(to_char(trim(test_column)), ''))) as dv_hashdiff_sat_card_test
union all
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'2-no change' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
, 'no change' as test_column
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/test.csv' as dv_recsource
  , sha1_binary(concat(coalesce(to_char(trim(test_column)), ''))) as dv_hashdiff_sat_card_test
;

-- load multi table insert 
insert all
when (select count(1) from test.vault.vc_sat_card_test tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account
      and tgt.dv_hashdiff = stg_dv_hashdiff_sat_card_test) = 0 
      then 
into test.vault.sat_card_test (dv_tenantid, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, dv_hashdiff, test_column)
values (
dv_tenantid
  , stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , stg_dv_hashdiff_sat_card_test
  , test_column
)
when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values (
dv_tenantid
  , dv_bkeycolcode_hub_account
  , stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , account_id
)
select 
dv_tenantid
, dv_bkeycolcode_hub_account
  , dv_hashkey_hub_account as stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , dv_hashdiff_sat_card_test as stg_dv_hashdiff_sat_card_test
  , test_column
  , account_id
  from test.stage.card_test stg;
  
  -- day 3
  set my_loaddate = '2021-01-03 00:00:00';

create or replace table stage.card_test as
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'1-revert' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
, 'revert' as test_column
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/test.csv' as dv_recsource
  , sha1_binary(concat(coalesce(to_char(trim(test_column)), ''))) as dv_hashdiff_sat_card_test
union all
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'2-no change' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
, 'change' as test_column
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/test.csv' as dv_recsource
  , sha1_binary(concat(coalesce(to_char(trim(test_column)), ''))) as dv_hashdiff_sat_card_test
;
  
-- load multi table insert 
insert all
when (select count(1) from test.vault.vc_sat_card_test tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account
      and tgt.dv_hashdiff = stg_dv_hashdiff_sat_card_test) = 0 
      then 
into test.vault.sat_card_test (dv_tenantid, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, dv_hashdiff, test_column)
values (
dv_tenantid
  , stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , stg_dv_hashdiff_sat_card_test
  , test_column
)
when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values (
dv_tenantid
  , dv_bkeycolcode_hub_account
  , stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , account_id
)
select 
dv_tenantid
, dv_bkeycolcode_hub_account
  , dv_hashkey_hub_account as stg_dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recsource
  , dv_hashdiff_sat_card_test as stg_dv_hashdiff_sat_card_test
  , test_column
  , account_id
  from test.stage.card_test stg;
  
