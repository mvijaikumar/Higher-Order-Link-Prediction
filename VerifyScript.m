%

dataName = 'ACMCitaion';

load(strcat(dataName,'_Graphs'));
load(strcat(dataName,'_CommonNeighborCount'));
CN = CN - CN.*obsGraph;

Observe = [];
[Observe(:,1) Observe(:,2) Observe(:,3)] = find(CN);

Check = CN;
Check(Check>0)=1;
clear CN;

load(strcat(dataName,'_InducedSubgraphNodeCount'));
NodeCount = NodeCount - NodeCount.*obsGraph;
[~, ~, Observe(:,4)] = find(NodeCount+Check*0.001);
clear NodeCount;

load(strcat(dataName,'_InducedSubgraphEdgeCount'));
EdgeCount = EdgeCount - EdgeCount.*obsGraph;
[~, ~, Observe(:,5)] = find(EdgeCount+Check*0.001);
clear EdgeCount;

load(strcat(dataName,'_InducedSubgraphTriangleCount'));
TriCount = TriCount - TriCount.*obsGraph;
[~, ~, Observe(:,6)] = find(TriCount+Check*0.001);
clear TriCount;

Check = Check.*unObsGraph + Check*0.001;
[~, ~, Observe(:,7)] = find(Check);

Observe(:,4:7) = Observe(:,4:7)-0.001;
