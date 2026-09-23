#!/usr/bin/env bash
# 连续两轮完整测试，检验套件稳定性
#
# 两轮之间插入 70s 间隔：验证码冷却计时器是 conftest 的模块级全局变量，
# 跨 pytest 进程不保留，第二轮不知道第一轮刚发过码。若不隔离，第二轮
# 首个写操作可能撞后端 65s 限流而失败——那是跨进程状态丢失，
# 不是套件本身不稳定，会污染本次稳定性结论。

set -u
PY="../.venv2/Scripts/python.exe"
export PYTHONUTF8=1

for round in 1 2; do
  echo "═══════════════════════════════════════════════════════"
  echo "第 ${round} 轮开始：$(date '+%H:%M:%S')"
  echo "═══════════════════════════════════════════════════════"

  $PY -m pytest tests/ \
      --html="test_report_round${round}.html" --self-contained-html \
      > "test_round${round}.log" 2>&1
  echo "第 ${round} 轮退出码: $?"
  tail -1 "test_round${round}.log"

  # 每轮结束后核对数据是否恢复初始状态
  $PY verify_cleanup.py > "verify_round${round}.log" 2>&1
  echo "数据核对: $(grep -E '✅|❌' "verify_round${round}.log" | tail -1)"

  if [ "$round" = "1" ]; then
    echo "--- 间隔 70s，隔离跨进程验证码限流 ---"
    sleep 70
  fi
done

echo "═══════════════════════════════════════════════════════"
echo "两轮汇总"
echo "═══════════════════════════════════════════════════════"
for round in 1 2; do
  printf "第 %s 轮: %s\n" "$round" "$(tail -1 "test_round${round}.log")"
  printf "        RERUN 次数: %s\n" "$(grep -c 'RERUN' "test_round${round}.log")"
done
