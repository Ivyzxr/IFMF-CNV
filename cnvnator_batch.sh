#!/bin/bash

# --------------------------
# CNVnator 批量分析脚本
# --------------------------

# 定义输入和路径（按需修改！）
BAM_FILES=(/mnt/hgfs/毕设数据/realdata/*.bam)  # BAM 文件路径（支持通配符）
REF_DIR="/home/florence/reference"        # 参考基因组目录（含 chrX.fa）
OUT_ROOT_DIR="/home/florence/cnvnator_results/realdata" # 输出根目录
BIN_SIZE=1000                   # 分箱大小
THREADS=4                       # 并行线程数

# 创建输出目录
mkdir -p "$OUT_ROOT_DIR/logs"

# 循环处理每个 BAM 文件
for BAM in "${BAM_FILES[@]}"; do
  # 提取样本名（假设 BAM 文件名为 sample1.bam）
  SAMPLE=$(basename "$BAM" .bam)
  SAMPLE_DIR="$OUT_ROOT_DIR/$SAMPLE"
  mkdir -p "$SAMPLE_DIR"

  # 定义输出文件名
  ROOT_FILE="$SAMPLE_DIR/${SAMPLE}.root"
  LOG_FILE="$OUT_ROOT_DIR/logs/${SAMPLE}.log"

  # 记录开始时间
  echo "[$(date)] Processing $SAMPLE ..." | tee -a "$LOG_FILE"

  # Step 1: 生成直方文件 (-his)
  echo "[$(date)] Running -his ..." | tee -a "$LOG_FILE"
  cnvnator -root "$ROOT_FILE"  -tree "$BAM" 2>&1 | tee -a "$LOG_FILE"
  cnvnator -root "$ROOT_FILE" -his "$BIN_SIZE" -d "$REF_DIR" 2>&1 | tee -a "$LOG_FILE"

  # 检查上一步是否成功
  if [ $? -ne 0 ]; then
    echo "[ERROR] -his failed for $SAMPLE. Check $LOG_FILE." | tee -a "$LOG_FILE"
    continue
  fi

  # Step 2: 统计校正 (-stat)
  echo "[$(date)] Running -stat ..." | tee -a "$LOG_FILE"
  cnvnator -root "$ROOT_FILE" -stat "$BIN_SIZE" 2>&1 | tee -a "$LOG_FILE"

  # Step 3: 分割区域 (-partition)
  echo "[$(date)] Running -partition ..." | tee -a "$LOG_FILE"
  cnvnator -root "$ROOT_FILE" -partition "$BIN_SIZE"  2>&1 | tee -a "$LOG_FILE"

  # Step 4: 调用 CNV (-call)
  echo "[$(date)] Running -call ..." | tee -a "$LOG_FILE"
  cnvnator -root "$ROOT_FILE" -call "$BIN_SIZE" > "$SAMPLE_DIR/${SAMPLE}_cnvs.txt" 2>&1 

  echo "[$(date)] Finished $SAMPLE. Results in $SAMPLE_DIR" | tee -a "$LOG_FILE"
done

echo "All done! Results saved to $OUT_ROOT_DIR"
