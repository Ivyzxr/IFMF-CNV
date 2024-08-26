function [Mass] = IsolationEstimation(TestData, Forest)

NumInst = size(TestData, 1);
Mass = zeros(NumInst, Forest.NumTree);

for k = 1:Forest.NumTree
    Mass(:, k) = IsolationMass(TestData, 1:NumInst, Forest.Trees{k, 1}, zeros(NumInst, 1));
end

