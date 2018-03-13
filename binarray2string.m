function string = binarray2string(binarray)
%binarray2string transform a binary array made of zeros or ones to a string
%   take a binary array (lenght L) that contains only zeros or ones and generate a
%   string of length L with 0s or 1s characters.
    lbinarray = length(binarray);
    for i=1:lbinarray
        if (binarray(i) == 1)
            string(i) = '1';
        else 
            if (binarray(i) == 0)
            string(i) = '0';
            else 
            error('the binary array in input cannot contains symbols different from 0 or 1')
        end
    end
    
end

