SELECT ITEM_CODE, SUBINVENTORY_CODE, PALLET_NO, SUM(QTY), TO_ERP
FROM WMS.V_INVENTORY
where update_time>=to_char(SYSDATE-2,'yyyy/mm/dd hh24:mi:ss')
GROUP BY ITEM_CODE, SUBINVENTORY_CODE, PALLET_NO, TO_ERP
