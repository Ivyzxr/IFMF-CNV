library(AneuFinder)
library(BSgenome.Hsapiens.UCSC.hg19)
datafolder <- "/mnt/hgfs/毕设数据/5x-a1/cnv"
outputfolder <- "/home/florence/aneufinder_data/5xa1"  # 使用临时目录作为输出文件夹
Aneufinder(
  inputfolder = datafolder,
  outputfolder = outputfolder,
  assembly = 'hg19',                   # 与 BAM 文件参考基因组一致
  numCPU = 1,                          # 单线程避免并行错误
  binsizes = 1000,                       # 分箱大小 100kb（根据深度调整）
  chromosomes = 'chr7',                # 仅分析 chr7（UCSC 格式）
  blacklist = NULL,                    # 若无 chr7 黑名单区域可设为 NULL
  correction.method = 'GC',
  GC.BSgenome = BSgenome.Hsapiens.UCSC.hg19,
  refine.breakpoints = FALSE,
  method = 'dnacopy'
)
