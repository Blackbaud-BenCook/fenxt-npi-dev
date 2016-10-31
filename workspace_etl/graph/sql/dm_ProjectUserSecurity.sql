

select
 "ProjectUserSecurityId",
 "UserId",
 "ProjectId"
from dm_ProjectUserSecurity
where TenantId = '${TenantId}'
and _sys_transform_id = ${DM_PROJECTUSERSECURITY_TRANSFORM_ID}
union all
select
	GoodData_Attr(UserId||'#0')  as "ProjectUserSecurityId",
	GoodData_Attr(UserId)  as "UserId",
	GoodData_Attr('0') as "ProjectId"
from stg_csv_User_merge u
where TenantId = '${TenantId}'