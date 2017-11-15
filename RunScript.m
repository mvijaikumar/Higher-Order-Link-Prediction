function [] = RunScript (graphURI, bigNet)
% Link Prediction Script
    
    if nargin < 2
        bigNet = false;
    end

    graph = importdata(graphURI);
    graph = graph + 1;
    graph = spconvert([graph ones(size(graph,1),1)]);
    n = max(size(graph));
    graph(n,n) = 0;
    graph = graph+graph';
    graph(1:(n+1):end) = 0;
    graph(graph>=1)=1;

    rn = find(sum(graph,2)==0);
    graph(rn,:) = [];
    graph(:,rn) = [];
    n = n - length(rn);

    removeFrac = 0.2;
    [obsGraph unObsGraph] = SplitGraph(graph, removeFrac);

    obsGraph = spconvert(obsGraph);
    obsGraph(n,n) = 0;
    unObsGraph = spconvert(unObsGraph);
    unObsGraph(n,n) = 0;

    missingCount = sum(sum(unObsGraph,2));

    if bigNet
        labels = LabelProp(obsGraph)';
    else
        labels = ones(n,1);
    end

    hold on;
    prediction = PredictLinks (obsGraph, labels, 'CommonKSupport');
    plotAUC(prediction, unObsGraph, 'r--');
%    prediction = PredictLinks (obsGraph, labels, 'NMF');
%    plotAUC(prediction, unObsGraph, 'k--');
    prediction = PredictLinks (obsGraph, labels, 'AA');
    plotAUC(prediction, unObsGraph, 'b--');
    prediction = PredictLinks (obsGraph, labels, 'RAI');
    plotAUC(prediction, unObsGraph, 'g--');
    prediction = PredictLinks (obsGraph, labels, 'CN');
    plotAUC(prediction, unObsGraph, 'm--');
    
end
