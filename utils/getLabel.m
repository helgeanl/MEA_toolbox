function label  = getLabel( index,labels )
%getLabel Returns the channel label of given index
%   Channel index is ranging from 1 to 60 (the indexes in the channel array), 
%   while the labels corresponds to the MEA layout 60MEA200/30iR.  
%   Labels 12-17 in he first column, 21-28 in the second, ..., 71-78 in the 
%   seventh, and 82-87 in the last.
   % labels = getLabels();
   
    if length(index) > 1
        for i=1:length(index)
            label{i} = labels{index(i)};
        end
    else
        label = labels{index};
    end
end