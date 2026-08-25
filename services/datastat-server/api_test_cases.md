# 接口自动化测试用例清单

**生成时间**: 自动生成

**接口总数**: 365

**按方法统计**: 
DELETE=2 
GET=202 
POST=161 



## 模块接口详情


### AIdemo (2 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 当前聊天状态 | GET | `/api-gpt/threads/{id}/state` | - | - | - |
| 2 | 未定义名称 | GET | `/api-gpt/query/thread` | - | - | - |

### AI统计 (7 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | PR详情 | POST | `/ai-metrics/pr-detail` | - | - | Y |
| 2 | SIG统计 | POST | `/ai-metrics/sig-stats` | - | - | Y |
| 3 | 代码类型分布 | POST | `/ai-metrics/code-type` | - | - | Y |
| 4 | 工具分布 | POST | `/ai-metrics/tool-distribution` | - | - | Y |
| 5 | 开发者统计 | POST | `/ai-metrics/developer-stats` | - | - | Y |
| 6 | 概览数据 | POST | `/ai-metrics/overview` | - | - | Y |
| 7 | 趋势数据 | POST | `/ai-metrics/trend` | - | - | Y |

### INFRA看板 (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 筛选选项 | GET | `/infra-board/filters` | - | - | - |
| 2 | 统计概览 | GET | `/infra-board/summary` | - | - | - |
| 3 | 需求列表 | GET | `/infra-board/issues` | - | page, pageSize | - |

### SIG (12 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | SIG仓库的committer信息 | GET | `/sig/new/repo/committers` | community, sig | community, sig | - |
| 2 | sig特性分组 | GET | `/sig/scoreAll` | community | community | - |
| 3 | SIG的组织成员信息 | GET | `/sig/role/list` | community, sig | community, sig | - |
| 4 | 内外部合入PR贡献比 | GET | `/sig/pr/count` | community | community | - |
| 5 | 外部合入PR占比 | GET | `/sig/pr/exteral/ratio` | community | community | - |
| 6 | 总数 | POST | `/sig/totalCount` | - | - | Y |
| 7 | 权限 | GET | `/sig/{community}/permission` | - | - | - |
| 8 | 活跃度 | GET | `/sig/score` | community | community, order, page, page_size | - |
| 9 | 用户SIG组角色 | GET | `/sig/user/ownertype` | community | community, user | - |
| 10 | 贡献者排名 | POST | `/sig/topn/user/{contrib_type}` | - | - | Y |
| 11 | 运作情况 | GET | `/sig/status` | community | community | - |
| 12 | 运作情况同比 | GET | `/sig/status/on/{interval}` | community | community | - |

### SIG贡献页面 (10 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | SIG信息 | GET | `/stat_new/sig/info` | community, sig | community | - |
| 2 | SIG列表 | GET | `/stat_new/sig/list` | community | community | - |
| 3 | 个人贡献排名 | GET | `/stat_new/sig/user/contribute` | community, contributeType | community, contributeType, comment_type | - |
| 4 | 获取用户信息 | GET | `/stat_new/userinfo` | community | community, platform | - |
| 5 | robot使用接口 | GET | `/stat/sig/robot/info` | community | community, repo | - |
| 6 | SIG_robot使用接口 | GET | `/stat/sig/detail/info` | community | community, repo | - |
| 7 | SIG信息 | GET | `/stat/sig/info` | community | community, sig | - |
| 8 | SIG列表 | GET | `/stat/sig/list` | community | community | - |
| 9 | 个人贡献排名 | GET | `/stat/sig/user/contribute` | community, contributeType | community, contributeType, timeRange, sig | - |
| 10 | 获取用户信息 | GET | `/stat/userinfo` | community | community, page, pageSize, platform | - |

### TTFHW (14 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | TTFHW问题列表 | GET | `/ttfhw/list` | - | - | - |
| 2 | 场景列表 | GET | `/ttfhw/scenario/list` | - | page, page_size, sort_by, sort_order, status, scenario_type, creator | - |
| 3 | 场景报告预览 | GET | `/ttfhw/scenario/preview` | id | - | - |
| 4 | 场景提交 | POST | `/ttfhw/scenario/submit` | - | - | - |
| 5 | 场景筛选候选 | GET | `/ttfhw/scenario/filter-options` | - | - | - |
| 6 | TTFHW总览 | GET | `/ttfhw/overview` | - | - | - |
| 7 | TTFHW手动Issue | GET | `/ttfhw/issues` | - | - | - |
| 8 | 提交问题 | POST | `/ttfhw/submit` | - | - | Y |
| 9 | TTFHW断点问题 | GET | `/ttfhw/problems` | - | - | - |
| 10 | 确认问题 | POST | `/ttfhw/confirm` | - | - | Y |
| 11 | TTFHW社区汇总 | GET | `/ttfhw/communitySummary` | - | - | - |
| 12 | 筛选选项 | GET | `/ttfhw/options` | - | - | - |
| 13 | TTFHW运行明细 | GET | `/ttfhw/runs` | - | - | - |
| 14 | TTFHW运行详情 | GET | `/ttfhw/run` | id | - | - |

### ascend-sig-info (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | getAllReviewers | POST | `/mindie/getAllReviewers` | - | - | Y |
| 2 | getBranchKeeper(复制) | POST | `/mindie/getBranchKeeper` | - | - | Y |
| 3 | getFileApproversMap | POST | `/mindie/getFileApproversMap` | - | - | Y |

### datastat (11 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | authing注册信息webhook | POST | `/stat/authing/webhook/usercreated` | - | - | Y |
| 2 | TC成员 | GET | `/stat/tc/sigs` | community | community | - |
| 3 | webhook启动sig解析任务 | GET | `/stat/exec/sigjob` | community, token | community, token | - |
| 4 | 下载量 | GET | `/stat/download` | community, packageName | community, packageName, start, end | - |
| 5 | 塔台蓝区代码贡献 | GET | `/stat/whitebox/blueuser` | - | gitcode_id, gitee_id, github_id, start_time, token | - |
| 6 | 新增配置页面 | POST | `/stat/page/config` | - | - | Y |
| 7 | 查看白盒支持的仓库 | GET | `/stat/whitebox/repo` | token, repo, platform | token, repo, platform | - |
| 8 | 查询配置页面 | GET | `/stat/page/config/query` | - | name | - |
| 9 | 检查邮箱 | GET | `/stat/whitebox/checkemail` | id, platform, repo, type | id, platform, repo, type | - |
| 10 | 重新采集数据(新) | GET | `/stat/whitebox/collect_copy` | type, platform, repo, collect_from | type, platform, repo, collect_from, befordays | - |
| 11 | 重新采集数据 | GET | `/stat/whitebox/collect` | type, platform, repo, owner, collect_from | type, platform, repo, owner, collect_from, befordays | - |

### mindspore-sig (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | allsig | GET | `/sig/all/{community}` | - | - | - |
| 2 | siginfo(复制) | GET | `/sig/one/{community}_copy` | - | sigName | - |
| 3 | siginfo | GET | `/sig/one/{community}` | - | sigName | - |

### openubmc (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | committermaintainer信息 | GET | `/openubmc/sig/info` | sigName | - | - |
| 2 | 根据仓库获取committer信息 | GET | `/openubmc/repo/committer` | - | - | - |
| 3 | 根据仓库获取committer信息测试 | GET | `/openubmc/dd/test/repo/committer` | - | sigName | - |

### openubmc-sig (1 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | committermaintainer信息 | GET | `/openubmc/sig/userdetials` | sigName | - | - |

### prometheus (6 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 使用趋势 | GET | `/prometheus/usageTrend` | - | dimension | - |
| 2 | 使用率趋势 | GET | `/prometheus/utilizationTrend` | - | dimension | - |
| 3 | 标签取值 | GET | `/prometheus/labelValues` | label | label | - |
| 4 | 汇总卡片 | GET | `/prometheus/summary` | - | dimension | - |
| 5 | 维度列表 | GET | `/prometheus/dimensions` | - | - | - |
| 6 | 采集状态 | GET | `/prometheus/upStatus` | - | - | - |

### sig信息 (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 官网获取sig信息 | GET | `/stat/sig/query` | community | community | - |
| 2 | 根据repo查询committer | GET | `/stat/sig/user` | community, repo, role, level | community, role, level | - |
| 3 | 获取tc和project信息 | GET | `/stat/sig/tc/user` | community | community | - |

### 下载 (1 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 软件包下载 | GET | `/download/package` | community, packageName | community, packageName | - |

### 仓库 (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | cloc | POST | `/repo/cloc` | - | - | Y |
| 2 | 分支详情 | GET | `/repo/versions` | community | community | - |
| 3 | 总数 | POST | `/repo/totalCount` | - | - | Y |

### 会议 (4 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 会议参会人查询 | GET | `/meeting/participants/info` | community | community, page, page_size, sort, direction | - |
| 2 | 社区会议预定查询 | GET | `/meeting/info` | community | community, page, page_size, created_after, created_before, sort, direction | - |
| 3 | 获取组织列表 | GET | `/meeting/group/list` | community | - | - |
| 4 | 获取组织成员信息 | GET | `/meeting/org_member` | community | community | - |

### 健康度 (8 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 健康度趋势 | GET | `/health/{community}/trend` | - | date, mode | - |
| 2 | 同比 | GET | `/health/{community}/on/{interval}` | - | - | - |
| 3 | 大象企业 | GET | `/health/{community}/elephant_companies` | - | - | - |
| 4 | 有效维护仓库 | GET | `/health/{community}/active_repo` | - | - | - |
| 5 | 社区健康度 | GET | `/health/{community}/metric` | - | - | - |
| 6 | 社区健康度季度均值 | GET | `/health/{community}/quarter` | - | - | - |
| 7 | 社区健康度指标类型 | GET | `/health/metric/type` | community | community | - |
| 8 | 贡献企业多样性 | GET | `/health/{community}/companies` | - | - | - |

### 其他指标 (1 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | jdk数据统计 | GET | `/stat/metric/jdk` | community | community, start, end | - |

### 年报 (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 开源实习 | GET | `/report/{platform}/practice` | - | - | - |
| 2 | 用户个人报告 | GET | `/report/user/{platform}` | - | - | - |
| 3 | 用户月度贡献最多 | GET | `/report/{platform}/month/contribute` | - | - | - |

### 开发者 (13 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 所有用户公司分页 | GET | `/user/companies/all` | - | platform, users | - |
| 2 | 批量查询用户邮箱 | POST | `/user/emails` | - | - | Y |
| 3 | 海外贡献者统计 | GET | `/user/oversea/contributor/stats` | community | community | - |
| 4 | 用户cla信息 | GET | `/user/cla/list` | community | community, page, page_size, created_after | - |
| 5 | 用户周环比 | POST | `/user/ratio/week` | - | - | Y |
| 6 | 用户总数 | POST | `/user/totalCount` | - | - | Y |
| 7 | 用户月环比 | POST | `/user/ratio/month` | - | - | Y |
| 8 | 用户活跃(有效) | POST | `/user/active/user` | - | - | Y |
| 9 | 用户登录名映射 | GET | `/user/{user}/info` | - | - | - |
| 10 | 用户等级详情 | POST | `/user/level/detail` | - | - | Y |
| 11 | 用户组织信息 | GET | `/user/companies` | community, platform | community, platform, page, page_size | - |
| 12 | 用户趋势 | POST | `/user/trend/user` | - | - | Y |
| 13 | 获取列表用户组织信息 | POST | `/user/companies` | - | - | Y |

### 开发者页面 (16 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | comment贡献详情 | GET | `/stat_new/comment/detail` | user, community | community, comment_type | - |
| 2 | comment贡献详情v2 | GET | `/stat_new/comment/detail/v2` | user, community | community, comment_type | - |
| 3 | prissue贡献详情 | GET | `/stat_new/{contributeType}/detail` | user, community | community | - |
| 4 | prissue贡献详情v2 | GET | `/stat_new/{contributeType}/detail/v2` | user, community | community | - |
| 5 | SIG贡献排名 | GET | `/stat_new/sigcontribute` | community, contributeType | community, contributeType | - |
| 6 | userinfo | GET | `/stat_new/user/info` | community | community | - |
| 7 | 全部贡献 | GET | `/stat_new/count` | community | community | - |
| 8 | 开发者列表 | GET | `/stat_new/userlist` | community | community | - |
| 9 | 模糊查询贡献总数 | GET | `/stat_new/{contributeType}/count` | community, user | community, comment_type | - |
| 10 | comment贡献详情 | GET | `/stat/comment/detail` | user, community | user, page, pageSize, community, sig, comment_type, timeRange | - |
| 11 | prissue贡献详情 | GET | `/stat/{contributeType}/detail` | user, community | user, page, pageSize, community, sig, timeRange | - |
| 12 | SIG贡献排名 | GET | `/stat/sigcontribute` | community, contributeType | community, contributeType, timeRange, user | - |
| 13 | userinfo | GET | `/stat/user/info` | community, user | community, user | - |
| 14 | 全部贡献 | GET | `/stat/count` | community | community, user, timeRange, sig, comment_type | - |
| 15 | 开发者列表 | GET | `/stat/userlist` | community | community | - |
| 16 | 模糊查询贡献总数 | GET | `/stat/{contributeType}/count` | community, user | community, user, timeRange, sig, comment_type | - |

### 开源实习 (5 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 导师或者学生贡献值 | GET | `/practice/contribute/detail` | community, type | community, type | - |
| 2 | 开源实习详情 | POST | `/practice/detail/page` | - | - | Y |
| 3 | 领过题目人数 | GET | `/practice/got/issue` | community | community | - |
| 4 | 领过题目人数汇总 | GET | `/practice/got/issue/total` | community | community | - |
| 5 | 领过题目人数详情 | GET | `/practice/got/issue/detail` | community | community | - |

### 开源技术雷达 (25 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | github_star信息 | GET | `/opensource/githubstar/metric` | - | type, file_project, date_str, normal_type | - |
| 2 | ossf_scorce信息 | GET | `/opensource/ossf/metric` | - | type, file_project, date_str | - |
| 3 | rank信息 | GET | `/opensource/rank/metric` | - | type, file_project, date_str | - |
| 4 | upstream_pypi信息 | GET | `/opensource/upstreampypi/metric` | - | type, file_project, date_str | - |
| 5 | 刷新预览触发 | POST | `/opensource/oss-insight/refresh` | - | - | - |
| 6 | 开源技术月度信息 | GET | `/opensource/radar/detail/info` | - | algorithm, type, month, file_project | - |
| 7 | 开源技术雷达 | GET | `/opensource/metric` | - | algorithm, type, file_project, date_str, month | - |
| 8 | 总览列表 | GET | `/opensource/oss-insight/list` | - | page, page_size | - |
| 9 | 报告内容 | GET | `/opensource/insight/report/content` | report_path | - | - |
| 10 | 报告列表 | GET | `/opensource/insight/report/list` | - | page, page_size | - |
| 11 | 提交洞察需求 | POST | `/opensource/oss-insight/submit` | - | - | - |
| 12 | 新增项目 | POST | `/opensource/tech-radar/add` | - | - | - |
| 13 | 更新状态 | POST | `/opensource/oss-insight/update` | - | - | - |
| 14 | 更新项目 | POST | `/opensource/tech-radar/update` | - | - | - |
| 15 | 点赞 | POST | `/opensource/oss-insight/like` | - | - | - |
| 16 | 筛选候选 | GET | `/opensource/oss-insight/filter-options` | - | - | - |
| 17 | 精选 | POST | `/opensource/oss-insight/feature` | - | - | - |
| 18 | 综合评分变化趋势 | GET | `/opensource/trend/metric` | - | algorithm, type, file_project, date_str, month | - |
| 19 | 获取开源实习的社区 | GET | `/opensource/community/dict` | - | - | - |
| 20 | 获取数据字典 | GET | `/opensource/dict` | type | type | - |
| 21 | 雷达图接口 | GET | `/opensource/radar/metric` | - | algorithm, type, file_project, date_str, month | - |
| 22 | 雷达图表格接口 | GET | `/opensource/radar/table/metric` | - | algorithm, type, file_project, date_str, month | - |
| 23 | 项目列表 | GET | `/opensource/tech-radar/list` | - | - | - |
| 24 | 项目统计 | GET | `/opensource/tech-radar/stats` | - | - | - |
| 25 | 预览内容 | GET | `/opensource/oss-insight/preview` | id | - | - |

### 影响力 (2 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 排名 | GET | `/influence/distrowatch` | - | - | - |
| 2 | 数据库排名 | GET | `/influence/db_engine` | - | - | - |

### 总览 (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 健康度指标 | GET | `/totalview/community` | community | - | - |
| 2 | 健康度指标对按照年 | GET | `/totalview/communityByYear` | - | - | - |
| 3 | 健康度指标对比 | GET | `/totalview/communityCompare` | - | - | - |

### 指标字典 (6 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | Dict | GET | `/dict/metric` | - | - | - |
| 2 | Dict总数 | POST | `/dict/total` | - | metric | Y |
| 3 | Dict详情 | POST | `/dict/detail` | - | page, page_size | Y |
| 4 | 指标列表 | GET | `/dict/list` | - | - | - |
| 5 | 模型列表 | GET | `/dict/models` | - | - | - |
| 6 | 社区配置 | GET | `/dict/community-config` | - | - | - |

### 数据入湖 (20 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | comment分页 | POST | `/whitebox/comment/page` | - | - | Y |
| 2 | commit分页 | POST | `/whitebox/commit/page` | - | - | Y |
| 3 | issue分页 | POST | `/whitebox/issue/page` | - | - | Y |
| 4 | org配置修改 | POST | `/whitebox/org` | - | - | - |
| 5 | pr分页 | POST | `/whitebox/pr/page` | - | - | Y |
| 6 | 仓库配置修改 | POST | `/whitebox/repo/update` | - | - | - |
| 7 | 删除组织 | DELETE | `/whitebox/org/{id}` | - | - | - |
| 8 | 删除采集仓库 | DELETE | `/whitebox/repo/{id}` | - | - | - |
| 9 | 发现组织仓库 | GET | `/whitebox/discover/org/repos` | - | - | - |
| 10 | 按链接诊断数据未统计 | GET | `/whitebox/diagnose` | url | url, verify | - |
| 11 | 查看仓库是否在采集范围 | GET | `/whitebox/query/repo` | - | collect_enabled, owner, repo, community, platforms, asc, desc | - |
| 12 | 查看仓库采集情况 | GET | `/whitebox/query/repo/stats` | - | status, owner, repo, community, platforms, asc, desc | - |
| 13 | 查看平台列表 | GET | `/whitebox/query/platforms` | - | - | - |
| 14 | 查看检查数据 | GET | `/whitebox/query/check` | - | - | - |
| 15 | 查看用户采集情况 | GET | `/whitebox/usercheck` | - | gitcode_id, gitee_id, github_id, start_time | - |
| 16 | 查看组织是否在采集范围 | GET | `/whitebox/query/org` | - | - | - |
| 17 | 查看采集状态列表 | GET | `/whitebox/query/repo/status` | - | - | - |
| 18 | 触发同步到蓝区贡献表(诊断树) | GET | `/whitebox/diagnose-sync` | - | gitcode_id, gitee_id, github_id, community, start_time | - |
| 19 | 采集数据分页查询 | GET | `/whitebox/records` | - | type, platforms, creator, title, url, repo, asc, desc | - |
| 20 | 采集贡献明细分页查询 | GET | `/whitebox/blue-records` | - | types, platforms, creator, title, repo, asc, desc | - |

### 数据总览 (2 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 总览数据 | GET | `/stat_new/overview/count` | community | community | - |
| 2 | 总览数据 | GET | `/stat/overview/count` | community | community, metric | - |

### 文档体验模型 (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 评价详情 | GET | `/docs/point/detail` | project, repo | - | - |
| 2 | 评分 | GET | `/docs/score` | project, repo | - | - |
| 3 | 评分雷达图 | GET | `/docs/score/radar` | project, repo | - | - |

### 服务健康检查 (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 健康检查接口 | GET | `/check/healthz` | - | - | - |
| 2 | 接口文件重载 | GET | `/check/reload` | - | - | - |
| 3 | 权限 | GET | `/check/permission` | community | - | - |

### 服务分析 (7 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 旭日图 | POST | `/analysis/sunburst` | - | - | Y |
| 2 | 服务分析列表 | GET | `/analysis/list` | community | community | - |
| 3 | 服务或模块指标直方图 | POST | `/analysis/{type}/count` | - | - | Y |
| 4 | 服务时间指标值 | POST | `/analysis/value` | - | - | Y |
| 5 | 服务时间指标环比 | POST | `/analysis/service/ratio` | - | - | Y |
| 6 | 服务时间指标趋势 | POST | `/analysis/service/trend` | - | - | Y |
| 7 | 矩阵图 | POST | `/analysis/{type}/graph` | - | - | Y |

### 服务看板 (8 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | PUUV下载量 | POST | `/service/ratio` | - | - | Y |
| 2 | 服务列表 | POST | `/service/list` | - | - | Y |
| 3 | 服务指标 | POST | `/service/metirc` | - | - | Y |
| 4 | 服务看板字典查询 | GET | `/service/dict/all` | - | - | - |
| 5 | 服务趋势 | POST | `/service/trend` | - | - | Y |
| 6 | 查询所有的PV和UV | POST | `/service/data/all` | - | - | Y |
| 7 | 账号服务应用字典 | GET | `/service/account/app/dict` | - | - | - |
| 8 | 账号服务明细分页 | POST | `/service/account/detail/page` | - | - | Y |

### 用户贡献详情 (1 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 贡献总数 | GET | `/user/count` | user, community | community, sig | - |

### 社区 (4 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 开源项目数据 | POST | `/community/starfork` | - | - | Y |
| 2 | 社区列表 | POST | `/community/list` | - | - | - |
| 3 | 社区组织成员详情 | GET | `/community/org/member` | community, org | community | - |
| 4 | 社区组织架构 | GET | `/community/org/type` | community | community | - |

### 社区下载 (23 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | GitCode仓库下载明细记录 | POST | `/community/download/repo/records` | - | - | Y |
| 2 | GitCode仓库下载量按天 | POST | `/community/download/repo/daily` | - | - | Y |
| 3 | GitCode仓库下载量明细 | POST | `/community/download/repo/detail` | - | - | Y |
| 4 | GitCode仓库下载量趋势 | POST | `/community/download/repo/trend` | - | - | Y |
| 5 | hifloat看板文档下载详情 | GET | `/community/download/home/detail_hifloat` | community | community | - |
| 6 | source字典 | GET | `/community/download/dict` | community | community | - |
| 7 | unifiedbus看板文档下载详情 | GET | `/community/download/home/detail` | community | community | - |
| 8 | 下载总量(正式) | GET | `/community/download/total` | community | community | - |
| 9 | 下载总量 | GET | `/community/download/total_bak20250717` | community | community | - |
| 10 | 下载源分布 | GET | `/community/download/source` | community | community | - |
| 11 | 下载版本明细分页 | POST | `/community/download/detail/page` | - | - | Y |
| 12 | 下载版本软件聚合 | POST | `/community/download/software/aggregate` | - | - | Y |
| 13 | 下载用户数周和月环比 | POST | `/community/download/ratio` | - | - | Y |
| 14 | 下载趋势(新接口) | POST | `/community/download/trend` | - | - | Y |
| 15 | 下载量按月(复制) | POST | `/community/download/month` | - | - | Y |
| 16 | 仓库模型下载量明细 | POST | `/community/download/repo/page` | - | - | Y |
| 17 | 地理位置信息数据 | POST | `/community/download/geo/detail` | community | community | Y |
| 18 | 根据版本获下载量 | POST | `/community/download/version` | - | - | Y |
| 19 | 版本数据详情 | POST | `/community/download/version/detail` | - | - | Y |
| 20 | 统计非unifiedbus社区的地理位置下载量 | POST | `/community/download/geo/source` | - | - | Y |
| 21 | 获取下载量 | POST | `/community/download/total` | - | - | Y |
| 22 | 非unifiedbus社区地理下载量统计 | GET | `/community/download/geo/info` | community, start, end | community, group_field, is_domestic | - |
| 23 | 非unifiedbus社区地理位置信息数据 | POST | `/community/download/geo/info` | community | - | Y |

### 社区贡献页面 (8 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 个人贡献排名 | GET | `/stat_new/user/contribute` | community, contributeType | community, contributeType, comment_type | - |
| 2 | 仓库列表 | GET | `/stat_new/repo` | - | community | - |
| 3 | 企业版本贡献 | GET | `/stat_new/version/company/contribute` | community, contributeType | community, contributeType | - |
| 4 | 企业贡献排名 | GET | `/stat_new/company/contribute` | community, contributeType | community, contributeType | - |
| 5 | 个人贡献排名 | GET | `/stat/user/contribute` | community, contributeType | community, repo, contributeType, timeRange, comment_type | - |
| 6 | 仓库列表 | GET | `/stat/repo` | community | community | - |
| 7 | 企业版本贡献 | GET | `/stat/version/company/contribute` | community, contributeType | community, contributeType, version | - |
| 8 | 企业贡献排名 | GET | `/stat/company/contribute` | community, contributeType | community, repo, contributeType, timeRange, sig | - |

### 社区运营质量 (12 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | Issue指标 | GET | `/stats/issue` | community | community, private | - |
| 2 | TOPN用户留存率 | GET | `/stats/user_retention` | community | community | - |
| 3 | YTD下载量 | GET | `/stats/year_download` | community | community | - |
| 4 | 严重缺陷数 | GET | `/stats/cve` | community | community | - |
| 5 | 健康度指标 | GET | `/stats/health_metric` | community, metric | community, metric | - |
| 6 | 搜索指数 | GET | `/stats/influence` | community | community | - |
| 7 | 有效评论数 | GET | `/stats/valid_comment` | community | community, contrib_type, private | - |
| 8 | 组织多样性 | GET | `/stats/company` | community | community, private | - |
| 9 | 论坛指标 | GET | `/stats/forum` | community | community | - |
| 10 | 负向事件 | GET | `/stats/negative_event` | community | community | - |
| 11 | 贡献指标 | GET | `/stats/contribute` | community | community, private | - |
| 12 | 项目集成引用度 | GET | `/stats/itegration` | community | community | - |

### 组织 (2 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | CLA签署组织总数 | GET | `/organization/claCount` | community | community | - |
| 2 | 组织总数 | POST | `/organization/totalCount` | - | - | Y |

### 自定义看板接口 (7 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 下钻指标列表 | GET | `/customization/metric/list` | - | - | - |
| 2 | 总数 | POST | `/customization/total` | - | - | Y |
| 3 | 数据表 | GET | `/customization/{community}/tables` | - | - | - |
| 4 | 筛选器查询 | POST | `/customization/issues/filter` | community | community, page, page_size | Y |
| 5 | 角色贡献 | GET | `/customization/role/contribute` | community | community, sig | - |
| 6 | 详情(token) | POST | `/customization/{community}/detail/v2` | - | page, page_size | Y |
| 7 | 详情 | POST | `/customization/{community}/detail` | - | page, page_size | Y |

### 资源 (22 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | CI-workflow-step数据 | POST | `/res/ci/workflow-steps` | - | - | Y |
| 2 | CI-workflow执行明细 | POST | `/res/ci/workflow-run-detail` | - | - | Y |
| 3 | CI测试用例统计 | POST | `/res/ci/test-case-stats` | - | - | Y |
| 4 | cluster信息 | POST | `/res/cluster/detail` | - | - | Y |
| 5 | CPU维度详情 | POST | `/res/cpu/dimension/detail` | - | - | Y |
| 6 | CPU详情 | POST | `/res/cpu/cluster/detail` | - | - | Y |
| 7 | cpu选项接口 | POST | `/res/cpu/options` | - | - | Y |
| 8 | mind系列ci数据 | POST | `/res/workflow/mindall` | - | - | Y |
| 9 | mind系列晴雨表接口 | POST | `/res/ci/mind-metrics` | - | - | Y |
| 10 | npu | GET | `/res/npu` | - | - | - |
| 11 | npupr | POST | `/res/npu/dimension/detail` | - | - | Y |
| 12 | npu字典 | GET | `/res/npu/dict` | - | - | - |
| 13 | npu详细数据折线图 | POST | `/res/npu/dimension/metric` | - | - | - |
| 14 | vllm晴雨表接口 | POST | `/res/ci/vllm-metrics` | - | - | Y |
| 15 | workflow | POST | `/res/workflow/detail` | - | - | Y |
| 16 | workflow详细历史 | POST | `/res/workflow/history` | - | - | Y |
| 17 | workflow详细数据 | POST | `/res/workflow/metric` | - | - | - |
| 18 | 下拉框数据 | GET | `/res/dict` | - | - | - |
| 19 | 月度总费用 | POST | `/res/totalcost` | - | - | Y |
| 20 | 费用趋势图 | POST | `/res/month/trend` | - | - | Y |
| 21 | 资源使用 | POST | `/res/usage/dimension/detail` | - | - | Y |
| 22 | 资源使用情况 | POST | `/res/usage/detail` | - | - | Y |

### 软件包维护情况 (5 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | CVE详情 | GET | `/package/cve` | - | community | - |
| 2 | 层级维护率 | GET | `/package/level/status` | - | community | - |
| 3 | 版本列表 | GET | `/package/versions` | community | community | - |
| 4 | 维护率 | GET | `/package/status` | - | community | - |
| 5 | 维护率同比 | GET | `/package/status/on/{interval}` | - | community | - |

### 运营质量基线 (3 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | 按月查询 | GET | `/baseline/list` | month | - | - |
| 2 | 月份列表 | GET | `/baseline/months` | - | - | - |
| 3 | 月度录入 | POST | `/baseline/import` | - | - | - |

### 通用查询 (38 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | comment详情分页 | POST | `/query/comments/detail` | - | - | Y |
| 2 | forum汇总分页(tag维度) | POST | `/query/forum/tag/agg` | - | - | Y |
| 3 | forum汇总分页 | POST | `/query/forum/agg` | - | - | Y |
| 4 | forum论坛详情(admin) | POST | `/query/forum/detail/admin/page` | - | - | Y |
| 5 | forum论坛详情 | POST | `/query/forum/detail/page` | - | - | Y |
| 6 | Issue关联PR信息 | POST | `/query/issue/ref/pr` | - | - | Y |
| 7 | issue汇总分页(sig维度) | POST | `/query/issues/agg/sig` | - | - | Y |
| 8 | issue汇总分页(子社区维度) | POST | `/query/issues/agg/sub_community` | - | - | Y |
| 9 | issue汇总分页(调试) | POST | `/query/issues/agg_copy` | - | - | Y |
| 10 | issue汇总分页 | POST | `/query/issues/agg` | - | - | Y |
| 11 | issue汇总环比(period-on-period) | POST | `/query/issues/agg/pop` | - | - | Y |
| 12 | issue详情分页 | POST | `/query/issues/detail` | - | - | Y |
| 13 | pr汇总分页(sig维度) | POST | `/query/prs/agg/sig` | - | - | Y |
| 14 | pr汇总分页(子社区维度) | POST | `/query/prs/agg/sub_community` | - | - | Y |
| 15 | pr汇总分页 | POST | `/query/prs/agg` | - | - | Y |
| 16 | pr汇总环比(period-on-period) | POST | `/query/prs/agg/pop` | - | - | Y |
| 17 | pr详情分页 | POST | `/query/prs/detail` | - | - | Y |
| 18 | SIG撬动比 | POST | `/query/sig/leverage-ratio` | - | - | Y |
| 19 | 仓库贡献人数统计 | POST | `/query/repo/user/page` | - | - | Y |
| 20 | 仓库贡献者明细 | POST | `/query/repo/user/detail` | - | - | Y |
| 21 | 仓库贡献者明细增强 | POST | `/query/repo/user/detail/v2` | - | - | Y |
| 22 | 子社区列表 | POST | `/query/sub-communities` | - | - | Y |
| 23 | 开发者 | POST | `/query/users` | - | - | Y |
| 24 | 开发者汇总分页 | POST | `/query/users/page` | - | - | Y |
| 25 | 服务汇总 | POST | `/query/source/total` | - | - | Y |
| 26 | 服务汇总分页 | POST | `/query/source/total/page` | - | - | Y |
| 27 | 服务趋势 | POST | `/query/source/trend` | - | - | Y |
| 28 | 注册用户详情 | POST | `/query/regist/user/detail` | - | - | Y |
| 29 | 用户PR详情 | POST | `/query/user/pr/detail` | - | - | Y |
| 30 | 筛选条件 | POST | `/query/filter` | - | - | Y |
| 31 | 组织加入详情 | POST | `/query/company/join` | - | - | Y |
| 32 | 组织详情 | POST | `/query/company/detail` | - | - | Y |
| 33 | 组织趋势 | POST | `/query/trend/company` | - | - | Y |
| 34 | 贡献 | POST | `/query/contributes` | - | - | Y |
| 35 | 贡献TOPN明细 | POST | `/query/contributes/topn/item` | - | - | Y |
| 36 | 贡献TOPN汇总 | POST | `/query/contributes/topn/total` | - | - | Y |
| 37 | 贡献汇总分页 | POST | `/query/contributes/page` | - | - | Y |
| 38 | 账号趋势 | POST | `/query/trend/account` | - | - | Y |

### 邮件发送 (1 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | send | POST | `/email/send` | - | - | - |

### 项目总览看板 (28 个接口)

| 序号 | 接口名称 | 方法 | 路径 | 必填参数 | 校验规则 | 请求体 |
|------|----------|------|------|----------|----------|--------|
| 1 | CI构建信息分页 | POST | `/project/ci/metric` | - | - | Y |
| 2 | CI每周构建信息 | POST | `/project/ci/build/info` | - | - | Y |
| 3 | ci状态报告 | POST | `/project/ci/metric/bak` | - | - | Y |
| 4 | clone数据查询 | GET | `/project/clone` | community, start, end | community, start, end | - |
| 5 | token校验 | GET | `/project/token/verify` | token | - | - |
| 6 | token获取 | GET | `/project/token/query` | - | - | - |
| 7 | 仓库列表 | POST | `/project/repolist` | - | - | Y |
| 8 | 合入pr趋势 | POST | `/project/trend/pr` | - | - | Y |
| 9 | 响应时间 | POST | `/project/response-time` | - | - | Y |
| 10 | 审核时间 | GET | `/project/review` | community | community | - |
| 11 | 审阅PR | POST | `/project/review_pr_total` | - | - | Y |
| 12 | 撬动比 | POST | `/project/leverage-ratio` | - | - | Y |
| 13 | 汇总看板 | POST | `/project/summary` | - | - | Y |
| 14 | 注册汇总 | POST | `/project/total_regist` | - | - | Y |
| 15 | 活跃度 | POST | `/project/active` | - | - | Y |
| 16 | 社区热点 | POST | `/project/hotspot` | - | - | Y |
| 17 | 社区热点发送邮件 | POST | `/project/hotspot/send` | html_file, community, image_top, image_mid, image_end | - | - |
| 18 | 社区热点同步看板 | POST | `/project/hotspot/sync` | - | - | Y |
| 19 | 触发DataArts作业(AKSK) | POST | `/project/dataarts/run-job` | - | - | - |
| 20 | 贡献公司pr_topn | POST | `/project/topn/company/pr` | - | - | Y |
| 21 | 贡献者open_pr_topn(分页) | POST | `/project/topn/user/open-pr/page` | - | - | Y |
| 22 | 贡献者open_pr_topn | POST | `/project/topn/user/open-pr` | - | - | Y |
| 23 | 贡献者pr_topn(分页) | POST | `/project/topn/user/pr/page` | - | - | Y |
| 24 | 贡献者pr_topn | POST | `/project/topn/user/pr` | - | - | Y |
| 25 | 贡献者review_topn(分页) | POST | `/project/topn/user/review/page` | - | - | Y |
| 26 | 贡献者review_topn | POST | `/project/topn/user/review` | - | - | Y |
| 27 | 贡献者每日趋势 | POST | `/project/user/daily-trend` | - | - | Y |
| 28 | 邮件列表 | POST | `/project/email_list_info` | - | - | Y |


## 测试覆盖矩阵

| 测试场景 | 覆盖接口数 | 说明 |
|----------|------------|------|
| 正向测试-正常参数 | 365 | 所有接口 |
| 正向测试-完整参数 | 365 | 所有接口 |
| 反向测试-缺失必填 | 117 | 有必填参数的接口 |
| 反向测试-非法格式 | 139 | 有校验规则的接口 |
| 响应结构校验 | 307 | 有响应示例的接口 |