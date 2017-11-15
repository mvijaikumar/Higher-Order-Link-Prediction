function [prediction] = commonNeighbor (graph)

    prediction = graph * graph;
    prediction = prediction - prediction.*graph;
    prediction = tril(prediction,-1);
    
    [src dest score] = find(prediction);
    prediction = [src dest score];

end
