  function Forest = IsolationForest(Data, NumTree, NumSub, NumDim, rseed)


[NumInst, DimInst] = size(Data);
Forest.Trees = cell(NumTree, 1);

Forest.NumTree = NumTree;
Forest.NumSub = NumSub;
Forest.NumDim = NumDim;
Forest.HeightLimit = ceil(log2(NumSub));
Forest.c = 2 * (log(NumSub - 1) + 0.5772156649) - 2 * (NumSub - 1) / NumSub;
Forest.rseed = rseed;
rand('state', rseed);

Paras.HeightLimit = Forest.HeightLimit;
Paras.NumDim = NumDim;

for i = 1:NumTree
    
    if NumSub < NumInst 
        [temp, SubRand] = sort(rand(1, NumInst));
        IndexSub = SubRand(1:NumSub);
    else
        IndexSub = 1:NumInst;
    end
    if NumDim < DimInst 
        [temp, DimRand] = sort(rand(1, DimInst));
        IndexDim = DimRand(1:NumDim);
    else
        IndexDim = 1:DimInst;
    end
    
    Paras.IndexDim = IndexDim;
    Forest.Trees{i} = IsolationTree(Data, IndexSub, 0, Paras);
    
end

