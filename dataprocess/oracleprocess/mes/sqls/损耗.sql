SELECT WO,LOT,DEVICE,MATERIALNO,OUTQTY,MLOTCONSUMEQTY,UPDATETIME, EQUIPMENT, OPERATION, FABCODE
FROM (
SELECT DISTINCT u.MMS_EQP_MLOT_USELOG_SID, u.LOT, u.OPERATION, u.EQUIPMENT, u.MLOT
  , u.MATERIALNO, to_char(u.MATERIALTYPE), u.LOTQTY, u.USEQTY
  , u.USERATE, u.LOSERATE, u.MLOTCONSUMEQTY, u.LINKSID, u.RULENAME
  , to_char(u.CALFLAG), u.USERID, u.UPDATETIME
  , h.NEWQUANTITY AS OUTQTY, l.DEVICE, l.DEVICE_DESCR, l.WO, mt.WAREHOUSE
  , mt.BOMID, l.BOM_REVISION, l.FABCODE
 FROM MES.MES_MMS_EQP_MLOT_USELOG u
 INNER JOIN MES.MES_WIP_HIST h ON u.LINKSID = h.LINKSID
 AND h.transaction = 'CheckOut'
 AND u.LOT = h.LOT 
 INNER JOIN MES.view_lotlist_main l ON h.LOT = l.LOT 
  INNER JOIN MES.view_mmslotlist_main mt ON u.MLOT = mt.MLOT 
 UNION
 SELECT m.MMS_HIST_SID AS MMS_EQP_MLOT_USELOG_SID, m.LOT, m.OPERATION, m.EQUIPMENT, m.MLOT
  , m.MATERIALNO, NULL AS MATERIALTYPE, l.QUANTITY AS LOTQTY, m.OLDQTY - m.NEWQTY AS USEQTY
  , 1 AS USERATE, 0 AS LOSERATE, m.OLDQTY - m.NEWQTY AS MLOTCONSUMEQTY, m.LINKSID
  , m.RULENAME, 'Y' AS CALFLAG, m.USERID, m.TRANSACTIONTIME AS UPDATETIME, l.QUANTITY AS OUTQTY
  , l.DEVICE, l.DEVICE_DESCR, l.WO, mt.WAREHOUSE, mt.BOMID
  , l.BOM_REVISION, l.FABCODE
 FROM MES.MES_MMS_HIST m
 INNER JOIN MES.view_lotlist_main l ON m.LOT = l.LOT 
  INNER JOIN MES.view_mmslotlist_main mt ON m.MLOT = mt.MLOT 
 WHERE m.transaction = 'MMSConsume'
  AND m.RULENAME = 'EQPUnloadMaterial'
 UNION
 SELECT m.MMS_HIST_SID AS MMS_EQP_MLOT_USELOG_SID, m.LOT, m.OPERATION, m.EQUIPMENT, m.MLOT
  , m.MATERIALNO, NULL AS MATERIALTYPE, l.QUANTITY AS LOTQTY, m.OLDQTY - m.NEWQTY AS USEQTY
  , 1 AS USERATE, 0 AS LOSERATE, m.OLDQTY - m.NEWQTY AS MLOTCONSUMEQTY, m.LINKSID
  , m.RULENAME, 'Y' AS CALFLAG, m.USERID, m.TRANSACTIONTIME AS UPDATETIME, l.QUANTITY AS OUTQTY
  , l.DEVICE, l.DEVICE_DESCR, l.WO, mt.WAREHOUSE, mt.BOMID, l.FABCODE
  , l.BOM_REVISION
 FROM MES.MES_MMS_HIST m
 INNER JOIN MES.view_lotlist_main l ON m.LOT = l.LOT 
  INNER JOIN MES.view_mmslotlist_main mt ON m.MLOT = mt.MLOT 
 WHERE m.transaction = 'MMSConsume'
  AND m.RULENAME LIKE '%MaterialUse%'
) A
WHERE 1 = 1
order by UPDATETIME desc