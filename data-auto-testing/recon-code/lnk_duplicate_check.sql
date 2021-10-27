
alter session set query_tag = 'Recon: utilities.reconcile_lnk_duplicate_errors';
 -- link tests 
insert into utilities.reconcile_lnk_duplicate_errors(tablename, source_tablename, loaddate, rundate, LNK_SKEY_DUPE_err, LNK_SKEY_DUPE_tgt_columns, LNK_HKEY_DUPE_err, LNK_HKEY_DUPE_tgt_columns)  
with LNK_SKEY_DUPE as (  
select count(e) LNK_SKEY_DUPE_err  
     , array_construct('dv_hashkey_lnk_account_customer') as LNK_SKEY_DUPE_tgt_columns  
from (select count(*) e  
      from rawvault.lnk_account_customer  
      group by dv_hashkey_lnk_account_customer  
having count(*) > 1) sq)  
, LNK_HKEY_DUPE as (  
select count(e) LNK_HKEY_DUPE_err  
     , array_construct('dv_hashkey_hub_account', 'dv_hashkey_hub_customer') as LNK_HKEY_DUPE_tgt_columns  
from (select count(*) e  
      from rawvault.lnk_account_customer
      group by dv_hashkey_hub_account, dv_hashkey_hub_customer
      having count(*)>1) sq)   
 select 'lnk_account_customer' as tablename  
 , 'staged.card_masterfile' as source_tablename  
 , to_timestamp($my_loaddate) as loaddate  
 , current_timestamp() as rundate  
 , LNK_SKEY_DUPE_err  
 , LNK_SKEY_DUPE_tgt_columns  
 , LNK_HKEY_DUPE_err  
 , LNK_HKEY_DUPE_tgt_columns  
from LNK_SKEY_DUPE  
, LNK_HKEY_DUPE  
; 

