library(pROC)
library(ggplot2)
library(cowplot)
#install.packages('cowplot')
library(RColorBrewer)
library(readxl)
brewer.pal(9,"Purples")

setwd("D:\\西安交通大学wps\\dataview\\done\\roc数据")
# 读取数据集
data <- read_excel('0x-a.xlsx')
roc_data <- data.frame(
  FPR = 1 - data$`Specificity`,  # FPR 是 1 减去特异性
  TPR = data$Sencitivity           # TPR（真正类率）即灵敏度或召回率
)

# 计算AUC
auc_value <- sum((roc_data$TPR[2:nrow(roc_data)] + roc_data$TPR[1:(nrow(roc_data)-1)]) *
                   (roc_data$FPR[2:nrow(roc_data)] - roc_data$FPR[1:(nrow(roc_data)-1)])) / 2

# 创建数据框，用于绘制ROC曲线和填充区域
roc_plot_data <- roc_data
roc_plot_data <- rbind(roc_plot_data, data.frame(FPR = 1, TPR = 1)) # 添加(1,1)点以闭合区域
roc_plot_data <- rbind(roc_plot_data, data.frame(FPR = c(0, 1), TPR = c(0, 0))) # 添加从(0,0)到(1,0)的线段

# 绘制ROC曲线并填充右下部分
roc_plot <- ggplot(roc_data, aes(x = FPR, y = TPR)) +
  geom_line(aes(x = FPR, y = TPR),color = "#FD8D3C",  size = 1.2) + #
  geom_ribbon(aes(x = FPR, ymin = 0, ymax = TPR), fill = "#FFFFCC" , alpha = 0) +#,不填充背景，将透明度调整为0
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "#A2A2A2") +
  xlab("FPR(1-Specificity)") +
  ylab("TPR(Sencitivity)") +
  ggtitle("0.2x-amplification CNV") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = rel(2)), # 调整标题大小
        plot.margin = margin(20, 20, 20, 20, "pt"), # 减少边距
        axis.title = element_text(size = rel(1.5)), # 增大坐标轴标题大小
        axis.text = element_text(size = rel(2)),
        axis.line = element_line(size = 2))+
  annotate("text", x = 0.75, y = 0.3, label = paste("AUC RD: ", -round(auc_value, 5)), size = 10) # 添加AUC值


# 显示图表
print(roc_plot)

#保存图片

# 使用 ggsave 保存图像
ggsave(filename = "D:/西安交通大学wps/dataview/R/仿真数据ROC代码/ROC_0.2a.png",
       plot = roc_plot,
       width = 8,
       height = 8,
       units = "in",
       dpi = 100)



