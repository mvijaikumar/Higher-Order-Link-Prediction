function [curLabel] = LabelProp(graph)

    MAX_ITER = 5;

    degree = full(sum(graph,2));
    cumDegree = [0; cumsum(degree)];

    [dest src] = find(graph);
    curLabel = 1:size(graph,1);

    size(graph,1)
for iters = 1:MAX_ITER
    nodeOrder = randperm(size(graph,1));
    changes = 0;
    for i=1:size(graph,1)
        if (mod(i,10000)==0)
            disp(strcat('Iter:', num2str(iters), ' --- Labeled ', num2str(i), ' nodes'));
        end
            
        selectNode = nodeOrder(i);
        si = cumDegree(selectNode)+1;
        ei = cumDegree(selectNode+1);
        if(si > ei)
            continue;
        end
        neighborNodes = dest(si:ei);
        
        neighborLabels = curLabel(neighborNodes);

%        uniqLabels = unique(neighborLabels);
%        [uniqLabels count] = hist(neighborLabels, uniqueLabels);

        [uniqLabels count] = histo(neighborLabels);
        count = count + rand(size(count))/10;

        [~, mi] = max(count);
        newLabel = uniqLabels(mi);
        changes = changes + logical(curLabel(selectNode) - newLabel);
        curLabel(selectNode) = newLabel;
    end
    changes
end

end
