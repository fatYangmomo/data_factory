SELECT DISTINCT CC.SEGMENT1 AS DEVICE, DD.SEGMENT1 AS MATERIALNO, CC.COMPONENT_QUANTITY, DD.DESCRIPTION,
	DD.INVENTORY_ITEM_ID,CC.EFFECTIVITY_DATE, CC.DISABLE_DATE  FROM
(SELECT DISTINCT BB.SEGMENT1, AA.COMPONENT_ITEM_ID, BB.INVENTORY_ITEM_ID, AA.ASSEMBLY_ITEM_ID,
AA.EFFECTIVITY_DATE, AA.DISABLE_DATE, AA.COMPONENT_QUANTITY FROM
	(	SELECT DISTINCT A.COMPONENT_ITEM_ID, B.ASSEMBLY_ITEM_ID, A.COMPONENT_QUANTITY, A.EFFECTIVITY_DATE, A.DISABLE_DATE
		FROM apps.BOM_INVENTORY_COMPONENTS_V A
			INNER JOIN APPS.BOM_BILL_OF_MATERIALS_V B
			ON A.BILL_SEQUENCE_ID = B.BILL_SEQUENCE_ID
-- 			and A.DISABLE_DATE is null
	) AA
	INNER JOIN
	( SELECT SEGMENT1, INVENTORY_ITEM_ID FROM apps.MTL_SYSTEM_ITEMS
	) BB
	ON AA.ASSEMBLY_ITEM_ID = BB.INVENTORY_ITEM_ID
	) CC
	INNER JOIN
	( SELECT SEGMENT1, INVENTORY_ITEM_ID, DESCRIPTION FROM apps.MTL_SYSTEM_ITEMS
	) DD
	ON CC.COMPONENT_ITEM_ID = DD.INVENTORY_ITEM_ID