function [prediction] = CommonKSupport (graph, degree)

% Define constants
    MAX_DEGENERACY = 30;


    n = size(graph,1);
    CN = graph*graph;
    CN = tril(CN,-1);

    [srcList, destList, ~] = find(CN);
    M = tril(graph,-1)/2 - (CN>0);
    M(M>0) = 0;
    [~,~,label] = find(4*M+3*(M<0));
    clear CN
    
    goodness = zeros(size(srcList,1),10);
    
    if(length(srcList)==0)
        prediction = zeros(0,3);
        return;
    end
    
    iDeg = 1./degree;
    iDeg(degree==0) = 0;
    Dinv = spdiags(iDeg, 0, n, n);
    
    EC = Dinv.^(1/2)*graph*Dinv.^(1/2);
    crGraph = graph*Dinv.^(1/3);
    
    G = logical(graph);
    length(srcList)
    for i=1:length(srcList)
        if(mod(i,50000)==0)
            disp(i);
        end

        commonNeigh = G(:,srcList(i)) & G(:,destList(i));
        CNCount = nnz(commonNeigh);

        goodness(i,1) = sum(iDeg(commonNeigh));
        if(CNCount==1)
            continue;
        end
        
        goodness(i,2) = sum(commonNeigh'*EC(:,commonNeigh))/2;
        if(CNCount==2)
            continue;
        end

        support = 1;
        RAI_SG = crGraph(:, commonNeigh);
        RAI_SG = RAI_SG(commonNeigh,:);
        while (nnz(RAI_SG)>0)
            predTC = RAI_SG' .* (RAI_SG * RAI_SG);
            goodness(i,support+2) = sum(sum(predTC,1))/6;

            testSG = ceil(RAI_SG)' .* (ceil(RAI_SG) * ceil(RAI_SG));
            RAI_SG = RAI_SG .* (testSG > support);
            support = support+1;
            if(support>=MAX_DEGENERACY)
                break;
            end
        end
        
    end

    prediction = [srcList destList getBoostedTreePrediction(label,goodness)];

    remove = find(label==1);
    prediction(remove,:)=[];
    
end
