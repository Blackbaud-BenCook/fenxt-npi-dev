
select
 "TransactionScenarioId",
 "ProjectId",
 "TransactionAttrDistributionId",
 "ScenarioId",
 "FiscalPeriodId",
 "AccountId"
from dm_TransactionProjectScenario
where TenantId = '${TenantId}'
and _sys_transform_id = ${DM_TRANSACTIONPROJECTSCENARIO_TRANSFORM_ID}
union all
select 
GoodData_Attr(t.TransactionDistributionId||'#<No budget>') as "TransactionScenarioId",
GoodData_Attr(NVL(t.ProjectId,-1)) as "ProjectId",
GoodData_Attr(t.TransactionDistributionId) as "TransactionAttrDistributionId",
GoodData_Attr('<No budget>') as "ScenarioId",
GoodData_Attr(t.FiscalPeriodId) as "FiscalPeriodId",
GoodData_Attr(t.AccountId) as "AccountId"
from stg_csv_Transactions_merge t
where  t.TenantId = '${TenantId}'