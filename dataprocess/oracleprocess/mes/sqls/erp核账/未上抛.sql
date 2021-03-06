SELECT SUM(QT) FROM
(SELECT TO_ERP, SUM(QTY) AS QT, ITEM_CODE, SUBINVENTORY_CODE
        FROM WMS.V_INVENTORY
        GROUP BY TO_ERP, ITEM_CODE, SUBINVENTORY_CODE
         ) WHERE TO_ERP = 0
         AND  ITEM_CODE like '%料号（ITEM_CODE）%'
        AND SUBINVENTORY_CODE  like  '%仓别（SUBINVENTORY_CODE）%'