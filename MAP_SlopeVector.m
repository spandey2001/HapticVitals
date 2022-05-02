function [SlopeMAP] = MAP_SlopeVector(MAP)

i = 1;
MAP_length = length(MAP) - 1; 
SlopeMAP = 0;

while length(SlopeMAP) < MAP_length 
    if i < 2
        i = i + 1;
    else
        SlopeMAP(i - 1) = (MAP(i) - MAP(i - 1))/2;
        i = i + 1;
    end
end
end