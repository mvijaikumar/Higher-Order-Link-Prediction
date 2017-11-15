function [prediction] = getBoostedTreePrediction (label, w)

    if(length(label)==0)
        prediction = [];
        return;
    end

    path('/home/sharadnandanwar/Tools/sqb-0.1/build',path);

    w = normc(w+eps);
    w = single(full(w));
    label(label==-1)=0;
    

    options.loss = 'squaredloss';
    options.shrinkageFactor = 0.1;
    options.subsamplingFactor = 0.1;
    options.maxTreeDepth = uint32(4);
    options.mtry = uint32(6);
    options.randseed = uint32(rand()*1000);

    maxIters = uint32(100);
    model = SQBMatrixTrain( w, label, maxIters, options );

    prediction = SQBMatrixPredict( model, w );

end
