function [commLinks] = PredictLinks (graph, label, method)

    degree = sum(graph,2);
    
    [commIDs IA IC] = unique(label');
    commLinks = {};
    count = 1;
    for ID = commIDs
        elems = find(label==ID);
        M = graph(elems,elems);
        switch lower(method)
            case {'commonksupport'}
                pred = CommonKSupport(M, degree(elems));
            case {'nmf'}
                pred = NMF(M, min(20,ceil(length(elems)/10)));
            case 'cn'
                pred = CN(M);
            case 'aa'
                pred = AA(M, degree(elems));
            case 'rai'
                pred = RAI(M, degree(elems));
            otherwise
                disp('Unknown method.')
        end

        if(size(pred,2)==0)
            pred = zeros(0,3);
        end
        X = [elems(pred(:,1)) elems(pred(:,2)) pred(:,3)];
        commLinks{count,1} = X;
        count = count + 1;
    end
    
    commLinks = (cell2mat(commLinks));

end
