
alter session set query_tag = 'Recon: utilities.reconcile_sat_duplicate_errors';
insert into utilities.reconcile_sat_duplicate_errors(tablename, source_tablename, loaddate, rundate, SAT_SKEY_DUPE_err, SAT_SKEY_DUPE_tgt_columns)
 select 'sat_card_masterfile' as tablename
     , 'staged.card_masterfile' as source_tablename
     , to_timestamp($my_loaddate) as loaddate
     , current_timestamp() as rundate
     , count(e) SAT_SKEY_DUPE_err 
     , array_construct('dv_hashkey_hub_account', 'dv_loaddate', 'dv_tenantid', 'dv_hashdiff') as SAT_SKEY_DUPE_tgt_columns
from (select count(*) e
           , dv_loaddate
      from rawvault.vc_sat_card_masterfile
      group by dv_hashkey_hub_account, dv_loaddate, dv_tenantid, dv_hashdiff
      having count(*) > 1) sq
      ; 

