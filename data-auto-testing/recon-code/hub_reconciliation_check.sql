
alter session set query_tag = 'Recon: utilities.reconcile_hub_reconciliation_errors';
insert into utilities.reconcile_hub_reconciliation_errors(tablename, source_tablename, loaddate, rundate, HUB_SKEY_SGTG_ncnt, HUB_SKEY_SGTG_scnt, HUB_SKEY_SGTG_dcnt, HUB_SKEY_SGTG_total, HUB_SKEY_SGTG_err, HUB_SKEY_SGTG_src_columns, HUB_SKEY_SGTG_tgt_columns, HUB_BKEY_SGTG_err, HUB_BKEY_SGTG_src_columns, HUB_BKEY_SGTG_tgt_columns)
with HUB_SKEY_SGTG as (
select count(*) HUB_SKEY_SGTG_err
     , array_construct('dv_hashkey_hub_account') as HUB_SKEY_SGTG_src_columns
     , array_construct('dv_hashkey_hub_account') as HUB_SKEY_SGTG_tgt_columns
from staged.card_masterfile sg 
where not exists
(select 1
 from rawvault.hub_account h
 where sg.dv_hashkey_hub_account = h.dv_hashkey_hub_account ))  
, HUB_BKEY_SGTG as (
select count(*) HUB_BKEY_SGTG_err
     , array_construct('dv_tenantid', ' dv_bkeycolcode_hub_account ', 'account_id') as HUB_BKEY_SGTG_src_columns
     , array_construct('dv_tenantid', 'dv_bkeycolcode', 'account_id') as HUB_BKEY_SGTG_tgt_columns
from staged.card_masterfile sg
where NOT EXISTS (select *
from rawvault.hub_account h 
where sg.account_id = h.account_id 
and sg.dv_tenantid = h.dv_tenantid
and sg.dv_bkeycolcode_hub_account = h.dv_bkeycolcode))
, Fetch_Hub_Stats as (
  select count(dv_hashkey_hub_account) HUB_SKEY_SGTG_ncnt
  from utilities.reconcile_hub_account)
, Fetch_Hub_Stats1 as (
  select count(dv_hashkey_hub_account) HUB_SKEY_SGTG_scnt
  , count(distinct dv_hashkey_hub_account) HUB_SKEY_SGTG_dcnt 
  from staged.card_masterfile)
, Fetch_Hub_Stats2 as (
  select count(dv_hashkey_hub_account) HUB_SKEY_SGTG_total
  from rawvault.hub_account)
 select 'hub_account' as tablename
 , 'staged.card_masterfile' as source_tablename
 , to_timestamp($my_loaddate) as loaddate
 , current_timestamp() as rundate
 , HUB_SKEY_SGTG_ncnt
 , HUB_SKEY_SGTG_scnt
 , HUB_SKEY_SGTG_dcnt
 , HUB_SKEY_SGTG_total
 , HUB_SKEY_SGTG_err
 , HUB_SKEY_SGTG_src_columns
 , HUB_SKEY_SGTG_tgt_columns
 , HUB_BKEY_SGTG_err
 , HUB_BKEY_SGTG_src_columns
 , HUB_BKEY_SGTG_tgt_columns
from HUB_SKEY_SGTG
, HUB_BKEY_SGTG
, Fetch_Hub_Stats
, Fetch_Hub_Stats1 
, Fetch_Hub_Stats2
; 

