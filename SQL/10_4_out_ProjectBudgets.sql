INSERT INTO _sys_transform_id (id,entity,ts_start,ts_end) VALUES (${TRANSFORM_ID['TRANSFORM_ID']},'dm_ProjectBudgets',now(),null);
insert /*+ direct */ into out_ProjectBudgets
select  
     ${TRANSFORM_ID['TRANSFORM_ID']} as _sys_transform_id
    ,pb.TenantId as "TenantId"
	,cast(pbd.Amount as decimal(15,2)) as "PeriodAmount"
	,GoodData_Attr(pb.ProjectBudgetId||'-'||pbd.FiscalPeriodId) as "ProjectBudgetId"
	,GoodData_Attr(abd.AccountBudgetDetailId) as "AccountBudgetAttrId"
	,GoodData_Attr(pb.ProjectId)  as "ProjectId"
	,GoodData_Attr(pb.AccountId)  as "AccountId"
	,cast(pb.Amount as decimal(15,2)) as "ProjectBudgetAmount"
	,GoodData_Attr(pbd.FiscalPeriodId)  as "FiscalPeriodId"
	,GoodData_Attr(abs.ScenarioId) as "ScenarioId"
from stg_csv_ProjectBudget_merge pb
join stg_csv_AccountBudgetDetail_merge abd
	on pb.AccountBudgetId = abd.AccountBudgetId and pb.TenantId = abd.TenantId
join wk_AccountBudgetScenario abs
	on pb.AccountBudgetId = abs.AccountBudgetId and pb.TenantId = abs.TenantId
join (select TenantId, ProjectBudgetId, FiscalPeriodId, Amount from stg_csv_ProjectBudgetDetail_merge group by TenantId, ProjectBudgetId, FiscalPeriodId, Amount) pbd
	on pb.ProjectBudgetId = pbd.ProjectBudgetId and pb.TenantId = pbd.TenantId
;
insert /*+ direct */ into out_ProjectBudgets
select
    ${TRANSFORM_ID['TRANSFORM_ID']} as _sys_transform_id,
    p.TenantId as "TenantId",
	cast(0 as decimal(15,2)) as "PeriodAmount",
	GoodData_Attr(p.ProjectId || '#' || FP.Id || '#<No budget>') as "ProjectBudgetId",
	GoodData_Attr(0) as "AccountBudgetAttrId",
	GoodData_Attr(p.ProjectId)  as "ProjectId",
	GoodData_Attr(null)  as "AccountId",
	cast(0 as decimal(15,2)) as "ProjectBudgetAmount",
	GoodData_Attr(FP.Id)  as "FiscalPeriodId",
	GoodData_Attr('<No Budget>') as "ScenarioId"
from stg_csv_project_merge p
join (select min(FiscalPeriodId) as "Id", TenantId from stg_csv_FiscalPeriod_merge group by TenantId) FP
on p.TenantId=fp.TenantId
;
INSERT INTO _sys_transform_id (id,entity,ts_start,ts_end) VALUES (${TRANSFORM_ID['TRANSFORM_ID']},'dm_ProjectBudgets',null,now());
select analyze_statistics('out_ProjectBudgets')
;