select ITEM_CODE 物料编码,sum(WIPQTY_SUM) 期末库存,sum(TOTALSUMMARY_SUM) 金额
from 
		(SELECT  o318403.ITEM_CODE as ITEM_CODE,SUM(o318403.TOTALSUMMARY) as TOTALSUMMARY_SUM,SUM(o318403.WIPQTY) as WIPQTY_SUM
		 FROM ( select WE.WIP_ENTITY_NAME,msi.SEGMENT1 item_code,ywos.STATUS_TYPE,ywos.wipqty,date_closed,
		 (select  nvl(sum(amt),0) from apps.YERP_WIP_DISTRIBUTIONS  ywd
		where transaction_date != to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='110'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID) as BefMaterial,
		 (select  nvl(sum(amt),0) from apps.YERP_WIP_DISTRIBUTIONS  ywd
		where transaction_date != to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='120'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID) as BefResource,
		 (select  nvl(sum(amt),0) from apps.YERP_WIP_DISTRIBUTIONS  ywd
		where transaction_date != to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='130'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID) as BefOverhead,
		 (select  nvl(sum(amt),0) from apps.YERP_WIP_DISTRIBUTIONS  ywd
		where transaction_date != to_char(sysdate,'yyyymm') and main_acct = '1212'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID) as BefSummary,
		 (select  nvl(sum(amt),0) from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='110'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP Issue','WIP Return')) as CurIssueMaterial,
		 (select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='120'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP Issue','WIP Return')) as CurIssueResrouce,
			(select nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='130'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP Issue','WIP Return')) as CurIssueOverhead,
			(select  nvl(sum(amt),0) from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP Issue','WIP Return')) as CurIssueSummary,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='110'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP Completion','WIP Completion Return')) as CurCompleteMaterial,
		 (select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='120'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP Completion','WIP Completion Return')) as CurCompleteResrouce,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='130'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP Completion','WIP Completion Return')) as CurCompleteOverhead,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP Completion','WIP Completion Return')) as CurCompleteSummary,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='110'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP assembly scrap')) as CurScrapMaterial,
		 (select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='120'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP assembly scrap')) as CurScrapResrouce,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='130'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP assembly scrap')) as CurScrapOverhead,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('WIP assembly scrap')) as CurScrapSummary,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
			where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='110'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('Cost update')) as CostUpdateMaterial,
		 (select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='120'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('Cost update')) as CostUpdateResrouce,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212' and sub_acct='130'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('Cost update')) as CostUpdateOverhead,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where transaction_date = to_char(sysdate,'yyyymm') and main_acct = '1212'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID
			and TRANSACTION_TYPE_NAME in ('Cost update')) as CostUpdateSummary,
			 (select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
			where main_acct = '1212' and sub_acct='110'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID) as MaterialSummary,
		 (select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where  main_acct = '1212' and sub_acct='120'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID) as ResrouceSummary,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where  main_acct = '1212' and sub_acct='130'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID) as OverheadSummary,
			(select  nvl(sum(amt),0)  from apps.YERP_WIP_DISTRIBUTIONS ywd
		where main_acct = '1212'
			and ywd.WIP_ENTITY_NAME = WE.WIP_ENTITY_NAME
			and we.ORGANIZATION_ID = ywd.ORGANIZATION_ID) as TotalSummary
		from APPS.FND_RESPONSIBILITY_VL FRV, apps.yerp_wip_operations_summary ywos,WIP.WIP_ENTITIES we left join apps.MTL_SYSTEM_ITEMS msi on msi.ORGANIZATION_ID =we.ORGANIZATION_ID and WE.PRIMARY_ITEM_ID = msi.INVENTORY_ITEM_ID
		 where WE.WIP_ENTITY_ID = ywos.WIP_ENTITY_ID
			 and we.ORGANIZATION_ID = ywos.ORGANIZATION_ID
			 and ywos.STATUS_TYPE !='cancelled'
			 and ((DATE_CLOSED is not null and to_char(date_closed,'yyyymm') = to_char(sysdate,'yyyymm'))
				or DATE_CLOSED is null)
			 and ywos.organization_id in (select organization_id from apps.org_access where responsibility_id=FRV.RESPONSIBILITY_ID
		 )) o318403
		 GROUP BY o318403.WIP_ENTITY_NAME,o318403.ITEM_CODE,o318403.STATUS_TYPE,o318403.DATE_CLOSED)
 GROUP BY ITEM_CODE
 order by ITEM_CODE
