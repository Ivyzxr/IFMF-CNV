% 直接在MATLAB中创建数据矩阵  
data = [  
    0 0.94379 0.94461 0.94384;  
    0.01 0.9459 0.94461 0.94384;  
    0.02 0.94728 0.94461 0.94384;  
    0.03 0.94883 0.94461 0.94384;  
    0.04 0.94974 0.94461 0.94384;  
    0.05 0.95037 0.94461 0.94384;  
    0.06 0.95079 0.94461 0.94384;  
    0.07 0.95111 0.94461 0.94384;  
    0.08 0.95127 0.94461 0.94384;  
    0.09 0.95133 0.94461 0.94384;  
    0.1 0.95132 0.94461 0.94384;  
    0.11 0.95125 0.94461 0.94384  
];  
  
% 提取x和y值  
x = data(:, 1);  
y1 = data(:, 2);  
y2 = data(:, 3);  
y3 = data(:, 4);  
  
% 找出多特征AUC曲线上的最大值点  
%[~, max_y1_index]：
%在MATLAB中，~ 符号用作占位符，用于忽略不需要的输出。在这个语句中，max 函数返回的第一个输出（最大值本身）被 ~ 忽略，因为我们只对最大值的索引感兴趣。
% max_y1_index 是一个变量，用于存储 y1 中最大值的索引。

[~, max_y1_index] = max(y1);  
max_y1_x = x(max_y1_index);  
max_y1_y = y1(max_y1_index);  
  
% 设置绘图参数和绘图  
figure; % 创建一个新的图形窗口  
set(gca, 'FontSize', 14); % 设置坐标轴字体大小  
xlabel('阈值差异', 'FontSize', 16); % 设置x轴标签  
ylabel('AUC值', 'FontSize', 16); % 设置y轴标签  
title('0.2x AUC比较', 'FontSize', 18); % 设置图形标题  
xlim([-0.10, 0.11]); % 设置x轴范围  
ylim([0.94, 0.96]); % 设置y轴范围  
grid on; % 添加网格线  
  
% 绘制第一个指标的折线图  
plot(x, y1, 'LineWidth', 2, 'Color', '#007BFF'); % 绘制折线图，设置线条粗细和颜色  
hold on; % 保持当前图形，以便继续绘制  
  
% 添加第二个和第三个指标的折线图到同一个图上  
plot(x, y2, 'LineWidth', 2, 'Color', '#DC3545');  
plot(x, y3, 'LineWidth', 2, 'Color', '#FFC107');  
  
% 标注出多特征AUC曲线上的最大值点  
plot(max_y1_x, max_y1_y, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', '#007BFF'); % 绘制最大值点  
  
% 添加文本标签显示最大值点的坐标  
text(max_y1_x, max_y1_y - 0.001, sprintf('x=%.3f, AUC=%.3f', max_y1_x, max_y1_y), ...  
    'HorizontalAlignment', 'center', 'Color', 'black', 'FontSize', 14); % 注意y坐标稍微向下调整以避免重叠
  
% 显示最大值点的坐标  
fprintf('最大值点的坐标是 (x: %.3f, y: %.3f)\n', max_y1_x, max_y1_y);

% 添加图例  
legend({'差异阈值', '单特征', '组合特征'}, 'Location', 'northwest');




