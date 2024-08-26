function [precision,recall,f1_score,specificity,score]=run_iForest(data)
%% load data
ADLabels=data(:,end);%标签列
Data=data(:,1:end-1);%特征列

 
%% Run iForest

rounds = 20; 
NumTree = 100; 
NumSub = 256; 
NumDim = size(Data, 2); %统计特征的个数 注意现在是大写的D
%auc = zeros(rounds, 1);
%rseed = zeros(rounds, 1);
P = zeros(rounds, 1);
R= zeros(rounds, 1);
F1= zeros(rounds, 1);
thred=zeros(rounds,1);


n = size(Data, 1);  % 样本数
c = 2 * (log(n - 1) + 0.5772156649) - 2 * (n - 1) / n;  % 常数
Forest = IsolationForest(Data, NumTree, NumSub, NumDim, 2023);
heightSum = IsolationEstimation(data, Forest);
avgHeight = mean(heightSum, 2);
score = 2.^(-avgHeight / c);





% for i = 1:101
%         % 设置阈值，从0.5到1，间隔0.01
%         threshold = (i - 1) * 0.01;
% 
%         % 根据阈值进行二分类预测
%         predictions = score > threshold;
% 
%         % 计算 TP, FP, FN
%         tp = sum(predictions == 1 & (ADLabels == 1 | ADLabels == -1));
%         fp = sum(predictions == 1 & ADLabels == 0);
%         fn = sum(predictions == 0 & (ADLabels == 1 | ADLabels == -1));
%         tn = sum(predictions == 0 & ADLabels == 0);
% 
%         % 计算 Precision, Recall, F1 Score
%         precision = tp / (tp + fp);
%         recall = tp / (tp + fn);
%         specificity = tn / (tn + fp);
%         f1_score = 2 * (precision * recall) / (precision + recall);
% 
%          results(i, 1) = precision;
%          results(i, 2) = recall;
%          results(i, 3) = f1_score;   
%          results(i, 4) = specificity;
% end
%        
thresholds = 0.7;
predictions = score > thresholds;
 %       计算 TP, FP, FN
        tp = sum(predictions == 1 & (ADLabels == 1 | ADLabels == -1));
        fp = sum(predictions == 1 & ADLabels == 0);
        fn = sum(predictions == 0 & (ADLabels == 1 | ADLabels == -1));
        tn = sum(predictions == 0 & ADLabels == 0);

        % 计算 Precision, Recall, F1 Score
        precision = tp / (tp + fp);
        recall = tp / (tp + fn);
        specificity = tn / (tn + fp);
        f1_score = 2 * (precision * recall) / (precision + recall);





