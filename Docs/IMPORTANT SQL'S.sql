awk '{ sub("\r$", ""); print }' NRMA_MASTER_ORDER_X_MASK.sh > NRMA_MASTER_ORDER_X_MASK_NEW.sh

SET SERVEROUTPUT ON

declare 

SQL_RET_CODE number(5);

BEGIN 

DBMS_OUTPUT.PUT_LINE('Hii');

NRMA_GMS_DELETE_EVT_ACT('10',SQL_RET_CODE);

DBMS_OUTPUT.PUT_LINE(SQL_RET_CODE);
END;
===========================================================================================================================

OU_NUM Reten Query ::==>>

select distinct org.ou_num as MEMBER_NO, r.contact_id as CONTACT_ID,con.csn
from NRMA_DATA_RETENTION_TAB r, siebel.s_contact con, siebel.s_party_per pr, siebel.s_org_ext org
where r.contact_id = con.row_id and
pr.party_id = org.par_row_id and
pr.person_id=r.contact_id and
r.member_no is not null and 
con.csn is not null;
--48152

===========================================================================================================================


select dbid, max(sample_time), min(sample_time) from DBA_HIST_ACTIVE_SESS_HISTORY group by dbid order by 3 desc;

SELECT * FROM DBA_SYS_PRIVS;
  
SELECT * FROM DBA_TAB_PRIVS;

select * from dba_role_privs where GRANTEE ='NRMA_DID';

Session ==>>

Checking session in Back end :
SELECT SID, Serial#, UserName, Status, SchemaName, Logon_Time
FROM V$Session
WHERE
Status='ACTIVE' AND
UserName IS NOT NULL;


   SELECT SID, Serial#, UserName, Status, SchemaName, Logon_Time, program,module,event
FROM V$Session
WHERE
Status in ('ACTIVE','INACTIVE') AND
UserName Like 'NRMADID'
--and osuser like 'innovaex.team'
order by logon_time desc;



To Kill the Session in Backend :
 ALTER SYSTEM KILL SESSION 'sid,serial#';
 ALTER SYSTEM KILL SESSION 'sid,serial#,@inst_id';
 
 ALTER SYSTEM KILL SESSION '39,20431';
 
 
 To check backend Running Queru in database :
  select sesion.sid,
sql_text
from v$sqltext sqltext, v$session sesion
where sesion.sql_hash_value = sqltext.hash_value
and sesion.sql_address = sqltext.address
and sesion.username='NRMADID'
order by sqltext.piece;



=========================================================================

Checking Table Space ==>>

    select b.tablespace_name, tbs_size SizeMb, a.free_space FreeMb
from  (select tablespace_name, round(sum(bytes)/1024/1024 ,2) as free_space
     from dba_free_space
       group by tablespace_name) a,
      (select tablespace_name, sum(bytes)/1024/1024 as tbs_size
       from dba_data_files
       group by tablespace_name) b
where a.tablespace_name(+)=b.tablespace_name;

select table_name, tablespace_name from all_tables where owner = 'NRMADID';

select table_name, tablespace_name from all_tables where owner = 'SIEBEL' AND TABLE_NAME='EIM_CONTACT';

===========================================================================

To Chec Blocked Sessions In DB ==>>

select blocking_session, 
   sid, 
   serial#, 
   wait_class,
   seconds_in_wait
from 
   v$session
where 
   blocking_session is not NULL
order by 
   blocking_session;
   
   
==============================================================================

Indexes ==>>

SELECT count(*),SEGMENT_TYPE FROM dba_segments WHERE OWNER = 'SIEBEL' and extents > 9
group by SEGMENT_TYPE;

SELECT *  from dba_indexes WHERE table_name = 'S_ORG_EXT';
select * from dba_ind_columns WHERE table_name = 'S_ORG_EXT';

select * from dba_ind_columns WHERE table_name = 'S_ORG_EXT' and COLUMN_NAME = 'PAR_ROW_ID';

SELECT owner, table_name   FROM dba_tables;
select * from SIEBEL.S_REPOSITORY;
SELECT * FROM dba_segments WHERE OWNER = 'SIEBEL';

select * from DBA_OBJECTS where OBJECT_NAME = 'S_ORG_EXT_V51'; -- PR_COMPETITOR_ID --PR_SHIP_OU_ID--PR_BL_OU_ID


ALTER INDEX index_name ON table_name DISABLE;

ALTER TABLE index_name ON table_name REBUILD;

select * from dba_ind_columns WHERE table_name = 'EIM_ACTIVITY' and COLUMN_NAME = 'PAR_ROW_ID';

Create index SIEBEL.EIM_AGREE_DEL_OPT on SIEBEL.EIM_AGREEMENT("IF_ROW_BATCH_NUM", "T_DOC_AGREE__EXS", "T_DELETED_ROW_ID");

Create index SIEBEL.EIM_ACTIVITY_DEL_OPT1 on SIEBEL.EIM_ACTIVITY("IF_ROW_BATCH_NUM", "T_EVT_ACT__EXS", "T_DELETED_ROW_ID", "IF_ROW_STAT_NUM");


Create index SIEBEL.EIM_ACCOUNT_DEL_OPT on SIEBEL.EIM_ACCOUNT("IF_ROW_BATCH_NUM", "T_PARTY__EXS", "T_DELETED_ROW_ID");

Create index SIEBEL.EIM_CONTACT_DEL_OPT on SIEBEL.EIM_CONTACT("IF_ROW_BATCH_NUM", "T_PARTY__EXS", "T_DELETED_ROW_ID");


Create index SIEBEL.S_ORG_EXT_V51 on SIEBEL.S_ORG_EXT("PR_BL_OU_ID");


select index_name from dba_indexes where table_name='EIM_AGREEMENT';


select * from dba_ind_columns WHERE INDEX_NAME='EIM_CONTACT_DEL_OPT' AND COLUMN_NAME='T_DOC_AGREE__EXS';


select index_name from dba_indexes where table_name='EIM_ORDER_ITEM';


select * from dba_ind_columns WHERE INDEX_NAME='T_DOC_AGREE__EXS';



Select the owner from dba_tables where table_name='<tablename>' ;

SELECT * FROM v$version;

select * from DBA_OBJECTS where OBJECT_NAME = 'S_ORG_EXT_V51';

EIM_CONTACT_DEL_OPT 
SELECT * FROM V$SYSTEM_PARAMETER;

select * from dba_ind_columns WHERE INDEX_NAME='EIM_CONTACT_DEL_OPT' AND COLUMN_NAME='';

Create index SIEBEL.S_ORG_EXT_V51 on SIEBEL.S_ORG_EXT("PR_BL_OU_ID");
Create index SIEBEL.S_ORG_EXT_DID1 on SIEBEL.S_ORG_EXT("PR_COMPETITOR_ID");
Create index SIEBEL.S_ORG_EXT_DID2 on SIEBEL.S_ORG_EXT("PR_SHIP_OU_ID");

DROP INDEX SIEBEL.S_ORDER_ITEM_FK;


select dbms_metadata.get_ddl('INDEX', S_ORDER_ITEM_U1, owner)
from all_indexes
where owner in ('SIEBEL');



select dbms_metadata.get_ddl('INDEX','S_ORDER_ITEM_U1','SIEBEL') from dual;



select dbms_metadata.get_ddl('INDEX','S_CAMP_CON_F5','SIEBEL') from dual;


'S_ORDER_U1','S_ORDER_U2','S_ORDER_P1','S_ORDER_F65','S_ORDER_F31','S_ORDER_F61','S_ORDER_F62'



select 'DROP INDEX SIEBEL.'||index_name||' ;'  from dba_INDEXES 
where table_name = 'S_ORDER' AND INDEX_NAME NOT IN 
('S_ORDER_U1','S_ORDER_U2','S_ORDER_P1','S_ORDER_F65','S_ORDER_F31','S_ORDER_F61','S_ORDER_F62');

'S_EVT_ACT_P1'',S_EVT_ACT_F22'',S_EVT_ACT_F17'',S_EVT_ACT_F11'',S_EVT_ACT_F87'',S_EVT_ACT_F23'',S_EVT_ACT_F62'',TODO_APPT_ID'',S_EVT_ACT_U1'

 CREATE INDEX "SIEBEL"."S_CAMP_CON_F5" ON "SIEBEL"."S_CAMP_CON" ("CON_PER_ID") 
  PCTFREE 20 INITRANS 16 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "INDX" ;

=====================================================================================================

Executing DB Stats ==>>


sqlplus $DBA_USERNAME/$DBA_PASSWORD@$SCHEMA


exec dbms_stats.gather_schema_stats( 
ownname          => 'SIEBEL', 
tabname          => 'EIM_ORDER_ITEM', 
cascade          => true, 
estimate_percent => 10, 
method_opt       => 'for all columns size 1', 
granularity      => 'ALL'
degree           => 1 
);


"run task for comp GenTrig with EXEC=True,Remove=True,privuser=$priv_user,privuserpass=$priv_user_pass, ErrorFlags=1, SQLFlags=8, TraceFlags=3"

"run task for comp GenTrig with EXEC=True,Remove=False,privuser=$priv_user,privuserpass=$priv_user_pass, ErrorFlags=1, SQLFlags=8, TraceFlags=3"

select owner,table_name,last_analyzed, global_stats
from dba_tables where table_name='';


select * from DBA_TRIGGERS where table_name='SIEBEL';

DROP USER NRMADID cascade;

=================================================================================================

To create duplicate table and inserting the data ==>>

create table NRMA_EIM_ADDR_PER TABLESPACE DATA as (select * from SIEBEL.eim_addr_per where 0=1);



create table NRMA_EIM_AGREEMENT as (select * from SIEBEL.eim_AGREEMENT where 0=1);


INSERT INTO NRMA_EIM_SRV_REQ as SELECT * from SIEBEL.eim_SRV_REQ where if_row_stat IN ('NO_SUCH_RECORD','ROLLBACK');


SELECT COUNT(*) FROM NRMA_EIM_ORDER;

SELECT count(*) from SIEBEL.eim_order where if_row_stat IN ('NO_SUCH_RECORD','ROLLBACK');

create table table_name as select * from table_name;

===============================================================================

SELECT * FROM V$SQL V where  to_date(v.FIRST_LOAD_TIME,'YYYY-MM-DD hh24:mi:ss') > sysdate - 12 AND 
SQL_TEXT LIKE 'DELETE FROM SIEBEL.S_SRV_REQ%'; --6sp08f4266a0q SQL_ID

======================================================================================


SELECT segment_name,segment_type,tablespace_name,extents
FROM dba_segments
WHERE owner ='SIEBEL'
and extents > 9  AND SEGMENT_NAME LIKE 'EIM_ORDER%';


SELECT segment_name,segment_type,tablespace_name,extents
FROM dba_segments
WHERE owner ='SIEBEL'
and extents > 9  AND SEGMENT_NAME LIKE '%ORDER%' AND SEGMENT_TYPE='TABLE';

============================================================

Best_Practices For Deletion through EIM ====>>

1. Truncate EIM Tables
2. Batch size no more than 5000
3. DB Stats are updated after data load.
4. index  
5. ErrorFlags=1, SQLFlags=8, TraceFlags=3

CREATE TABLE NRMA_ORDER_FK_DATA_RETENTION(ORD_ROW_ID VARCHAR2(30));
CREATE TABLE ACCOUNT_UK_DATA_RETEN ( ACCNT_ROW_ID VARCHAR2(30));

========================================================================================

Create index SIEBEL.EIM_ACTIVITY_DEL_OPT1 on SIEBEL.EIM_ACTIVITY("IF_ROW_BATCH_NUM", "T_EVT_ACT__EXS", "T_DELETED_ROW_ID", "IF_ROW_STAT_NUM");

select * from dba_ind_columns WHERE INDEX_NAME='EIM_CONTACT_DEL_OPT' AND COLUMN_NAME='';

select COUNT(*) from dba_ind_columns WHERE index_name = 'EIM_SR_DEL_OPT';


select * from dba_ind_columns WHERE index_name = 'EIM_ORDER_DEL_OPT';


select * from dba_ind_columns WHERE index_name = 'S_ORDER_ITEM_FK';

select * from dba_INDEXES where table_name='EIM_ACTIVITY';


Create index SIEBEL.EIM_AGREE_DEL_OPT on SIEBEL.EIM_AGREEMENT("IF_ROW_BATCH_NUM", "T_DOC_AGREE__EXS", "T_DELETED_ROW_ID");

Create index SIEBEL.EIM_SR_DEL_OPT on SIEBEL.EIM_SRV_REQ("IF_ROW_BATCH_NUM", "T_SRV_REQ__EXS", "T_DELETED_ROW_ID");

Create index SIEBEL.EIM_ACTIVITY_DEL_OPT on SIEBEL.EIM_ACTIVITY("IF_ROW_BATCH_NUM", "T_EVT_ACT__EXS", "T_DELETED_ROW_ID");
S_EVT_ACT_FK_INDX
PAR_EVT_ID
ACT_TMPL_ID
APPT_REPT_APPT_ID
PREV_ACT_ID

Create index SIEBEL.EIM_ACCOUNT_DEL_OPT on SIEBEL.EIM_ACCOUNT("IF_ROW_BATCH_NUM", "T_PARTY__EXS", "T_DELETED_ROW_ID");

Create index SIEBEL.EIM_CONTACT_DEL_OPT on SIEBEL.EIM_CONTACT("IF_ROW_BATCH_NUM", "T_PARTY__EXS", "T_DELETED_ROW_ID");

Create index SIEBEL.EIM_ORDER_ITEM_DEL_OPT on SIEBEL.EIM_ORDER_ITEM("IF_ROW_BATCH_NUM", "T_DELETED_ROW_ID", "T_ORDERITEM__EXS");

Create index SIEBEL.EIM_ORDER_ITEM_DEL_OPT on SIEBEL.EIM_ORDER_ITEM("IF_ROW_BATCH_NUM", "T_ORDERITEM__EXS", "T_DELETED_ROW_ID");

--T_DELETED_ROW_ID
Create index SIEBEL.EIM_ORDER_ITEM_DEL_OPT1 on SIEBEL.EIM_ORDER_ITEM("IF_ROW_BATCH_NUM", "IF_ROW_STAT_NUM", "T_DELETED_ROW_ID", "T_ORDERITEM__EXS");


Create index SIEBEL.EIM_ORDER_ITEM_DEL_OPT on SIEBEL.EIM_ORDER_ITEM("IF_ROW_STAT_NUM", "T_DELETED_ROW_ID", "T_ORDERITEM__EXS");

Create index SIEBEL.EIM_ASSET_DEL_OPT1 on SIEBEL.EIM_ASSET("IF_ROW_BATCH_NUM", "IF_ROW_STAT_NUM", "T_DELETED_ROW_ID", "T_ASSET__EXS");

Create index SIEBEL.EIM_ASSET_XA_OPT on SIEBEL.S_ASSET_XA("ASSET_ID");


Create index SIEBEL.S_ORDER_ITEM_FK on SIEBEL.S_ORDER_ITEM("ORDER_ID", "BASE_ITEM_ID", "ORIG_ORDER_ITEM_ID", "PAR_ORDER_ITEM_ID", "PREV_ITEM_REV_ID", 
"ROOT_ORDER_ITEM_ID");

--LN_NUM,T_ORDERITEM_ORDERI,IF_ROW_BATCH_NUM,IF_ROW_STAT_NUM,T_ORDERITEM__STA

Create index SIEBEL.S_ORDER_ITEM_FK1 on SIEBEL.EIM_ORDER_ITEM("LN_NUM", "T_ORDERITEM_ORDERI", "IF_ROW_BATCH_NUM", "IF_ROW_STAT_NUM", 
"T_ORDERITEM__STA");


Create index SIEBEL.EIM_ADDR_PER_DEL_OPT on SIEBEL.EIM_ADDR_PER("IF_ROW_BATCH_NUM",  "T_ADDR_PER__EXS", "IF_ROW_STAT_NUM", "T_DELETED_ROW_ID");


Create index SIEBEL.EIM_ADDR_PER_UPDATE_OPT on SIEBEL.EIM_ADDR_PER("IF_ROW_BATCH_NUM",  "T_ADDR_PER__EXS", "IF_ROW_STAT_NUM", "T_ADDR_PER__STA");


Create index SIEBEL.EIM_ASSET_DEL_OPT on SIEBEL.EIM_ASSET("IF_ROW_BATCH_NUM", "T_ASSET__EXS", "T_DELETED_ROW_ID");

PR_BL_OU_ID

Create index SIEBEL.S_ORG_EXT_DID1 on SIEBEL.S_ORG_EXT("PR_BL_OU_ID")
Create index SIEBEL.S_ORG_EXT_DID1 on SIEBEL.S_ORG_EXT("PR_SHIP_OU_ID")
Create index SIEBEL.S_ORG_EXT_DID3 on SIEBEL.S_ORG_EXT("PR_COMPETITOR_ID");

SELECT COUNT(*) FROM SIEBEL.S_ORDER_ITEM_XA; ---- 282820926


Create index SIEBEL.EIM_ORDER_ITEM_T01 on SIEBEL.EIM_ORDER_ITEM("IF_ROW_STAT_NUM", "T_DELETED_ROW_ID");



==================================================================================================================

Masking ======>>>>>

Create index SIEBEL.EIM_ADDR_PER_UPDATE_OPT on SIEBEL.EIM_ADDR_PER("IF_ROW_BATCH_NUM", "T_ADDR_PER__EXS", "IF_ROW_STAT_NUM", "T_ADDR_PER__STA");

Create index SIEBEL.EIM_ADDR_PER_UPDATE_OPT1 on SIEBEL.EIM_ADDR_PER("IF_ROW_BATCH_NUM",  "T_ADDR_PER__EXS","T_ADDR_PER__UNQ", "IF_ROW_STAT_NUM", "T_ADDR_PER__STA");

Create index SIEBEL.S_CONTACT_X_DID on 
SIEBEL.S_CONTACT_X("ATTRIB_43", "ATTRIB_36", "ATTRIB_02", "ATTRIB_41", "PAR_ROW_ID", "LAST_UPD");

Create index SIEBEL.S_CONTACT_ATX_DID on 
SIEBEL.S_CONTACT_ATX("DRIVER_LICENSE", "PAR_ROW_ID", "LAST_UPD");

Create index SIEBEL.EIM_CONTACT_UPDATE_OPT on 
SIEBEL.EIM_CONTACT("IF_ROW_BATCH_NUM", "T_PARTY__EXS", "T_PARTY__STA","IF_ROW_STAT_NUM");

Create index SIEBEL.S_ORG_EXT_DID_UPDATE on SIEBEL.S_ORG_EXT("MAIN_EMAIL_ADDR",
"X_LEGAL_ENTITY_NAME", "MAIN_PH_NUM", "ANS_SRVC_PH_NUM", "X_EMAIL_UNSUBCRIBE_DT", "LAST_UPD", "ROW_ID", "BU_ID");

Create index SIEBEL.S_ORG_EXT_FNX_DID_UPDATE on SIEBEL.S_ORG_EXT_FNX("BRLOC_ATTRIB01",
"TECH_IMP_CD", "NPI_NUM", "PAR_ROW_ID", "LAST_UPD");


Create index SIEBEL.EIM_ORG_EXT_UK_UPDATE_OPT on SIEBEL.EIM_ORG_EXT_UK
("IF_ROW_BATCH_NUM", "T_ORG_EXT__EXS", "T_ORG_EXT__UNQ", "T_ORG_EXT__STA", "IF_ROW_STAT_NUM" );


--LN_NUM,T_ORDERITEM_ORDERI,IF_ROW_BATCH_NUM,IF_ROW_STAT_NUM,T_ORDERITEM__STA

Create index SIEBEL.S_ORDER_ITEM_FK1 on SIEBEL.EIM_ORDER_ITEM("LN_NUM", "T_ORDERITEM_ORDERI", "IF_ROW_BATCH_NUM", "IF_ROW_STAT_NUM", 
"T_ORDERITEM__STA");

S_ORG_EXT_M23   ==> Need to remove from create index;

===========================================================================================================================================================

SELECT count(*) FROM SIEBEL.S_ORG_EXT WHERE OU_TYPE_CD IN('Supplier','Supplier Site')

select distinct org.ou_num as MEMBER_NO, r.contact_id as CONTACT_ID,con.csn
from NRMA_DATA_RETENTION_TAB r, siebel.s_contact con, siebel.s_party_per pr, siebel.s_org_ext org
where r.contact_id = con.row_id and
pr.party_id = org.par_row_id and
pr.person_id=r.contact_id and
r.member_no is not null and 
con.csn is not null;

select distinct org.ou_num as MEMBER_NO, r.contact_id as CONTACT_ID,con.csn
from NRMA_DATA_RETENTION_TAB r, siebel.s_contact con, siebel.s_party_per pr, siebel.s_org_ext org
where r.contact_id = con.row_id and
pr.party_id = org.par_row_id and
pr.person_id=r.contact_id and
r.member_no is not null; 

================================================================================

To check Suppliers assets and assets for suppliers ==>>

SELECT count(*) FROM SIEBEL.S_ORG_EXT WHERE OU_TYPE_CD IN('Supplier','Supplier Site'); --25733


select count(a.asset_num) from siebel.s_asset a,siebel.s_org_ext org 
where a.owner_accnt_id=org.row_id and org.OU_TYPE_CD IN('Supplier','Supplier Site');


select count(a.asset_num) from siebel.s_asset a,siebel.s_org_ext org 
where a.SERV_ACCT_ID=org.row_id and org.OU_TYPE_CD IN('Supplier','Supplier Site');

===================================================================================

House hold Contacts/Accounts:==>>

Primary Contact Id 

select org.X_JOINT_ACCOUNT, org.OU_TYPE_CD, count(org.row_id),count(part.person_id) from siebel.s_org_ext org, siebel.s_contact con, siebel.S_PARTY_PER part 
where org.row_id=part.party_id	
and con.row_id=part.person_id	
and org.pr_con_id = part.person_id	
and org.X_JOINT_ACCOUNT='Y' group by org.X_JOINT_ACCOUNT,org.OU_TYPE_CD;	


Secondary Contact Id	

select org.X_JOINT_ACCOUNT, org.OU_TYPE_CD, count(org.row_id),count(part.person_id) from siebel.s_org_ext org, siebel.s_contact con, siebel.S_PARTY_PER part 
where org.row_id=part.party_id	
and con.row_id=part.person_id	
and org.pr_con_id <> part.person_id	
and org.X_JOINT_ACCOUNT='Y' group by org.X_JOINT_ACCOUNT,org.OU_TYPE_CD;	


select count(*) from siebel.s_org_ext where X_JOINT_ACCOUNT='Y'; --599986
