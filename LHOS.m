function [prediction] = LHOS (graph, degree)
% Local Higher Order Structures
   
    MAX_DEGENERACY = 30;
    fieldName = {'src','dest','1-support','2-support','3-support','4-support','5-support','6-support','7-support','8-support','9-support','10-support','11-support','12-support','13-support','14-support','15-support','16-support','17-support','18-support','19-support','20-support','21-support','22-support','23-support','24-support','25-support','26-support','27-support','28-support','29-support','30-support'};
    
    n = size(graph,1);
    w = {};
    
    iDeg = 1./degree;
    iDeg(degree==0) = 0;
    
    D = spdiags(iDeg, 0, n, n);
    EC = graph; %D.^(1/2)*graph*D.^(1/2);
    crGraph = graph; %graph*D.^(1/3);

    G = logical(graph);
    parfor outerI=1:n

        if(mod(outerI,1000)==0)
            disp(outerI);
        end

        CN = full(graph(outerI,:))*graph;
        [srcList destList weight] = find(CN);
        srcList(1:end) = outerI;
        
        r = zeros(length(srcList),MAX_DEGENERACY);
        for i=1:length(srcList)
            r(i,1) = srcList(i);
            r(i,2) = destList(i);
            srcVec = G(:,srcList(i));
            destVec = G(:,destList(i));
            commonNeigh = srcVec & destVec;

            r(i,3) = sum(iDeg(commonNeigh));
            nz = nnz(commonNeigh);
            if(nz==1)
                continue;
            end
            
            r(i,4) = sum(commonNeigh'*EC(:,commonNeigh))/2;
            if(nz==2)
                continue;
            end

            support = 1;
            RAI_SG = crGraph(:, commonNeigh);
            RAI_SG = RAI_SG(commonNeigh,:);
            while (nnz(RAI_SG)>0)
                predTC = RAI_SG' .* (RAI_SG * RAI_SG);
                r(i,support+4) = sum(sum(predTC,1))/6;

                testSG = ceil(RAI_SG)' .* (ceil(RAI_SG) * ceil(RAI_SG));
                RAI_SG = RAI_SG .* (testSG > support);
                support = support+1;
                if(support>=MAX_DEGENERACY)
                    break;
                end
            end
        end
        w{outerI} = r;
    end

    w = cell2mat(w);
    save('ACMCitation_InducedGraphCounts.mat','w','label','fieldName','-v7.3');
    prediction = [srcList destList getSVMPrediction(label,w)];

    remove = find(label==1);
    prediction(remove,:)=[];
    
end
