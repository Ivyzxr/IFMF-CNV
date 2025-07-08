clear


cndir='D:\cnvnator\0.2xd\0.2xd3';
addpath(cndir);   
filename1=strcat('copynumber.bed');
cn=importdata(filename1);
cn=cn.data;
cndir2='D:\cnvnator\0.2xd';
addpath(cndir2);  
data=strcat('1000bins.xlsx'); 
data=readtable(data);
data=table2array(data);
data(:,3) = 0;

index1=cn(:,4)>0;
cng1=cn(index1,:);
   for j=1:1:length(cng1)
        pstart=cng1(j,1);
        pend=cng1(j,2);
        k1=min(find(data(:,1)>pstart));
        ratio1=(data(k1-1,2)-pstart)/1000;
        if ratio1>0.5
            data(k1-1,3)=1;
        end
        k2=min(find(data(:,1)>pend));
        ratio2=(pend-data(k2-1,1))/1000;
        if ratio2>0.5
            data(k2-1,3)=1;
        end
        for k=k1:1:k2-2
            data(k,3)=1;
        end
    end
    index2=cn(:,4)==0;
    cng2=cn(index2,:);
      for j=1:1:length(cng2)
        pstart=cng2(j,1);
        pend=cng2(j,2);
        k3=min(find(data(:,1)>pstart));
        ratio1=(data(k3-1,2)-pstart)/1000;
        if ratio1>0.5
            data(k3-1,3)=-1;
        end
        k4=min(find(data(:,1)>pend));
        ratio2=(pend-data(k4-1,1))/1000;
        if ratio2>0.5
            data(k4-1,3)=-1;
        end
        for kk=k3:1:k4-2
            data(kk,3)=-1;
        end
      end

% % set input and output   
all_predictions = zeros(size(data, 1), 30);  
% set save file  
results_file = 'D:\cnvnator\0.2xd\0.2xd3\results.txt';  
fid = fopen(results_file, 'w');  
if fid == -1  
    error('无法打开文件 %s 用于写入', results_file);  
end  
  
% write title  
fprintf(fid, 'Precision\tRecall\tSpecificity\tF1 Score\n');  
 
for i = 0:29 
    % create filename  
    filename = sprintf('call.0.2xd_%d_processed.txt', i);  
    data2 = fullfile(cndir, filename);  
      
    % Import data 
    data2 = importdata(data2);  
    data2 = data2.data;  
    for j=1:1:length(data2)
        pstart=data2(j,1);
        pend=data2(j,2);
        k1=min(find(data(:,1)>pstart));
        ratio1=(data(k1-1,2)-pstart)/1000;
        if ratio1>0.5
            data(k1-1,4)=1;
        end
        k2=min(find(data(:,1)>pend));
        ratio2=(pend-data(k2-1,1))/1000;
        if ratio2>0.5
            data(k2-1,4)=1;
        end
        for k=k1:1:k2-2
            data(k,4)=1;
        end
     end


ADLabels=data(:,3);
predictions = data(:,4);


   % 计算 TP, FP, FN
tp = sum(predictions == 1 & (ADLabels == 1 | ADLabels == -1));
fp = sum(predictions == 1 & ADLabels == 0);
fn = sum(predictions == 0 & (ADLabels == 1 | ADLabels == -1));
tn = sum(predictions == 0 & ADLabels == 0);

% Caculate Precision, Recall, F1 Score
precision = tp / (tp + fp)
recall = tp / (tp + fn)
specificity = tn / (tn + fp)
f1_score = 2 * (precision * recall) / (precision + recall)
all_predictions(:, i+1) = data(:, 4); 

    % Write  
    fprintf(fid, '%.4f\t%.4f\t%.4f\t%.4f\n', precision, recall, specificity, f1_score);  
   
end  

% predictions_filename = 'D:\西安交通大学wps\cnvnator\0.2xd\predictions3.csv'; % 保存的文件名  
% csvwrite(predictions_filename, all_predictions); % 使用csvwrite保存为CSV格式
% % 关闭结果文件  
% fclose(fid);  


