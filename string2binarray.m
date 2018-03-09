function binarray = string2binarray(string)
%string2binarray transform a string of binary digit to an uint8 (binary) array
%   take a sring as input that contains only characters zeros or ones and
%   generate an output array of uint8 that contains zeros or ones in the
%   relative position.
lstring=strlength(string);
uint8 binarray;
binarray= zeros(1,lstring);
    for i=1:lstring
        if string(i)=='1'
            binarray(1,i) = 1;
        else
            if string(i)~='0'
                error('input string contains simbols other than 1 or 0')
            end
        end
    end
    if lstring < 6
        for i=(lstring+1):6
            binarray(1,i) = 0;
        end
    end
end

