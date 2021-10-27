
alter session set query_tag = 'Recon: utilities.reconcile_lnk_reconciliation_errors';
insert into utilities.reconcile_lnk_reconciliation_errors(tablename, source_tablename, loaddate, rundate, LNK_SKEY_SGTG_scnt, LNK_SKEY_SGTG_dcnt, LNK_SKEY_SGTG_ncnt, LNK_SKEY_SGTG_total, LNK_SKEY_SGTG_err, LNK_SKEY_SGTG_src_columns, LNK_SKEY_SGTG_tgt_columns, LNK_HKEY_SGTG_err, LNK_BKEY_SGTG_src_columns, LNK_HKEY_SGTG_tgt_columns)
with LNK_SKEY_SGTG as (
select count(*) LNK_SKEY_SGTG_err
     , array_construct('dv_hashkey_lnk_account_customer') as LNK_SKEY_SGTG_src_columns
     , array_construct('dv_hashkey_lnk_account_customer') as LNK_SKEY_SGTG_tgt_columns
from staged.card_masterfile sg 
where not exists
(select 1
 from rawvault.lnk_account_customer h
 where sg.dv_hashkey_lnk_account_customer = h.dv_hashkey_lnk_account_customer ))  
, LNK_BKEY_SGTG as (
select count(*) LNK_HKEY_SGTG_err
     , array_construct('dv_tenantid', 'dv_bkeycolcode_hub_account', 'account_id', 'dv_tenantid', 'dv_bkeycolcode_hub_customer', 'customer_id') as LNK_BKEY_SGTG_src_columns
     , array_construct('dv_tenantid', 'dv_hashkey_hub_account', 'dv_hashkey_hub_customer') as LNK_HKEY_SGTG_tgt_columns
from staged.card_masterfile sg
where NOT EXISTS (select *
from rawvault.lnk_account_customer h 
where sg.dv_hashkey_hub_account = h.dv_hashkey_hub_account 
and sg.dv_tenantid = h.dv_tenantid
and sg.dv_hashkey_hub_customer = h.dv_hashkey_hub_customer))
, Fetch_Lnk_Stats as (
  select count(dv_hashkey_lnk_account_customer) LNK_SKEY_SGTG_ncnt
  from utilities.reconcile_lnk_account_customer) 
, Fetch_LNK_Stats1 as (
  select count(dv_hashkey_lnk_account_customer) LNK_SKEY_SGTG_scnt
  , count(distinct dv_hashkey_lnk_account_customer) LNK_SKEY_SGTG_dcnt 
  from staged.card_masterfile)
, Fetch_LNK_Stats2 as (
  select count(dv_hashkey_lnk_account_customer) LNK_SKEY_SGTG_total
  from rawvault.lnk_account_customer)
 select 'lnk_account_customer' as tablename
 , 'staged.card_masterfile' as source_tablename
 , to_timestamp($my_loaddate) as loaddate
 , current_timestamp() as rundate
 , LNK_SKEY_SGTG_scnt
 , LNK_SKEY_SGTG_dcnt
 , LNK_SKEY_SGTG_ncnt
 , LNK_SKEY_SGTG_total
 , LNK_SKEY_SGTG_err
 , LNK_SKEY_SGTG_src_columns
 , LNK_SKEY_SGTG_tgt_columns
 , LNK_HKEY_SGTG_err
 , LNK_BKEY_SGTG_src_columns
 , LNK_HKEY_SGTG_tgt_columns
from LNK_SKEY_SGTG
, LNK_BKEY_SGTG
, Fetch_LNK_Stats
, Fetch_LNK_Stats1 
, Fetch_LNK_Stats2
; 

