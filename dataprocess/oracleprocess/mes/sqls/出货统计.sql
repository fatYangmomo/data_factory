select * from (
SELECT DISTINCT
 CASE WHEN SUBSTR(ORDER_NUMBER, 1, 2)='11' AND SUBSTR(CUST_PO_NUMBER, 1, 2)='补货' AND SUBINVENTORY='F1FBA' THEN 'B规补货'
         WHEN SUBSTR(ORDER_NUMBER, 1, 2)='NA' AND SUBSTR(CUST_PO_NUMBER, 1, 2)='补货' AND SUBINVENTORY='F1FBA' THEN 'B规折让'
         WHEN SUBSTR(ORDER_NUMBER, 1, 2)='NA' AND SUBSTR(CUST_PO_NUMBER, 1, 2)!='补货' AND SUBINVENTORY='F1FBA' THEN 'B规销退'
         WHEN SUBSTR(ORDER_NUMBER, 1, 2)='11' AND SUBSTR(CUST_PO_NUMBER, 1, 2)!='补货' AND SUBINVENTORY='F1FBA' THEN 'B规出货'
         WHEN SUBSTR(ORDER_NUMBER, 1, 2)='11' AND SUBINVENTORY!='F1FBA' THEN '正常出货'
         WHEN SUBSTR(ORDER_NUMBER, 1, 2)='NA' AND SUBSTR(CUST_PO_NUMBER, 1, 2)!='补货' AND SUBINVENTORY!='F1FBA' THEN '销退'
         WHEN SUBSTR(ORDER_NUMBER, 1, 2)='NA' AND SUBSTR(CUST_PO_NUMBER, 1, 2)='补货' AND SUBINVENTORY!='F1FBA' THEN '折让'
         WHEN SUBSTR(ORDER_NUMBER, 1, 2)='13' THEN '送样'
         ELSE '' END AS 出货性质,
  (CASE WHEN SUBSTR(ORDERED_ITEM, 0, 1)='F' OR SUBSTR(ORDERED_ITEM, 0, 1)='D' THEN regexp_substr(DESCRIPTION, '[0-9|\.]*"')
   ELSE '' END) AS "Size",
  SHIPMENT_DATE AS "Shipment Date",
    SHIPPING_QUANTITY*(UNIT_LENGTH*UNIT_WIDTH)/1000000 AS 销售面积,
    含税金额,
    UNIT_SELLING_PRICE AS "Unit Selling Price",
    SHIPPING_QUANTITY AS QTY,
    SUBINVENTORY AS Subinventory,
    ORDERED_ITEM As "Item Number",
    DESCRIPTION AS "Item Description",
    CUSTOMER_NAME AS "Customer Name",
  (CASE WHEN regexp_like(ORDERED_ITEM, 'W[a-z|A-Z|0-9]*') THEN '包材'
     WHEN regexp_like(ITEM_CODES, '.*AG.*') THEN 'F'
     ELSE 'R' END) AS "F/R",
    UNIT_LENGTH*UNIT_WIDTH/1000000 AS 单位面积,
    未税金额,
    含税单价
FROM
(
    SELECT
        *
    FROM (
 (SELECT
n.TRIP_NO,
to_char( l.SCHEDULE_SHIP_DATE, 'yyyy-mm-dd' ) AS SHIPMENT_DATE,
n.DELIVERY_NO,
l.SHIPPING_QUANTITY,
l.ORDER_QUANTITY_UOM,
h.ORDER_NUMBER AS ORDER_NUMBER,
n.PAYMENT_TERM,
n.CUSTOMER_NUMBER,
n.CUSTOMER_NAME,
h.CUST_PO_NUMBER,
l.ORDERED_ITEM,
i.DESCRIPTION,
(REGEXP_SUBSTR(i.DESCRIPTION, '[a-z|A-Z|0-9]*')) as ITEM_CODES,
l.UNIT_SELLING_PRICE,
l.TAX_CODE,
s.TAX_RATE,
l.SUBINVENTORY,
h.TRANSACTIONAL_CURR_CODE,
l.UNIT_SELLING_PRICE * l.SHIPPING_QUANTITY AS 未税金额,
l.UNIT_SELLING_PRICE * ( 1 + s.TAX_RATE / 100 ) AS 含税单价,
l.UNIT_SELLING_PRICE * l.SHIPPING_QUANTITY * ( 1 + s.TAX_RATE / 100 ) AS 含税金额,
to_char( l.SCHEDULE_SHIP_DATE, 'yyyymm' ) AS 出货月
FROM
apps.OE_ORDER_HEADERS_V h,
apps.OE_ORDER_LINES_V l,
apps.YOM_SHIPPING_NOTICE_V n,
( SELECT DISTINCT SEGMENT1, DESCRIPTION FROM apps.MTL_SYSTEM_ITEMS ) i,
(
SELECT
 LINE_ID,
CASE
  SUBSTR( TAX_CODE, 8 )
  WHEN '免稅' THEN
  0 ELSE to_number(
  RTRIM( SUBSTR( TAX_CODE, 8 ), '%' ))
 END AS TAX_RATE
FROM
 apps.OE_ORDER_LINES_ALL
) s
WHERE
i.SEGMENT1 = l.ORDERED_ITEM
AND h.HEADER_ID = l.HEADER_ID
AND s.LINE_ID = l.LINE_ID
AND l.LINE_ID = n.ORDER_LINE_ID
AND REGEXP_LIKE ( h.ORDER_NUMBER, '^1[1|3].*' )
UNION
SELECT
NULL,
to_char( l.SCHEDULE_SHIP_DATE, 'yyyy-mm-dd' ) AS SHIPMENT_DATE,
NULL,
l.SHIPPING_QUANTITY,
l.ORDER_QUANTITY_UOM,
h.ORDER_NUMBER AS ORDER_NUMBER,
h.TERMS as PAYMENT_TERM,
h.CUSTOMER_NUMBER,
h.SOLD_TO as CUSTOMER_NUMBER,
h.CUST_PO_NUMBER,
l.ORDERED_ITEM,
i.DESCRIPTION,
(REGEXP_SUBSTR(i.DESCRIPTION, '[a-z|A-Z|0-9]*')) as ITEM_CODES,
l.UNIT_SELLING_PRICE,
l.TAX_CODE,
s.TAX_RATE,
l.SUBINVENTORY,
h.TRANSACTIONAL_CURR_CODE,
l.UNIT_SELLING_PRICE * l.SHIPPING_QUANTITY AS 未税金额,
l.UNIT_SELLING_PRICE * ( 1 + s.TAX_RATE / 100 ) AS 含税单价,
l.UNIT_SELLING_PRICE * l.SHIPPING_QUANTITY * ( 1 + s.TAX_RATE / 100 ) AS 含税金额,
to_char( l.SCHEDULE_SHIP_DATE, 'yyyymm' ) AS 出货月
FROM
apps.OE_ORDER_HEADERS_V h,
apps.OE_ORDER_LINES_V  l,
( SELECT DISTINCT SEGMENT1, DESCRIPTION FROM apps.MTL_SYSTEM_ITEMS ) i,
(
SELECT
 LINE_ID,
CASE
  SUBSTR( TAX_CODE, 8 )
  WHEN '免稅' THEN
  0 ELSE to_number(
  RTRIM( SUBSTR( TAX_CODE, 8 ), '%' ))
 END AS TAX_RATE
FROM
 apps.OE_ORDER_LINES_ALL
) s
WHERE
i.SEGMENT1 = l.ORDERED_ITEM
AND h.HEADER_ID = l.HEADER_ID
AND s.LINE_ID = l.LINE_ID
AND REGEXP_LIKE ( h.ORDER_NUMBER, '^12.*' )
)
ORDER BY
ORDER_NUMBER

    ) SQL1
    LEFT JOIN (
        SELECT
            DISTINCT A.ITEM_CODE,
            A.ONHAND_QUANTITY,
            B.UNIT_LENGTH,
            B.UNIT_WIDTH,
            B.ATTRIBUTE3,
            SUBSTR(
                SUBSTR(
                    B.DESCRIPTION,0,INSTR(B.DESCRIPTION,'"')
                ),
                INSTR(
                    SUBSTR(
                        B.DESCRIPTION,0,INSTR(B.DESCRIPTION,'"')
                    ),';',-1,1
                )+1
            ) AS SIZE_WITH_QUOTE,
            CASE WHEN B.ATTRIBUTE3='下片' THEN 'R'
                 WHEN B.ATTRIBUTE3='上片' THEN 'F'
                 ELSE '' END AS FRFRFR
        FROM
            APPS.YWMS_ONHAND_QUANTITY A
        INNER
            JOIN APPS.MTL_SYSTEM_ITEMS B
        ON
            A.INVENTORY_ITEM_ID = B.INVENTORY_ITEM_ID
        WHERE
            A.CATEGORY_SEG1 = '成品'
    ) SQL2
    ON
        SQL1.ORDERED_ITEM=SQL2.ITEM_CODE
)
)