
alter session set query_tag='set up session';

use role sysadmin;
use warehouse compute_wh;
create database if not exists test;
use database test;
create schema if not exists stage;
create schema if not exists vault;


-- turn off cache;
alter session set USE_CACHED_RESULT = FALSE;
alter warehouse compute_wh set warehouse_size=small;

set my_rec_count=20000000;
set my_loaddate = '2021-01-01 00:00:00';


-- create sample structures
  create or replace transient table stage.card_masterfile_source
  (account_id varchar(40)
   , card_type varchar(1)
   , card_balance decimal
   , card_status varchar(1)
   , credit_limit decimal
   );

  create or replace transient table stage.card_masterfile1
  (dv_tenantid varchar(20)
   , dv_bkeycolcode_hub_account varchar(20)
   , dv_hashkey_hub_account binary(20)
   , dv_loaddate datetime
   , dv_applieddate datetime
   , dv_recsource varchar(100)
   , dv_hashdiff_sat_card_masterfile binary(20)
   , account_id varchar(40)
   , card_type varchar(1)
   , card_balance decimal
   , card_status varchar(1)
   , credit_limit decimal
   );    

  create or replace transient table stage.card_masterfile2 
  (dv_tenantid varchar(20)
   , dv_bkeycolcode_hub_account varchar(20)
   , dv_hashkey_hub_account binary(20)
   , dv_loaddate datetime
   , dv_applieddate datetime
   , dv_recsource varchar(100)
   , dv_hashdiff_sat_card_masterfile binary(20)
   , account_id varchar(40)
   , card_type varchar(1)
   , card_balance decimal
   , card_status varchar(1)
   , credit_limit decimal
   );    

alter session set query_tag='Create base table';

-- create base sample
insert overwrite into stage.card_masterfile_source
  select lpad(uniform(1, $my_rec_count, random()), 10, '0') as account_id
  , case when mod(account_id,3) =0 then ''
         when mod(account_id,2) =0 then 'P'
         else 'A'
         end as card_type
  , uniform(50, 50000, random()) card_balance
  , '' as card_status
  , 2000 as credit_limit
  from table(generator(rowcount => $my_rec_count));

-- clear wh cache
alter warehouse compute_wh suspend;

alter session set query_tag='CONCAT structure function';

-- now insert into staging tables
insert overwrite into stage.card_masterfile1
with dedupe as (
  select 'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
  , sha1_binary(UPPER(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(to_char(trim(account_id)), '-1')))) as dv_hashkey_hub_account
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/card_masterfile.csv' as dv_recordsource
  , sha1_binary(concat(coalesce(to_char(trim(card_type)), ''), '||', coalesce(to_char(trim(card_balance)), ''), '||', coalesce(to_char(trim(card_status)), ''), '||', coalesce(to_char(trim(credit_limit)), ''))) as dv_hashdiff_sat_card_masterfile
  , account_id, card_type, card_balance, card_status, credit_limit
  , row_number() over (partition by account_id order by account_id) as dv_rnk
  from stage.card_masterfile_source
  qualify dv_rnk = 1)
  select dv_tenantid
  , dv_bkeycolcode_hub_account
  , dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recordsource
  , dv_hashdiff_sat_card_masterfile
  , account_id, card_type, card_balance, card_status, credit_limit
  from dedupe
  ;
 
-- clear wh cache
alter warehouse compute_wh suspend;

alter session set query_tag='ARRAY-TO-STRING semi-structure function';

insert overwrite into stage.card_masterfile2  
  with dedupe as (
  select 'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
, sha1_binary(UPPER(ARRAY_TO_STRING(ARRAY_CONSTRUCT(dv_tenantid, dv_bkeycolcode_hub_account, coalesce(to_char(TRIM(account_id)), '-1')), '||'))) AS dv_hashkey_hub_account
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/card_masterfile.csv' as dv_recordsource
  , sha1_binary(ARRAY_TO_STRING(ARRAY_CONSTRUCT(TRIM(card_type), TRIM(card_balance), TRIM(card_status), TRIM(credit_limit)), '||')) AS dv_hashdiff_sat_card_masterfile
, account_id, card_type, card_balance, card_status, credit_limit
  , row_number() over (partition by account_id order by account_id) as dv_rnk
  from stage.card_masterfile_source
  qualify dv_rnk = 1
  )
  select dv_tenantid
  , dv_bkeycolcode_hub_account
  , dv_hashkey_hub_account
  , dv_loaddate
  , dv_applieddate
  , dv_recordsource
  , dv_hashdiff_sat_card_masterfile
  , account_id, card_type, card_balance, card_status, credit_limit
  from dedupe
  ;
 
-- clear wh cache
alter warehouse compute_wh suspend;

