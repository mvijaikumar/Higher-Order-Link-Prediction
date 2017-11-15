function [edgeCount hopLength] = CheckHopsDist (obsGraph, unObsGraph)

    obsGraph = spconvert(obsGraph);
    obsGraph = obsGraph + obsGraph';
    
    minHops = [];
    for i=1:size(unObsGraph,1)
        len = 1;
        s = unObsGraph(i,1);
        d = unObsGraph(i,2);
        vec = obsGraph(:,s);
        while(1)
            if(sum(vec .* obsGraph(:,d))~=0 || len > 12)
                minHops(i) = len;
                break;
            end
            vec = obsGraph * vec;
            len = len+1;
        end
    end

    hopLength = unique(minHops);
    edgeCount = hist(minHops, hopLength);
    disp([edgeCount; hopLength]);

end
