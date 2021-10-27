
/* ------------------------------------------------------------------------------- */
/*                               TEST TABLES AND STREAMS
/* ------------------------------------------------------------------------------- */

-- 1.3.3 Test Framework

-- 1.3.3.1 TABLES
-- 1.3.3.1.1 reconcile_hub_duplicate_errors
create or replace transient table utilities.reconcile_hub_duplicate_errors 
(tablename varchar(200) not null
 , source_tablename varchar(200) not null
 , loaddate datetime not null
 , rundate datetime not null
 , HUB_SKEY_DUPE_err int not null -- dupe check
 , HUB_SKEY_DUPE_tgt_columns array not null
 , HUB_BKEY_DUPE_err int not null -- dupe check
 , HUB_BKEY_DUPE_tgt_columns array not null
 , constraint pk_reconcile_hub_duplicate_errors primary key (tablename, source_tablename, loaddate, rundate) enforced
)
cluster by (loaddate, tablename)
;

-- 1.3.3.1.2 reconcile_hub_reconciliation_errors
create or replace transient table utilities.reconcile_hub_reconciliation_errors 
(tablename varchar(200) not null
 , source_tablename varchar(200) not null
 , loaddate datetime not null
 , rundate datetime not null
 , HUB_SKEY_SGTG_ncnt int not null -- new count
 , HUB_SKEY_SGTG_scnt int not null -- staged count
 , HUB_SKEY_SGTG_dcnt int not null -- distinct count
 , HUB_SKEY_SGTG_total int not null -- target count
 , HUB_SKEY_SGTG_err int not null -- stg to tgt check
 , HUB_SKEY_SGTG_src_columns array not null
 , HUB_SKEY_SGTG_tgt_columns array not null
 , HUB_BKEY_SGTG_err int not null -- stg to tgt check
 , HUB_BKEY_SGTG_src_columns array not null
 , HUB_BKEY_SGTG_tgt_columns array not null
 , constraint pk_reconcile_hub_reconciliation_errors primary key (tablename, source_tablename, loaddate, rundate, HUB_SKEY_SGTG_src_columns) enforced
)
cluster by (loaddate, tablename)
;
 
-- 1.3.3.1.3 reconcile_sat_duplicate_errors
create or replace transient table utilities.reconcile_sat_duplicate_errors
(tablename varchar(200) not null
 , source_tablename varchar(200) not null
 , loaddate datetime not null
 , rundate datetime not null
 , SAT_SKEY_DUPE_err int not null -- dupe check
 , SAT_SKEY_DUPE_tgt_columns array not null
 , constraint pk_reconcile_sat_duplicate_errors primary key (tablename, source_tablename, loaddate, rundate) enforced
)
cluster by (loaddate, tablename)
;

-- 1.3.3.1.4 reconcile_sat_reconciliation_errors
create or replace transient table utilities.reconcile_sat_reconciliation_errors
(tablename varchar(200) not null
 , source_tablename varchar(200) not null
 , loaddate datetime not null
 , rundate datetime not null
 , SAT_SKEY_SGTG_ncnt int not null -- new count
 , SAT_SKEY_SGTG_scnt int not null -- staged count
 , SAT_SKEY_SGTG_dcnt int not null -- distinct count
 , SAT_SKEY_SGTG_total int not null -- satellite count
 , SAT_SKEY_SGTG_err int not null -- stg to tgt check
 , SAT_SKEY_SGTG_src_columns array not null
 , SAT_SKEY_SGTG_tgt_columns array not null
 , SAT_HDIF_SGTG_err int not null -- stg to tgt check
 , SAT_HDIF_SGTG_src_columns array not null
 , SAT_HDIF_SGTG_src_hdiff_columns array not null
 , SAT_HDIF_SGTG_tgt_columns array not null
 , constraint pk_reconcile_sat_reconciliation_errors primary key (tablename, source_tablename, loaddate, rundate, SAT_SKEY_SGTG_src_columns) enforced
)
cluster by (loaddate, tablename)
;

-- 1.3.3.1.5 reconcile_sat_referential_errors
create or replace transient table utilities.reconcile_sat_referential_errors
(tablename varchar(200) not null
 , parent_tablename varchar(200) not null
 , loaddate datetime not null
 , rundate datetime not null
 , SAT_SKEY_ORPH_err int not null -- orphan check
 , constraint pk_reconcile_sat_referential_errors primary key (tablename, parent_tablename, loaddate, rundate) enforced
)
cluster by (loaddate, tablename)
;

-- 1.3.3.1.6 reconcile_lnk_duplicate_errors
create or replace transient table utilities.reconcile_lnk_duplicate_errors 
(tablename varchar(200) not null
 , source_tablename varchar(200) not null
 , loaddate datetime not null
 , rundate datetime not null
 , LNK_SKEY_DUPE_err int not null -- dupe check
 , LNK_SKEY_DUPE_tgt_columns array not null
 , LNK_HKEY_DUPE_err int not null -- dupe check
 , LNK_HKEY_DUPE_tgt_columns array not null
 , constraint pk_reconcile_lnk_duplicate_errors primary key (tablename, source_tablename, loaddate, rundate) enforced
)
cluster by (loaddate, tablename)
;

-- 1.3.3.1.7 reconcile_lnk_reconciliation_errors
create or replace transient table utilities.reconcile_lnk_reconciliation_errors
(tablename varchar(200) not null
 , source_tablename varchar(200) not null
 , loaddate datetime not null
 , rundate datetime not null
 , LNK_SKEY_SGTG_scnt int not null -- staged count
 , LNK_SKEY_SGTG_dcnt int not null -- distinct count
 , LNK_SKEY_SGTG_ncnt int not null -- new count
 , LNK_SKEY_SGTG_total int not null -- staged count
 , LNK_SKEY_SGTG_err int not null -- stg to tgt check
 , LNK_SKEY_SGTG_src_columns array not null
 , LNK_SKEY_SGTG_tgt_columns array not null
 , LNK_HKEY_SGTG_err int not null -- stg to tgt check
 , LNK_BKEY_SGTG_src_columns array not null
 , LNK_HKEY_SGTG_tgt_columns array not null
 , constraint pk_reconcile_lnk_reconciliation_errors primary key (tablename, source_tablename, loaddate, rundate, LNK_SKEY_SGTG_src_columns) enforced
)
cluster by (loaddate, tablename)
;

-- 1.3.3.1.8 reconcile_lnk_referential_errors
create or replace transient table utilities.reconcile_lnk_referential_errors
(tablename varchar(200) not null
 , parent_tablename varchar(200) not null
 , link_columnname array not null
 , loaddate datetime not null
 , rundate datetime not null
 , LNK_SKEY_ORPH_err int not null -- orphan check
 , constraint pk_reconcile_lnk_referential_errors primary key (tablename, parent_tablename, loaddate, rundate) enforced
)
cluster by (loaddate, tablename)
;


-- 1.3.3 Test Framework
-- 1.3.3.2 STREAMS
-- 1.3.3.2.1 HUBS-RECON
--a. these streams must be APPEND ONNLY, Data Vault 2.0 is an INSERT-ONLNY methodology, the same applies to this test framework design

create or replace stream utilities.reconcile_hub_account
on table datavault.hub_account
append_only = true
;

create or replace stream utilities.reconcile_hub_customer
on table datavault.hub_customer
append_only = true
;

-- 1.3.3.2.2 SATS-RECON-ORPHANCHECK
create or replace stream utilities.orphancheck_sat_card_masterfile
on table datavault.sat_card_masterfile
append_only = true
;

create or replace stream utilities.reconcile_sat_card_masterfile
on table datavault.sat_card_masterfile
append_only = true
;

create or replace stream utilities.orphancheck_sat_card_balancecategories
on table datavault.sat_card_balancecategories
append_only = true
;

create or replace stream utilities.reconcile_sat_card_balancecategories
on table datavault.sat_card_balancecategories
append_only = true
;

create or replace stream utilities.orphancheck_sat_card_transaction_header
on table datavault.sat_card_transaction_header
append_only = true
;

create or replace stream utilities.reconcile_sat_card_transaction_header
on table datavault.sat_card_transaction_header
append_only = true
;

create or replace stream utilities.orphancheck_sat_bv_account_card_summary
on table datavault.sat_bv_account_card_summary
append_only = true
;

create or replace stream utilities.reconcile_sat_bv_account_card_summary
on table datavault.sat_bv_account_card_summary
append_only = true
;

-- 1.3.3.2.3 LINKS-RECON-ORPHANCHECK
create or replace stream utilities.reconcile_lnk_account_customer
on table datavault.lnk_account_customer
append_only = true
;

create or replace stream utilities.orphancheck_lnk_account_customer_dv_hashkey_hub_account
on table datavault.lnk_account_customer
append_only = true
;

create or replace stream utilities.orphancheck_lnk_account_customer_dv_hashkey_hub_customer
on table datavault.lnk_account_customer
append_only = true
;