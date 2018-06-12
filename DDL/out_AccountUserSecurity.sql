drop table if exists out_AccountUserSecurity;
CREATE TABLE out_AccountUserSecurity
(
    _sys_transform_id int NOT NULL encoding rle,
    TenantId varchar(255) encoding rle,
    AccountUserSecurityId varchar(255),
    UserId varchar(255),
    AccountId varchar(255)
)  ORDER BY TenantId,
          _sys_transform_id
SEGMENTED BY hash(TenantId) ALL NODES
PARTITION BY (_sys_transform_id);