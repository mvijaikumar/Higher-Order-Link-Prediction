function [item count] = histo (Y)
    
    Y = sort(Y);

    item = -ones(length(Y)+1,1);
    count = ones(length(Y)+1,1);

    uSeen = 1;
    for iter = 1:length(Y)
        if(Y(iter)==item(uSeen))
            count(uSeen) = count(uSeen) + 1;
        else
            uSeen = uSeen + 1;
            item(uSeen) = Y(iter);
        end
    end
    item([1, uSeen+1:end]) = [];
    count([1, uSeen+1:end]) = [];

end
