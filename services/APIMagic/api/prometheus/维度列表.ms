{
  "properties" : { },
  "id" : "prometheusdimensions00000000001",
  "script" : null,
  "groupId" : "d3f0a1b2c3d4e5f60718293a4b5c6d7e",
  "name" : "维度列表",
  "createTime" : null,
  "updateTime" : null,
  "lock" : null,
  "createBy" : "admin",
  "updateBy" : "admin",
  "path" : "/dimensions",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : "NPU 监控-维度筛选可选项（单一事实源）：返回前端维度下拉的 key(=Prometheus 标签名) + label(中文展示名)。后续新增/调整维度只需改本接口，无需改前端代码。key 集合与各查询接口 dimension 参数元数据层正则白名单保持一致(project/cluster_name/type/account/community/region/role/domain/env)",
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================

return [
    { "key" : "project", "label" : "集群" },
    { "key" : "env", "label" : "资源类型" },
    { "key" : "npu_type", "label" : "设备型号" },
    { "key" : "account", "label" : "账号" },
    { "key" : "community", "label" : "社区" },
    { "key" : "region", "label" : "地域" },
    { "key" : "domain", "label" : "领域" }
];
