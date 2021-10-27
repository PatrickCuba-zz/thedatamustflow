
alter session set query_tag = 'Recon: utilities.reconcile_sat_reconciliation_errors';
insert into utilities.reconcile_sat_reconciliation_errors(tablename, source_tablename, loaddate, rundate, SAT_SKEY_SGTG_ncnt, SAT_SKEY_SGTG_scnt, SAT_SKEY_SGTG_dcnt, SAT_SKEY_SGTG_total, SAT_SKEY_SGTG_err, SAT_SKEY_SGTG_src_columns, SAT_SKEY_SGTG_tgt_columns, SAT_HDIF_SGTG_err, SAT_HDIF_SGTG_src_columns, SAT_HDIF_SGTG_src_hdiff_columns, SAT_HDIF_SGTG_tgt_columns)
with SAT_SKEY_SGTG as (
select count(*) SAT_SKEY_SGTG_err
     , array_construct('dv_hashkey_hub_account') as SAT_SKEY_SGTG_src_columns
     , array_construct('dv_hashkey_hub_account') as SAT_SKEY_SGTG_tgt_columns
from staged.card_masterfile sg 
where not exists
(select 1
 from rawvault.vc_sat_card_masterfile s
 where sg.dv_hashkey_hub_account = s.dv_hashkey_hub_account ))
, SAT_HDIF_SGTG as (
select count(*) SAT_HDIF_SGTG_err
     , array_construct('dv_hashkey_hub_account', 'dv_hashdiff_sat_card_masterfile', 'dv_tenantid') as SAT_HDIF_SGTG_src_columns
     , array_construct('dv_hashkey_hub_account', 'dv_hashdiff', 'dv_tenantid') as SAT_HDIF_SGTG_tgt_columns
from staged.card_masterfile sg 
where NOT EXISTS (select *
from rawvault.vc_sat_card_masterfile s -- uses current record for the satellite
where sg.dv_hashkey_hub_account = s.dv_hashkey_hub_account
and sg.dv_hashdiff_sat_card_masterfile = s.dv_hashdiff
and sg.dv_tenantid = s.dv_tenantid))
, Fetch_Sat_Stats as (
  select count(dv_hashkey_hub_account, dv_loaddate) SAT_SKEY_SGTG_ncnt
  from utilities.reconcile_sat_card_masterfile)
, Fetch_Sat_Stats1 as (
  select count(dv_hashkey_hub_account, dv_loaddate) SAT_SKEY_SGTG_scnt
    , count(distinct dv_hashkey_hub_account, dv_loaddate) SAT_SKEY_SGTG_dcnt
  from staged.card_masterfile)
, Fetch_Sat_Stats2 as (
  select count(*) SAT_SKEY_SGTG_total
  from rawvault.sat_card_masterfile)
 select 'sat_card_masterfile' as tablename
 , 'staged.card_masterfile' as source_tablename
 , to_timestamp($my_loaddate) as loaddate
 , current_timestamp() as rundate
 , SAT_SKEY_SGTG_ncnt
 , SAT_SKEY_SGTG_scnt
 , SAT_SKEY_SGTG_dcnt
 , SAT_SKEY_SGTG_total
 , SAT_SKEY_SGTG_err
 , SAT_SKEY_SGTG_src_columns
 , SAT_SKEY_SGTG_tgt_columns
 , SAT_HDIF_SGTG_err
 , SAT_HDIF_SGTG_src_columns
 , array_construct('card_type', 'card_balance', 'card_status', 'credit_limit') as SAT_HDIF_SGTG_src_hdiff_column
 , SAT_HDIF_SGTG_tgt_columns
from SAT_SKEY_SGTG
, SAT_HDIF_SGTG
, Fetch_Sat_Stats
, Fetch_Sat_Stats1
, Fetch_Sat_Stats2
; 

