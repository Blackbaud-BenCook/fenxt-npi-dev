INSERT INTO _sys_transform_id (id,entity,ts_start,ts_end) VALUES (${TRANSFORM_ID['TRANSFORM_ID']},'dm_AccountUserSecurity',now(),null);
insert /*+ direct */ into dm_AccountUserSecurity
select   
	${TRANSFORM_ID['TRANSFORM_ID']} as _sys_transform_id,
	t.TenantId as "TenantId",
	 GoodData_Attr(UsersId||'#'||AccountId)  as "AccountUserSecurityId"
	,GoodData_Attr(UsersId)  as "UserId"
	,GoodData_Attr(AccountId) as "AccountId"
from stg_csv_AccountUserSecurity_merge t
union all

select
	${TRANSFORM_ID['TRANSFORM_ID']} as _sys_transform_id,
	u.TenantId as "TenantId",
	 GoodData_Attr(UserId||'#'||-1)  as "AccountUserSecurityId"
	,GoodData_Attr(UserId)  as "UserId"
	,GoodData_Attr(-1) as "AccountId"
from stg_csv_User_merge u;

INSERT INTO _sys_transform_id (id,entity,ts_start,ts_end) VALUES (${TRANSFORM_ID['TRANSFORM_ID']},'dm_AccountUserSecurity',null,now());
select analyze_statistics('dm_AccountUserSecurity')
;