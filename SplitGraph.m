function [obsGraph unObsGraph] = SplitGraph(graph, frac)

    X = tril(graph,-1);
    [src dest weight] = find(X);
    edgeCount = length(src);

    tobeRemoved = ceil(frac*edgeCount);
    randOrder = randperm(edgeCount);

    runningDegree = full(sum(graph,2));

    removedEdges = [];
    seenCount = 0;
    removedCount = 0;

    disp('Edge Removal Started ... ');
    while(1)
        seenCount = seenCount + 1;

        if(length(removedEdges) == tobeRemoved)
            break;
        end
        s = src(randOrder(seenCount));
        d = dest(randOrder(seenCount));
        
        if(runningDegree(s)==1 || runningDegree(d)==1)
            continue;
        end
        removedCount = removedCount + 1;
        removedEdges(removedCount) = randOrder(seenCount);
        runningDegree(s) = runningDegree(s) - 1;
        runningDegree(d) = runningDegree(d) - 1;
    end
    disp('Edge Removal Finished ... ');

    obsSrc = src;
    obsSrc(removedEdges) = [];
    obsDest = dest;
    obsDest(removedEdges) = [];
    obsWeight = weight;
    obsWeight(removedEdges) = [];
    
    obsGraph = [[obsSrc; obsDest] [obsDest;obsSrc] [obsWeight;obsWeight]];
    
    unObsSrc = src(removedEdges);
    unObsDest = dest(removedEdges);
    unObsWeight = weight(removedEdges);
    
    unObsGraph = [[unObsSrc;unObsDest] [unObsDest;unObsSrc] [unObsWeight;unObsWeight]];
    
end
