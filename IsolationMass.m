function mass = IsolationMass(Data, CurtIndex, Tree, mass)

if Tree.NodeStatus == 0
    
    if Tree.Size <= 1
        mass(CurtIndex) = Tree.Height;
    else
        c = 2 * (log(Tree.Size - 1) + 0.5772156649) - 2 * (Tree.Size - 1) / Tree.Size;
        mass(CurtIndex) = Tree.Height + c;
    end
    return;
    
else
    
    LeftCurtIndex = CurtIndex(Data(CurtIndex, Tree.SplitAttribute) < Tree.SplitPoint);
    RightCurtIndex = setdiff(CurtIndex, LeftCurtIndex);
    
    if ~isempty(LeftCurtIndex)
        mass = IsolationMass(Data, LeftCurtIndex, Tree.LeftChild, mass);
    end
    if ~isempty(RightCurtIndex)
        mass = IsolationMass(Data, RightCurtIndex, Tree.RightChild, mass);
    end
    
end
