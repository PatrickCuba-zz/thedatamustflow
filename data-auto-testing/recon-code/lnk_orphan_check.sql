
alter session set query_tag = 'Recon: utilities.reconcile_lnk_referential_errors';
 -- link orph checks
insert into utilities.reconcile_lnk_referential_errors(tablename, parent_tablename, link_columnname, loaddate, rundate, LNK_SKEY_ORPH_err) 
select 'lnk_account_customer' as tablename
  , 'hub_account' as parent_tablename
  , array_construct('dv_hashkey_hub_account') as link_columnname
  , to_timestamp($my_loaddate) as loaddate
  , current_timestamp() as rundate
  , count(*) LNK_SKEY_ORPH_err
from utilities.orphancheck_lnk_account_customer_dv_hashkey_hub_account s 
where not exists
(select 1
 from rawvault.hub_account p
 where s.dv_hashkey_hub_account = p.dv_hashkey_hub_account )
; 

