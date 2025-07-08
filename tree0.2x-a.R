install.packages("readxl")
library(BiocManager)

install.packages("TreeAndLeaf")
BiocManager::install("TreeAndLeaf")
BiocManager::install("RedeR", force = TRUE)

library(readxl)
library(TreeAndLeaf)
library(RedeR)
library(igraph)
library(RColorBrewer)
setwd("D:/西安交通大学wps/dataview/done/tree数据")
# 导入第一个文件并删除第一行
data1 <- read_excel("0x-a1.xls")[-1, ]
# 导入第二个文件并删除第一行
data2 <- read_excel("0x-a2.xls")[-1, ]
# 导入第三个文件并删除第一行
data3 <- read_excel("0x-a3.xls")[-1, ]
# 按列合并三个文件的数据
data <- cbind(data1, data2, data3)
data <- t(data)
# 创建一个字符向量，包含所需的行名
new_row_names <- c(paste0("a", 1:30), paste0("b", 1:30), paste0("c", 1:30))
# 将新的行名应用到数据框中
rownames(data) <- new_row_names
hc <- hclust(dist(data))
#### 画成矩形聚类图####

# 将 hclust 对象转换为 dendrogram 对象
dend <- as.dendrogram(hc)
# 使用 dendextend 包对树状图进行颜色编码
library(dendextend)
dend_colored <- color_branches(dend, k = 3)

# 设置簇标签大小为较小的值（如果需要的话）
dend_colored <- set(dend_colored, "labels", NULL)#移除树状图的标签

# 设置图形参数，增大标题和坐标轴标签的大小
par(cex.main = 1, cex.axis = 1)

# 绘制水平的彩色树状图，并设置 labels 为 FALSE 以去除样本标签
plot(dend_colored, main = "Clustering based on CNV detection results", horiz = TRUE)

#plot(dend_colored, main = "Clustering based on scores", horiz = TRUE)

#保存数据

png(
  filename = "D:/西安交通大学wps/dataview/R/仿真数据tree聚类代码/tree_0.2a.png", # 文件名称
  width = 600,           # 宽
  height = 400,          # 高
  units = "px",          # 单位
  bg = "white",          # 背景颜色
  res = 100)              # 分辨率
# 绘制水平的彩色树状图，并设置 labels 为 FALSE 以去除样本标签
plot(dend_colored, main = "Clustering based on CNV amplification results", horiz = TRUE)
dev.off()







#### 画成圆形聚类图####

sg <- treeAndLeaf(hc) # 转化为树和叶的形式，其实是转化为igraph对象

rdp <- RedPort()
calld(rdp)
resetd(rdp)
addGraph(obj = rdp, g = sg)
relax(rdp, p1=25, p2=200, p3=5, p4=100, p5=5,p6=10,p7=10,p8=100,p9=10) # 调节图形
