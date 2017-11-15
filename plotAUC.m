function [handle] = plotAUC(prediction, unObsGraph, style)

    missingCount = sum(sum(unObsGraph,2))/2;
    CTh = min(10*missingCount, size(prediction,1)); % Cardinal Threshold
    INF = 1e10;
    
    n = size(unObsGraph,1);
    predMatrix = spconvert(prediction);
    predMatrix(n,n) = 0;
    predMatrix(1:(n+1):end) = 0;

    predMatrix = predMatrix + INF*tril(unObsGraph);
    [~, ~, augPredStrength] = find(predMatrix);

    trueBehavior = floor(augPredStrength/INF);
    predStrength = mod(augPredStrength, INF);
    [~,ind] = sort(predStrength,'descend');

    predStrength = predStrength(ind);
    trueBehavior = trueBehavior(ind);
    falseBehavior = ~trueBehavior;

    cumulativeTrueBehavior = cumsum(trueBehavior);
    cumulativeFalseBehavior = cumsum(falseBehavior);

    handle = plot(cumulativeFalseBehavior(1:CTh), cumulativeTrueBehavior(1:CTh), style);

end
