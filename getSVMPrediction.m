function [prediction] = getSVMPrediction (label, w)

    if(length(label)==0)
        prediction = [];
        return;
    end

    path('/home/sharadnandanwar/Tools/liblinear-2.01/matlab',path);
    count = histc(label,[-1,1]);
    if(count(2)>0 & count(1)>0)
        classRatio = count(1)/count(2);
    end
    w = normc(w+eps);
    w = full(w);

    
    N = min(1000000,length(label));
    randOrder = datasample(1:length(label),N,'Replace',false);
    X = w(randOrder,:);
    Y = label(randOrder);

    if(count(2)>0 & count(1)>0)
        classRatio = count(1)/count(2);
        options = ['-s 0 -c 1 -B 1 -w1 ', num2str(classRatio)];
    else
        options = ['-s 0 -c 1 -B 1'];
    end
    model = train(Y,sparse(X),options);

    [label_hat,~,prediction] = predict(label,sparse(w),model,'-b 1');
    confusionmat(label,label_hat);

%    prediction = prediction - min(prediction);
%    prediction = prediction/max(prediction);
    prediction = prediction(:,1);

end
