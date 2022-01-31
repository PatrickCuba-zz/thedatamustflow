-- sample data
-- day 1 account-1, account-2
-- day 2 account-3. account-3
-- day 3 account-1, account-1
-- day 4 account-4, account-5
--       account-4, account-6

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


   create or replace transient table test.vault.lnk_combined_accounts 
  (dv_tenantid varchar(20) not null
   , dv_hashkey_lnk_combined_accounts binary(20) not null
   , dv_hashkey_hub_account binary(20) not null
   , dv_hashkey_hub_other_account binary(20) not null
   , dv_loaddate datetime not null
   , dv_applieddate datetime not null
   , dv_recsource varchar(100) not null
   );
    
-- load samples
-- day 1
set my_loaddate = '2021-01-01 00:00:00';

create or replace table stage.card_link_test as
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'account-1' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/link_test.csv' as dv_recsource
, 'default' as dv_bkeycolcode_hub_other_account
,'account-2' as other_account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_hub_other_account

, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'), '||'
                   , dv_tenantid, '||', dv_bkeycolcode_hub_other_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_lnk_combined_accounts
;

-- load multi table insert 
insert all
when (select count(1) from test.vault.lnk_combined_accounts tgt 
      where tgt.dv_hashkey_lnk_combined_accounts = stg_dv_hashkey_lnk_combined_accounts) = 0 
      then 
into test.vault.lnk_combined_accounts (dv_tenantid, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, dv_hashkey_hub_other_account, dv_hashkey_lnk_combined_accounts)
values (dv_tenantid, stg_dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, stg_dv_hashkey_hub_other_account, stg_dv_hashkey_lnk_combined_accounts)

when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values
(
dv_tenantid, dv_bkeycolcode_hub_account, stg_dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id
)

when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_other_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values
(
dv_tenantid, dv_bkeycolcode_hub_other_account, stg_dv_hashkey_hub_other_account, dv_loaddate, dv_applieddate, dv_recsource, other_account_id
)

select 
dv_tenantid
, dv_bkeycolcode_hub_account
, dv_hashkey_hub_account as stg_dv_hashkey_hub_account
, account_id
, dv_loaddate
, dv_applieddate
, dv_recsource
, dv_bkeycolcode_hub_other_account
, dv_hashkey_hub_other_account as stg_dv_hashkey_hub_other_account
, other_account_id
, dv_hashkey_lnk_combined_accounts as stg_dv_hashkey_lnk_combined_accounts
from stage.card_link_test;

-- day 2
set my_loaddate = '2021-01-02 00:00:00';

create or replace table stage.card_link_test as
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'account-3' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/link_test.csv' as dv_recsource
, 'default' as dv_bkeycolcode_hub_other_account
,'account-3' as other_account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_hub_other_account

, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'), '||'
                   , dv_tenantid, '||', dv_bkeycolcode_hub_other_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_lnk_combined_accounts 
;

-- load multi table insert 
insert all
when (select count(1) from test.vault.lnk_combined_accounts tgt 
      where tgt.dv_hashkey_lnk_combined_accounts = stg_dv_hashkey_lnk_combined_accounts) = 0 
      then 
into test.vault.lnk_combined_accounts (dv_tenantid, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, dv_hashkey_hub_other_account, dv_hashkey_lnk_combined_accounts)
values (dv_tenantid, stg_dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, stg_dv_hashkey_hub_other_account, stg_dv_hashkey_lnk_combined_accounts)

when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values
(
dv_tenantid, dv_bkeycolcode_hub_account, stg_dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id
)

when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_other_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values
(
dv_tenantid, dv_bkeycolcode_hub_other_account, stg_dv_hashkey_hub_other_account, dv_loaddate, dv_applieddate, dv_recsource, other_account_id
)

select 
dv_tenantid
, dv_bkeycolcode_hub_account
, dv_hashkey_hub_account as stg_dv_hashkey_hub_account
, account_id
, dv_loaddate
, dv_applieddate
, dv_recsource
, dv_bkeycolcode_hub_other_account
, dv_hashkey_hub_other_account as stg_dv_hashkey_hub_other_account
, other_account_id
, dv_hashkey_lnk_combined_accounts as stg_dv_hashkey_lnk_combined_accounts
from stage.card_link_test;

-- day 3
set my_loaddate = '2021-01-03 00:00:00';

create or replace table stage.card_link_test as
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'account-1' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/link_test.csv' as dv_recsource
, 'default' as dv_bkeycolcode_hub_other_account
,'account-1' as other_account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_hub_other_account

, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'), '||'
                   , dv_tenantid, '||', dv_bkeycolcode_hub_other_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_lnk_combined_accounts  
;


-- load multi table insert 
insert all
when (select count(1) from test.vault.lnk_combined_accounts tgt 
      where tgt.dv_hashkey_lnk_combined_accounts = stg_dv_hashkey_lnk_combined_accounts) = 0 
      then 
into test.vault.lnk_combined_accounts (dv_tenantid, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, dv_hashkey_hub_other_account, dv_hashkey_lnk_combined_accounts)
values (dv_tenantid, stg_dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, stg_dv_hashkey_hub_other_account, stg_dv_hashkey_lnk_combined_accounts)

when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values
(
dv_tenantid, dv_bkeycolcode_hub_account, stg_dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id
)

when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_other_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values
(
dv_tenantid, dv_bkeycolcode_hub_other_account, stg_dv_hashkey_hub_other_account, dv_loaddate, dv_applieddate, dv_recsource, other_account_id
)

select 
dv_tenantid
, dv_bkeycolcode_hub_account
, dv_hashkey_hub_account as stg_dv_hashkey_hub_account
, account_id
, dv_loaddate
, dv_applieddate
, dv_recsource
, dv_bkeycolcode_hub_other_account
, dv_hashkey_hub_other_account as stg_dv_hashkey_hub_other_account
, other_account_id
, dv_hashkey_lnk_combined_accounts as stg_dv_hashkey_lnk_combined_accounts
from stage.card_link_test;

-- day 4;
set my_loaddate = '2021-01-04 00:00:00';

create or replace table stage.card_link_test as
select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'account-4' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/link_test.csv' as dv_recsource
, 'default' as dv_bkeycolcode_hub_other_account
,'account-5' as other_account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_hub_other_account

, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'), '||'
                   , dv_tenantid, '||', dv_bkeycolcode_hub_other_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_lnk_combined_accounts
 union all
 select
'default' as dv_tenantid
  , 'default' as dv_bkeycolcode_hub_account
,'account-4' as account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'))) as dv_hashkey_hub_account
  , to_timestamp($my_loaddate) as dv_loaddate
  , to_timestamp($my_loaddate) as dv_applieddate
  , 'lake_bucket/landed/link_test.csv' as dv_recsource
, 'default' as dv_bkeycolcode_hub_other_account
,'account-6' as other_account_id
, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_hub_other_account

, sha1_binary(concat(dv_tenantid, '||', dv_bkeycolcode_hub_account, '||', coalesce(upper(to_char(trim(account_id))), '-1'), '||'
                   , dv_tenantid, '||', dv_bkeycolcode_hub_other_account, '||', coalesce(upper(to_char(trim(other_account_id))), '-1'))) as dv_hashkey_lnk_combined_accounts
 
 
;



-- load multi table insert 
insert all
when (select count(1) from test.vault.lnk_combined_accounts tgt 
      where tgt.dv_hashkey_lnk_combined_accounts = stg_dv_hashkey_lnk_combined_accounts) = 0 
      then 
into test.vault.lnk_combined_accounts (dv_tenantid, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, dv_hashkey_hub_other_account, dv_hashkey_lnk_combined_accounts)
values (dv_tenantid, stg_dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, stg_dv_hashkey_hub_other_account, stg_dv_hashkey_lnk_combined_accounts)

when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values
(
dv_tenantid, dv_bkeycolcode_hub_account, stg_dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id
)

when (select count(1) from test.vault.hub_account tgt 
      where tgt.dv_hashkey_hub_account = stg_dv_hashkey_hub_other_account) = 0 
      then 
into test.vault.hub_account (dv_tenantid, dv_bkeycolcode, dv_hashkey_hub_account, dv_loaddate, dv_applieddate, dv_recsource, account_id)
values
(
dv_tenantid, dv_bkeycolcode_hub_other_account, stg_dv_hashkey_hub_other_account, dv_loaddate, dv_applieddate, dv_recsource, other_account_id
)

select 
dv_tenantid
, dv_bkeycolcode_hub_account
, dv_hashkey_hub_account as stg_dv_hashkey_hub_account
, account_id
, dv_loaddate
, dv_applieddate
, dv_recsource
, dv_bkeycolcode_hub_other_account
, dv_hashkey_hub_other_account as stg_dv_hashkey_hub_other_account
, other_account_id
, dv_hashkey_lnk_combined_accounts as stg_dv_hashkey_lnk_combined_accounts
from stage.card_link_test;

