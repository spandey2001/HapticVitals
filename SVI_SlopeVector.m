function [SlopeSVI] = SVI_SlopeVector(SVI)

i = 1;
SVI_length = length(SVI) - 1; 
SlopeSVI = 0;

while length(SlopeSVI) < SVI_length 
    if i < 2
        i = i + 1;
    else
        SlopeSVI(i - 1) = (SVI(i) - SVI(i - 1))/2;
        i = i + 1;
    end
end
end