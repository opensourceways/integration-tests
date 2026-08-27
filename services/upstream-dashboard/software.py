"""软件列表 API 路由。"""

from fastapi import APIRouter, HTTPException, Query

from app.database import get_dao
from app.schemas import (
    AddCollectSourceRequest,
    AddManualEvidenceRequest,
    CollectSourceItem,
    SetCollectSourceEnabledRequest,
    SoftwareListResponse,
)
from app.services.software import (
    COLLECT_SOURCE_DIMENSIONS,
    FILTER_LEVELS,
    MANUAL_DIMENSIONS,
    RESULT_CATALOG,
    software_service,
)

router = APIRouter(prefix="/software", tags=["software"])


@router.get("", response_model=SoftwareListResponse)
def list_software(
    domain: str | None = Query(None, description="按域筛选 (kunpeng/ascend)"),
    category: str | None = Query(None, description="按昇腾分类筛选 (native/basic/emerging)"),
    support_level: str | None = Query(None, description="按生效等级筛选（昇腾语义 upstream/non_upstream/unsupported）"),
    name: str | None = Query(None, description="按软件名模糊匹配"),
    sort_by: str | None = Query(None, description="排序字段 (name/level)"),
    sort_order: str = Query("asc", description="排序方向 (asc/desc)"),
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(100, ge=1, le=500, description="每页条数"),
):
    """获取软件列表，返回基本信息、各版本评估与派生等级。"""
    items, total = software_service.list_software(
        domain=domain,
        category=category,
        support_level=support_level,
        name=name,
        sort_by=sort_by,
        sort_order=sort_order,
        page=page,
        page_size=page_size,
    )
    return SoftwareListResponse(
        items=items,
        total=total,
        page=page,
        page_size=page_size,
    )


@router.get("/levels")
def get_levels():
    """返回各域的等级筛选值域，供前端筛选下拉按域联动。

    鲲鹏返回 L1-L5；昇腾返回三种语义（upstream / non_upstream / unsupported），
    语义到实际 L 值的映射见 ASCEND_FILTER_LEVELS。
    """
    return {
        "domains": {
            d: {"levels": levels}
            for d, levels in FILTER_LEVELS.items()
        }
    }


def _require_software(software_id: int) -> dict:
    """取软件记录，不存在时 404。"""
    row = get_dao().find_by_id(software_id)
    if not row:
        raise HTTPException(status_code=404, detail="软件不存在")
    return row


@router.post("/{software_id}/manual-evidence")
def add_manual_evidence(software_id: int, body: AddManualEvidenceRequest):
    """人工录入版本&等级&证据，追加到 software_version 的 evidence 数组。

    版本 / 等级 / 维度必填（请求模型保证），结论选填默认 supported，
    依据与来源选填。
    """
    _require_software(software_id)

    version = (body.version or "").strip()
    if not version:
        raise HTTPException(status_code=400, detail="版本不能为空")

    # 版本只能从软件已有版本中选择，禁止随意新建（避免新建行抢占派生等级）
    existing_versions = {
        v["version"]
        for v in get_dao().get_versions_for_software_ids([software_id]).get(software_id, [])
    }
    if version not in existing_versions:
        raise HTTPException(
            status_code=400,
            detail=f"版本 '{version}' 不属于该软件已有版本，请从已有版本中选择",
        )

    if body.support_level not in ("L1", "L2", "L3", "L4", "L5"):
        raise HTTPException(
            status_code=400,
            detail=f"等级 '{body.support_level}' 非法，值域 L1-L5",
        )
    if body.dimension not in MANUAL_DIMENSIONS:
        raise HTTPException(
            status_code=400,
            detail=f"维度 '{body.dimension}' 非法，可选：{', '.join(MANUAL_DIMENSIONS)}",
        )
    if body.result not in RESULT_CATALOG:
        raise HTTPException(
            status_code=400,
            detail=f"结论 '{body.result}' 非法，可选：{', '.join(RESULT_CATALOG)}",
        )

    software_service.add_manual_evidence(
        software_id,
        version=version,
        support_level=body.support_level,
        dimension=body.dimension,
        result=body.result,
        excerpt=body.excerpt,
        source_url=body.source_url,
    )
    return {"ok": True}


@router.get("/{software_id}/evidences")
def get_evidences(software_id: int):
    """取软件各版本的证据链，按版本分组，供前端展开查看判定依据。

    证据已内嵌在 software_version（每等级一个 JSON 数组），此接口按版本汇总
    并补充展示元信息（check 标签 / result 标签）。
    """
    _require_software(software_id)
    return {"versions": software_service.get_evidence_detail(software_id)}


@router.get("/{software_id}/collect-sources",
            response_model=list[CollectSourceItem])
def list_collect_sources(software_id: int):
    """取软件的全部采集来源，供前端维护（启用/禁用/新增）。"""
    _require_software(software_id)
    return software_service.list_collect_sources(software_id)


@router.post("/{software_id}/collect-sources")
def add_collect_source(software_id: int, body: AddCollectSourceRequest):
    """新增一条采集来源；相同（软件、维度、地址）已存在时提示重复。

    dimension 值域 ci/doc/plugin（区别于人工证据维度六种）。
    """
    _require_software(software_id)

    dimension = (body.dimension or "").strip()
    source_url = (body.source_url or "").strip()
    if dimension not in COLLECT_SOURCE_DIMENSIONS:
        raise HTTPException(
            status_code=400,
            detail=f"维度 '{body.dimension}' 非法，可选：{', '.join(COLLECT_SOURCE_DIMENSIONS)}",
        )
    if not source_url:
        raise HTTPException(status_code=400, detail="source_url 不能为空")

    item = software_service.add_collect_source(
        software_id, dimension, source_url, body.is_enabled, body.remark,
    )
    if item is None:
        raise HTTPException(
            status_code=409,
            detail=f"采集来源已存在（{dimension} / {source_url}）",
        )
    return item


@router.patch("/{software_id}/collect-sources/{source_id}")
def set_collect_source_enabled(software_id: int, source_id: int,
                               body: SetCollectSourceEnabledRequest):
    """启用/禁用一条采集来源。"""
    _require_software(software_id)
    ok = software_service.set_collect_source_enabled(
        software_id, source_id, body.is_enabled,
    )
    if not ok:
        raise HTTPException(status_code=404, detail="采集来源不存在")
    return {"ok": True}
