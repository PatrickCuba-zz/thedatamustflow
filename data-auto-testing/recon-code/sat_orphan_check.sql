
alter session set query_tag = 'Recon: utilities.reconcile_sat_referential_errors';
insert into utilities.reconcile_sat_referential_errors(tablename, parent_tablename, loaddate, rundate, SAT_SKEY_ORPH_err)
select 'sat_card_masterfile' as tablename
  , 'hub_account' as parent_tablename
  , to_timestamp($my_loaddate) as loaddate
  , current_timestamp() as rundate
  , count(*) SAT_SKEY_ORPH_err
from utilities.orphancheck_sat_card_masterfile s 
where not exists
(select 1
 from rawvault.hub_account p
 where s.dv_hashkey_hub_account = p.dv_hashkey_hub_account )
and s.dv_recsource <> 'GHOST'
; 

