function [SlopeSVRI] = SVRI_SlopeVector(SVRI)

i = 1;
SVRI_length = length(SVRI) - 1; 
SlopeSVRI = 0;

while length(SlopeSVRI) < SVRI_length 
    if i < 2
        i = i + 1;
    else
        SlopeSVRI(i - 1) = (SVRI(i) - SVRI(i - 1))/2;
        i = i + 1;
    end
end
end