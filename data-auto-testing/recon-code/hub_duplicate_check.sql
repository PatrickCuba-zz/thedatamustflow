
alter session set query_tag = 'Recon: utilities.reconcile_hub_duplicate_errors';
insert into utilities.reconcile_hub_duplicate_errors(tablename, source_tablename, loaddate, rundate, HUB_SKEY_DUPE_err, HUB_SKEY_DUPE_tgt_columns, HUB_BKEY_DUPE_err, HUB_BKEY_DUPE_tgt_columns) 
with HUB_SKEY_DUPE as (
select count(e) HUB_SKEY_DUPE_err
     , array_construct('dv_hashkey_hub_account') as HUB_SKEY_DUPE_tgt_columns
from (select count(*) e
      from rawvault.hub_account
      group by dv_hashkey_hub_account
having count(*) > 1) sq)
, HUB_BKEY_DUPE as (
select count(e) HUB_BKEY_DUPE_err
     , array_construct('dv_tenantid', 'dv_bkeycolcode', 'account_id') as HUB_BKEY_DUPE_tgt_columns
from (select count(*) e
      from rawvault.hub_account
      group by dv_tenantid, dv_bkeycolcode, account_id
      having count(*)>1) sq) 
 select 'hub_account' as tablename
 , 'staged.card_masterfile' as source_tablename
 , to_timestamp($my_loaddate) as loaddate
 , current_timestamp() as rundate
 , HUB_SKEY_DUPE_err
 , HUB_SKEY_DUPE_tgt_columns
 , HUB_BKEY_DUPE_err
 , HUB_BKEY_DUPE_tgt_columns
from HUB_SKEY_DUPE
, HUB_BKEY_DUPE
; 
