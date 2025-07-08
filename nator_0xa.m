clear
% 指定 Excel 文件的完整路径  
filename = 'D:\西安交通大学wps\dataview\done\roc数据\0x-a.xlsx';  
  
% 使用 readtable 读取 Excel 文件  
data_table = readtable(filename);  
  
% 假设 Excel 文件中第九列为 precision，第七列为 recall  
precision = data_table{:, 9}; % 提取 precision 数据  
recall = data_table{:, 7}; % 提取 recall 数据  


% 验证数据长度是否为100  
if length(precision) ~= 101 || length(recall) ~= 101  
    error('数据长度不是100，请检查数据或 Excel 文件。');  
end  
  
% 绘制散点图  
figure; % 创建一个新的图形窗口  

% 创建一个网格来覆盖精确度和召回率空间  
[precision_grid, recall_grid] = meshgrid(linspace(0, 1, 100), linspace(0, 1, 100));  
  
% 计算网格上每个点的F1分数  
f1_grid = 2 * precision_grid .* recall_grid ./ (precision_grid + recall_grid);  
f1_grid(isnan(f1_grid)) = 0; % 处理分母为0的情况  
  
% 绘制F1分数的等高线  
contour(precision_grid, recall_grid, f1_grid, [0.1:0.1:0.9]); % 绘制从0.1到0.9的等高线  

% 添加颜色条来解释等高线  
cbar = colorbar; % 获取颜色条对象  
caxis([min(f1_grid(:)), max(f1_grid(:))]); % 设置颜色轴范围以匹配 F1 分数的范围  
cbar.Title.String = 'F1 Score'; % 为颜色条设置标题  

a=scatter(recall, precision, 'filled', 'DisplayName', 'SCIF'); % 使用 filled 散点标记  
hold on; % 保持当前图形，以便在上面添加其他元素  
% 添加标题，并增大字号到14  
title('0.2x-amplification', 'FontSize', 16);  
  
% 添加x轴标签，并增大字号到12  
xlabel('Recall', 'FontSize', 16);  
  
% 添加y轴标签，并增大字号到12  
ylabel('Precision', 'FontSize', 16);
  
% 创建一个网格来覆盖精确度和召回率空间  
[precision_grid, recall_grid] = meshgrid(linspace(0, 1, 100), linspace(0, 1, 100));  
  
% 计算网格上每个点的F1分数  
f1_grid = 2 * precision_grid .* recall_grid ./ (precision_grid + recall_grid);  
f1_grid(isnan(f1_grid)) = 0; % 处理分母为0的情况  
  
% 绘制F1分数的等高线  
contour(precision_grid, recall_grid, f1_grid, [0.1:0.1:0.9]); % 绘制从0.1到0.9的等高线  



% 添加颜色条来解释等高线  
cbar = colorbar; % 获取颜色条对象  
caxis([min(f1_grid(:)), max(f1_grid(:))]); % 设置颜色轴范围以匹配 F1 分数的范围  
cbar.Title.String = 'F1 Score'; % 为颜色条设置标题  
cbar.Title.FontSize = 14; % 设置为你想要的字号大小

% 显示网格  
grid on;  


% 指定三个txt文件的完整路径  
filename1 = 'D:\西安交通大学wps\cnvnator\0.2xa\0.2xa1\results.txt';  
filename2 = 'D:\西安交通大学wps\cnvnator\0.2xa\0.2xa2\results.txt';  
filename3 = 'D:\西安交通大学wps\cnvnator\0.2xa\0.2xa3\results.txt';  
  
% 读取三个txt文件的数据并合并  
data1 = readmatrix(filename1, 'Range', 'A:B'); % 假设数据在A和B列  
data2 = readmatrix(filename2, 'Range', 'A:B');  
data3 = readmatrix(filename3, 'Range', 'A:B');  
  
% 合并数据  
combined_data = [data1; data2; data3];  
  
% 提取precision和recall  
precision_extra = combined_data(:, 1);  
recall_extra = combined_data(:, 2);  
  
% 在绘制完网格和等高线后，添加额外的散点  
b=scatter(recall_extra, precision_extra, 'filled', 'DisplayName', 'CNVnator'); % 使用 filled 散点标记并添加图例  
  
% 创建图例，只包括指定的对象句柄  
legend([a b], {'IFMF-CNV', 'CNVnator'});
set(legend, 'FontSize', 14);

% 保存图片
saveas(1,'E:\孤立森林matlab\CNVnator仿真数据与算法比较等高线图及代码\sc_nator_F1_0.2a.png')
