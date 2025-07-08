library(AneuFinder)
library(BSgenome.Hsapiens.UCSC.hg19)
datafolder <- "/mnt/hgfs/毕设数据/5x-a1/cnv"
outputfolder <- "/home/florence/aneufinder_data/5xa1"  # output
Aneufinder(
  inputfolder = datafolder,
  outputfolder = outputfolder,
  assembly = 'hg19',                   # consistent with the reference genome used for BAM file alignment
  numCPU = 1,                          # 
  binsizes = 1000,                       # bins 100kb（According depths）
  chromosomes = 'chr7',                # only chr7（UCSC fomat）
  blacklist = NULL,                    #  NULL
  correction.method = 'GC',
  GC.BSgenome = BSgenome.Hsapiens.UCSC.hg19,
  refine.breakpoints = FALSE,
  method = 'dnacopy'
)
