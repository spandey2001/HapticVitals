function [AlarmTimePrediction] = AlarmPredictor(Slope, Position, UpperThreshold, LowerThreshold)

if Slope > 0
    AlarmTimePrediction = (UpperThreshold - Position)/Slope;
elseif Slope < 0
    AlarmTimePrediction = (LowerThreshold - Position)/Slope;
end