library(DNAcopy)
library(ggplot2)

# 定义处理函数
cal_log2ratio <- function(bin_read_count, average_read_count) {
  # 添加极小值防止除以0
  ratio <- (bin_read_count + 1e-6) / (average_read_count + 1e-6)
  log2(ratio)
}

cal_average_read_count <- function(col) {
  sum(col) / length(col)
}

# 设置路径
datafolder <- "/mnt/hgfs/毕设数据/realdata/rd"
outputfolder <- "/home/florence/results/scope_results/realdata"
if (!dir.exists(outputfolder)) dir.create(outputfolder, recursive = TRUE)

# 获取文件列表
file_list <- list.files(path = datafolder, 
                       pattern = "\\.txt$", 
                       full.names = TRUE)

# 存储结果
all_segments <- list()

for (file_path in file_list) {
  tryCatch({
    # 提取样本ID
    sample_id <- tools::file_path_sans_ext(basename(file_path))
    
    # 读取数据
    raw_data <- read.table(file_path, header = FALSE, stringsAsFactors = FALSE)
    
    # 计算log2ratio
    avg_rc <- cal_average_read_count(raw_data$V4)
    raw_data$log2ratio <- cal_log2ratio(raw_data$V4, avg_rc)
    
    # 创建CNA对象
    cna_obj <- CNA(
      genomdat = raw_data$log2ratio,
      chrom = raw_data$V1,
      maploc = raw_data$V2,
      data.type = "logratio",
      sampleid = sample_id  # 关键修改：添加样本ID
    )
    
    # 分段分析
    smoothed_cna <- smooth.CNA(cna_obj)
    segmented <- segment(smoothed_cna, alpha = 0.01, undo.splits = "sdundo")
    
    # 添加样本ID到结果
    seg_output <- segmented$output
    seg_output$sample_id <- sample_id
    seg_output$absolute_cnv <- round(2 * 2^seg_output$seg.mean, 2)    
    # 存储结果
    all_segments[[sample_id]] <- seg_output
    
    # 保存个体结果
    write.csv(
      seg_output,
      file = file.path(outputfolder, paste0(sample_id, "_segments.csv")),
      row.names = FALSE
    )
    
  }, error = function(e) {
    message(paste("Error processing", file_path, ":", e$message))
  })
}


# 合并所有结果
final_output <- do.call(rbind, all_segments)

# 保存最终结果
write.csv(
  final_output,
  file = file.path(outputfolder, "combined_segments.csv"),
  row.names = FALSE
)
