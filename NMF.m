function [prediction] = NMF (graph, k)

    [W H] = nnmf(graph,k);
    prediction = W*H;
    prediction = prediction - prediction.*graph;
    prediction = tril(prediction,-1);

    [src dest score] = find(prediction);
    prediction = [src dest score];
    
end
