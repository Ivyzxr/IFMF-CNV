%制作标签数据集并调用孤立森立算法
clear
P=[];
F1=[];
R=[];
traindata=[];
outdata = [];
addpath('D:\matlab\toolbox\')
tic
numDatasets = 29; % 假设有30个数据集
thresholds = 0:0.01:1; % 阈值范围
%results = zeros(length(thresholds), 5 + 4 * (numDatasets+1)); % 在外部循环之前初始化结果矩阵
for m = 0:numDatasets
    rddir='D:\西安交通大学wps\毕设\仿真数据\0.2x-d1\rd';
    addpath(rddir);
    filename=strcat('cnv',num2str(m));
    filename=strcat(filename,'_rd.txt');
    data = importdata(filename);
    data=data.data;
    data(:,8)=0;
   
    rddir='D:\西安交通大学wps\毕设\仿真数据\0.2x-d1\pem';
    addpath(rddir); 
    filename=strcat('cnv',num2str(m));
    filename=strcat(filename,'_pem.txt');
    data2 = importdata(filename);
    data2 = data2.data;
    rmpath(rddir);


%     标签制作
    cndir='D:\西安交通大学wps\毕设\仿真数据\0.2x-d1';
    addpath(cndir);   
    filename1=strcat('copynumber.bed');
    cn=importdata(filename1);
    cn=cn.data;
    index1=cn(:,4)>0;
    cng1=cn(index1,:);
   for j=1:1:length(cng1)
        pstart=cng1(j,1);
        pend=cng1(j,2);
        k1=min(find(data(:,1)>pstart));
        ratio1=(data(k1-1,2)-pstart)/data(k1-1,5);
        if ratio1>0.5
            data(k1-1,8)=1;
        end
        k2=min(find(data(:,1)>pend));
        ratio2=(pend-data(k2-1,1))/data(k2-1,5);
        if ratio2>0.5
            data(k2-1,8)=1;
        end
        for k=k1:1:k2-2
            data(k,8)=1;
        end
    end
    index2=cn(:,4)==0;
    cng2=cn(index2,:);
      for j=1:1:length(cng2)
        pstart=cng2(j,1);
        pend=cng2(j,2);
        k3=min(find(data(:,1)>pstart));
        ratio1=(data(k3-1,2)-pstart)/data(k3-1,5);
        if ratio1>0.5
            data(k3-1,8)=-1;
        end
        k4=min(find(data(:,1)>pend));
        ratio2=(pend-data(k4-1,1))/data(k4-1,5);
        if ratio2>0.5
            data(k4-1,8)=-1;
        end
        for kk=k3:1:k4-2
            data(kk,8)=-1;
        end
      end
    rmpath(cndir);
   

% 多特征
 traindata=[data(:,7),data2(:,5),data(:,8)];
 


% 单RD  
%  traindata=[data(:,7),data(:,8)];
 
% 画树图数据
   [precision,recall,f1,specificity,predictions]=run_iForest(traindata);
   treeresults(:,m+1) = predictions;

%    % 跑roc图数据
%     [precision,recall,f1,specificity,results1]=run_iForest(traindata);    
%     results(:,5 + 4 *m + 1 : 5 + 4 * m + 4) = results1;


end


% % roc数据
% % 添加阈值和计算每个阈值下的平均Precision、Recall、F1 Score
% for i = 1:length(thresholds)
%     results(i, 1) = thresholds(i);
%     results(i, 2) = mean(results(i, 6:4:end)); % 平均Precision
%     results(i, 3) = mean(results(i, 7:4:end)); % 平均Recall
%     results(i, 4) = mean(results(i, 8:4:end)); % 平均F1 Score
%     results(i, 5) = mean(results(i, 9:4:end)); % 平均Specificity
% end

%保存数据
cndir='D:\西安交通大学wps\毕设\仿真数据';

addpath(cndir); 

%%保存结果到Excel文件
filename = 'D:\西安交通大学wps\dataview\done\tree数据\0.2x-d1-scores';
header = num2cell(1:30);
xlswrite(filename, [header; num2cell(treeresults)]);
  

%   filename = 'D:\西安交通大学wps\dataview\test';
%   header = {'Threshold', 'Avg Precision', 'Avg Recall', 'Avg F1 Score', 'Avg Specificity'};
%   for j = 1:(numDatasets+1)
%       header = [header, {['Precision_' num2str(j)], ['Recall_' num2str(j)], ['F1_' num2str(j)], ['Specificity_' num2str(j)]}];
%   end
%   xlswrite(filename, [header; num2cell(results)]);
% rmpath(cndir);
% toc
