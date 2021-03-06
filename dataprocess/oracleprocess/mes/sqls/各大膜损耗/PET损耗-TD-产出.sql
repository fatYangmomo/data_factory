select sum(outqty) as rcc,b.ITEM_COST,rq from

(select *,DATE_FORMAT(date_sub(UPDATETIME,interval 7 hour),'%Y-%m-%d') as rq from offline.sunhao where
DATE_FORMAT(UPDATETIME, '%Y-%m-%d %H:%i:%s') between DATE_FORMAT('${startime}', '%Y-%m-%d 07:00:00') and DATE_FORMAT('${endtime}','%Y-%m-%d 07:00:00')
   AND MATERIALNO LIKE '_011%'
AND EQUIPMENT IS NOT NULL
AND OPERATION IN ('PSA','TAC-PVA','PVA','TAC','AGING')
AND WO NOT LIKE 'KP1%'
AND WOTYPE='TD'
 AND WO LIKE '___D%'
  ) s
INNER JOIN materialprice b on s.materialno=b.ITEM_NUMBER WHERE b.ITEM_COST != 0 and b.COST_TYPE= 'Frozen'
group by rq