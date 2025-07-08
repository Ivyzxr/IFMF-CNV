#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(HMMcopy))
suppressPackageStartupMessages(library(optparse))

# ----------------- 解析命令行参数 -----------------
option_list <- list(
  make_option(c("-r", "--read"), type = "character", help = "Path to readcounts WIG file"),
  make_option(c("-g", "--gc"), type = "character", help = "Path to GC content WIG file"),
  make_option(c("-m", "--map"), type = "character", help = "Path to mappability WIG file"),
  make_option(c("-o", "--output"), type = "character", help = "Output TXT file path")
)
opt <- parse_args(OptionParser(option_list = option_list))

# ----------------- 数据加载与处理 -----------------
tryCatch({
  # 合并 WIG 文件
  ranged_data <- wigsToRangedData(opt$read, opt$gc, opt$map)
  
  # 校正读段数
  corrected_data <- correctReadcount(ranged_data)
  
  # 分段分析
  segments <- HMMsegment(corrected_data, verbose = FALSE)
  
  # 保存结果
  write.table(segments$segs, opt$output, sep = "\t", quote = FALSE, row.names = FALSE)
  message(paste("Results saved to", opt$output))
}, error = function(e) {
  stop(paste("Error in processing:", e$message))
})
