Prune_Retention_Data ::==>>

SELECT * FROM NRMA_DATA_MASKING_PROP_TAB;

SELECT * FROM NRMA_DATA_MASKING_TRANS_TAB;


SELECT COUNT(*)
FROM  SIEBEL.S_ORG_EXT WHERE INT_ORG_FLG ='Y'; -- 4
	
SELECT COUNT(DISTINCT CON.ROW_ID) FROM SIEBEL.S_CONTACT CON, SIEBEL.S_USER SU
 WHERE CON.ROW_ID=SU.ROW_ID OR CON.EMP_FLG = 'Y'; --7050  

SELECT COUNT(*) FROM NRMA_DATA_RETENTION_SYS_TAB WHERE OBJ_NAME='S_ORG_EXT'; -- 4
SELECT COUNT(*) FROM NRMA_DATA_RETENTION_SYS_TAB WHERE OBJ_NAME='S_CONTACT'; -- 7050


SELECT  COUNT(DISTINCT P.PERSON_ID),P.PARTY_ID FROM SIEBEL.S_PARTY_PER P ,NRMA_ACCOUNT_DATA_PRUNE T 
 WHERE T.ORG_ID=P.PARTY_ID
 GROUP BY P.PARTY_ID HAVING COUNT(DISTINCT PERSON_ID) >1; -- 0

 
 SELECT  COUNT(DISTINCT ADDR.CONTACT_ID),ADDR.ADDR_PER_ID FROM SIEBEL.S_CON_ADDR ADDR, NRMA_ADDR_PER_DATA_PRUNE T 
WHERE ADDR.ADDR_PER_ID=T.ADDR_PER_ID
GROUP BY ADDR.ADDR_PER_ID HAVING COUNT(DISTINCT ADDR.CONTACT_ID) >1; -- 0

============================================================================================================
Prune_Data_Count :==>>

SELECT COUNT(*) FROM SIEBEL.S_CONTACT;
SELECT count(distinct CONTACT_ID) FROM NRMA_DATA_PRUNE_TEMP_TAB; -- 852357


SELECT COUNT(*) FROM SIEBEL.S_ORG_EXT;
SELECT COUNT(distinct ORG_ID) FROM NRMADID.NRMA_ACCOUNT_DATA_PRUNE; -- 1668259

SELECT COUNT(*) FROM SIEBEL.S_ADDR_PER;
SELECT COUNT(distinct ADDR_PER_ID) FROM NRMA_ADDR_PER_DATA_PRUNE;  -- 1179881

SELECT COUNT(*) FROM SIEBEL.S_ADDR_PER;
 SELECT COUNT(distinct ADDR_PER_ID) FROM NRMADID.NRMA_ADDR_PER_DATA_PRUNE; -- 1179881
 
 SELECT COUNT(*) FROM SIEBEL.S_CIF_CON_MAP;
 SELECT COUNT(distinct CIFCON_ID) FROM NRMA_CIF_CON_DATA_PRUNE; -- 1696713

  SELECT COUNT(*) FROM SIEBEL.S_CIF_ORG_MAP;
 SELECT COUNT(distinct CIFORG_ID) FROM NRMADID.NRMA_CIF_ORG_DATA_PRUNE; -- 3336501
 
  SELECT COUNT(*) FROM SIEBEL.S_CIF_CON_MAP;
 SELECT COUNT(distinct DQ_CON_ID) FROM NRMADID.NRMA_DQ_CON_KEY_DATA_PRUNE; -- 8533622
 
 SELECT COUNT(*) FROM SIEBEL.S_DQ_ORG_KEY; -- 614812
 SELECT COUNT(distinct DQ_ORG_ID) FROM NRMADID.NRMA_DQ_ORG_KEY_DATA_PRUNE; -- 0

=============================================================================================================

SELECT  COUNT(*),IF_ROW_STAT FROM SIEBEL.EIM_FN_CIF_SYST GROUP BY IF_ROW_STAT;


Pruning :==>>

SELECT  COUNT(*) FROM SIEBEL.S_BU B, SIEBEL.S_CIF_CON_MAP C, SIEBEL.S_CONTACT S,  SIEBEL.S_CIF_EXT_SYST E
WHERE  C.ROW_ID NOT IN(SELECT CIFCON_ID FROM NRMA_CIF_CON_DATA_RETENTION)
AND C.CON_ID = S.ROW_ID AND E.ROW_ID = C.CIF_EXT_SYST_ID AND S.BU_ID = B.ROW_ID AND ROWNUM<2;

SELECT  COUNT(*) FROM SIEBEL.S_BU B, SIEBEL.S_CIF_ORG_MAP C, SIEBEL.S_ORG_EXT O,  SIEBEL.S_CIF_EXT_SYST E
WHERE  C.ROW_ID NOT IN(SELECT CIFORG_ID FROM NRMA_CIF_ORG_DATA_RETENTION)
AND C.ORG_ID = O.ROW_ID AND E.ROW_ID = C.CIF_EXT_SYST_ID AND O.BU_ID = B.ROW_ID AND ROWNUM<2;


SELECT  COUNT(*) FROM SIEBEL.S_BU B, SIEBEL.S_DQ_CON_KEY D, SIEBEL.S_CONTACT S,SIEBEL.S_DQ_SYST Q, SIEBEL.S_PARTY P
WHERE  D.ROW_ID NOT IN(SELECT DQ_CON_ID FROM NRMA_DQ_CON_KEY_DATA_RETENTION)
AND D.CONTACT_ID = S.ROW_ID AND Q.ROW_ID = D.DQ_SYST_ID AND S.BU_ID = B.ROW_ID AND P.ROW_ID = S.PAR_ROW_ID AND 
P.PARTY_UID NOT IN(SELECT PARTY_UID FROM SIEBEL.EIM_CONTACT1) AND ROWNUM<2;

SELECT  COUNT(*) FROM SIEBEL.S_BU B, SIEBEL.S_DQ_ORG_KEY D, SIEBEL.S_ORG_EXT O,SIEBEL.S_DQ_SYST Q, SIEBEL.S_PARTY P
WHERE  D.ROW_ID NOT IN(SELECT DQ_ORG_ID FROM NRMA_DQ_ORG_KEY_DATA_RETENTION)
AND D.ACCNT_ID = O.ROW_ID AND Q.ROW_ID = D.DQ_SYST_ID AND O.BU_ID = B.ROW_ID AND P.ROW_ID = O.PAR_ROW_ID AND P.PARTY_UID 
NOT IN(SELECT PARTY_UID FROM SIEBEL.EIM_ACCOUNT1) AND ROWNUM<2;


SELECT  COUNT(*) FROM SIEBEL.S_ADDR_PER
WHERE ROW_ID NOT IN(SELECT DISTINCT ADDR_PER_ID FROM NRMA_ADDR_PER_DATA_RETENTION) 
AND ADDR_NAME NOT IN (SELECT AP_ADDR_NAME FROM SIEBEL.EIM_ADDR_PER)  AND ROWNUM<2;

SELECT COUNT(*) FROM SIEBEL.S_ORG_EXT ORG, SIEBEL.S_PARTY P, SIEBEL.S_BU B WHERE 
ORG.ROW_ID NOT IN (SELECT ORG_ID FROM NRMA_ACCOUNT_DATA_RETENTION) AND
ORG.ROW_ID NOT IN(SELECT OBJ_ID FROM NRMA_DATA_RETENTION_SYS_TAB WHERE OBJ_NAME='S_ORG_EXT') AND
ORG.PAR_ROW_ID=P.ROW_ID AND ORG.BU_ID=B.ROW_ID(+) AND P.PARTY_UID NOT IN(SELECT PARTY_UID FROM SIEBEL.EIM_ACCOUNT) AND ROWNUM<2;

SELECT  COUNT(*) FROM SIEBEL.S_CONTACT S, SIEBEL.S_PARTY P
WHERE  S.ROW_ID NOT IN(SELECT OBJ_ID FROM NRMA_DATA_RETENTION_SYS_TAB WHERE OBJ_NAME='S_CONTACT')
AND S.ROW_ID NOT IN(SELECT OCH_CON_ID FROM NRMA_DATA_RETENTION_TEMP_TAB where OCH_CON_ID is not null)
AND P.ROW_ID=S.PAR_ROW_ID AND P.PARTY_UID NOT IN(SELECT PARTY_UID FROM SIEBEL.EIM_CONTACT) AND ROWNUM<2;



=======================================================================================================================================
=======================================================================================================================================

Masking ::==>>

SELECT COUNT(*) FROM SIEBEL.S_ADDR_PER  WHERE ADDR_NAME NOT IN (SELECT AP_ADDR_NAME FROM SIEBEL.EIM_ADDR_PER) 
AND ROWNUM<2 AND LAST_UPD<'26-01-2019';

SELECT COUNT(*) FROM
SIEBEL.S_CONTACT_ATX ATX ,SIEBEL.S_PARTY P
WHERE DRIVER_LICENSE is not null AND ATX.PAR_ROW_ID NOT IN(SELECT OBJ_ID FROM NRMA_DATA_RETENTION_SYS_TAB WHERE OBJ_NAME='S_CONTACT')
AND P.ROW_ID=ATX.PAR_ROW_ID AND ATX.LAST_UPD<'26-01-2019' AND ROWNUM<2;

SELECT COUNT(*) FROM SIEBEL.S_CONTACT CON, SIEBEL.S_BU B,SIEBEL.S_PARTY P
WHERE
CON.ROW_ID NOT IN(SELECT OBJ_ID FROM NRMA_DATA_RETENTION_SYS_TAB WHERE OBJ_NAME='S_CONTACT')
AND P.PARTY_UID NOT IN(SELECT PARTY_UID FROM SIEBEL.EIM_CONTACT)
AND B.ROW_ID=CON.BU_ID AND P.ROW_ID=CON.PAR_ROW_ID AND CON.LAST_UPD<'26-01-2019' AND ROWNUM<2;

SELECT COUNT(*) FROM
SIEBEL.S_ORG_EXT ORG,SIEBEL.S_PARTY P,SIEBEL.S_BU BU
WHERE (MAIN_EMAIL_ADDR IS NOT NULL  OR MAIN_PH_NUM IS NOT NULL ) AND 
ORG.ROW_ID NOT IN(SELECT OBJ_ID FROM NRMA_DATA_RETENTION_SYS_TAB WHERE OBJ_NAME='S_ORG_EXT')
AND P.PARTY_UID NOT IN(SELECT PARTY_UID FROM SIEBEL.EIM_ACCOUNT) AND P.ROW_ID=ORG.PAR_ROW_ID
AND ORG.BU_ID=BU.ROW_ID AND ORG.LAST_UPD<'26-01-2019' AND ROWNUM<2;

SELECT COUNT(*) FROM SIEBEL.S_ORG_EXT ORG,SIEBEL.S_PARTY P  
WHERE ORG.ROW_ID NOT IN(SELECT OBJ_ID FROM NRMA_DATA_RETENTION_SYS_TAB WHERE OBJ_NAME='S_ORG_EXT') 
AND ORG.ROW_ID not in(select ACCNT_ROW_ID from ACCOUNT_UK_DATA_PRUNE) AND ORG.PAR_ROW_ID=P.ROW_ID AND
P.PARTY_UID NOT IN(SELECT PARTY_UID FROM SIEBEL.EIM_ORG_EXT_UK) AND ROWNUM<2;



