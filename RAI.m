function [prediction] = RAI (graph, degree)

    n = size(graph,1);
    iVec = 1./degree;
    iVec(degree==0) = 0;
    prediction = graph * spdiags(iVec,0,n,n) * graph;
    prediction = prediction - prediction.*graph;
    prediction = tril(prediction,-1);

    [src dest score] = find(prediction);
    prediction = [src dest score];

end
