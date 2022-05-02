% HapticVitals is a script for conducting automated data analysis 
% depending on user input of a patient vital data file containing SVV, SVI,
% SVRI, and MAP vitals.

function [AlarmTracker] = HapticVitalsAnalysis(SVIDataAlarm, ...
    SVVDataAlarm, SVRIDataAlarm, MAPDataAlarm, SVISlopleAlarm, ...
    SVRISlopeAlarm, MAPSlopeAlarm)

%% Define Thresholds
AlarmTracker = 0;
run HapticVitalsThresholds.m
%% Determine Data Files to Read
% uigetfile syntax allows for analysis of a single file by using 
% control+select or shift+select.

[fname, fpath] = uigetfile('*.XLSX', 'Select data file to analyze.', ...
    'MultiSelect','off');   % Use for .xlsx files.

[n, ~] = size(char(fname));

if fpath == 0
    error('File not specified.');
end

cd(fpath);
%% Analyze Data and Slope Vectors
% Loop is structured to read last element of each row of the data/slope 
% profile to determine if alarm triggering is appropriate.

iter = 1;
data = xlsread(fname);

while iter ~= 0    
    %% Initialize
    data = xlsread(fname);
    SOURCE(iter, 1:5) = data(iter, 1:5);
    
    time = SOURCE(1:end, 1);
    SVI = SOURCE(1:end, 2);
    SVV = SOURCE(1:end, 3);
    SVRI = SOURCE(1:end, 4);
    MAP = SOURCE(1:end, 5);
    %% Pass Control to Next Iteration if No New Entries Detected
    if iter ~= 1
        if time(end) == time(end - 1)
            continue;
        end
    end
    %% Data Threshold Analysis
    %% Alarm Triggering for SVI Data Threshold
    if SVIDataAlarm == 1
        if SVI(end) >= SVIData_UpperAlarm
            disp('Administer SVI Upper Alarm')
            Class = {'SVI'; 'Upper'};
            UpperAlarm_SVI = jsonencode(Class);
        elseif SVI(end) <= SVIData_LowerAlarm
            disp('Administer SVI Lower Alarm')
            Class = {'SVI'; 'Lower'};
            LowerAlarm_SVI = jsonencode(Class);
        end
    end
    %% Alarm Triggering for SVV Data Threshold
    if SVVDataAlarm == 1
        if SVV(end) >= SVVData_UpperAlarm
            disp('Administer SVV Upper Alarm')
            Class = {'SVV'; 'Upper'};
            UpperAlarm_SVV = jsonencode(Class);
        elseif SVV(end) <= SVVData_LowerAlarm
            disp('Administer SVV Lower Alarm')
            Class = {'SVV'; 'Lower'};
            LowerAlarm_SVV = jsonencode(Class);
        end
    end
    %% Alarm Triggering for SVRI Data Threshold
    if SVRIDataAlarm == 1
        if SVRI(end) >= SVRIData_UpperAlarm
            disp('Administer SVRI Upper Alarm')
            Class = {'SVRI'; 'Upper'};
            UpperAlarm_SVRI = jsonencode(Class);
        elseif SVRI(end) <= SVRIData_LowerAlarm
            disp('Administer SVRI Lower Alarm')
            Class = {'SVRI'; 'Lower'};
            LowerAlarm_SVRI = jsonencode(Class);
        end
    end
    %% Alarm Triggering for MAP Data Threshold
    if MAPDataAlarm == 1
        if MAP(end) >= MAPData_UpperAlarm
            disp('Administer MAP Upper Alarm')
            Class = {'MAP'; 'Upper'};
            UpperAlarm_MAP = jsonencode(Class);
        elseif MAP(end) <= MAPData_LowerAlarm
            disp('Administer MAP Lower Alarm')
            Class = {'MAP'; 'Lower'};
            LowerAlarm_MAP = jsonencode(Class);
        end
    end
    %% Slope Threshold Analysis
    if iter > 1
        %% Alarm Triggering for SVI Slope Threshold
        SVISlope = SVI_SlopeVector(SVI);
        
        if SVISlopeAlarm ~= 0
            if SVISlope(end) >= SVISlope_UpperAlarm
                disp('Administer SVI Slope Upper Alarm')
                SVIIteration = SVISlopeAlarm;
                SVIAlarmTimePrediction = AlarmPredictor(SVISlope(end), SVI(end), SVIData_UpperAlarm, SVIData_LowerAlarm); 
                Class = {'SVI'; 'Slope'; 'Upper'};
                UpperSlopeAlarm_SVI = jsonencode(Class);
            elseif SVISlope(end) <= SVISlope_LowerAlarm
                disp('Administer SVI Slope Lower Alarm')
                SVIIteration = SVISlopeAlarm;
                SVIAlarmTimePrediction = AlarmPredictor(SVISlope(end), SVI(end), SVIData_UpperAlarm, SVIData_LowerAlarm);
                Class = {'SVI'; 'Slope'; 'Lower'};
                LowerSlopeAlarm_SVI = jsonencode(Class);
            else 
                SVISlopeAlarm = SVISlopeAlarm + 1;
            end
        end 
        
        MAPSlope = MAP_SlopeVector(MAP);
        if MAPSlopeAlarm ~= 0
            if MAPSlope(end) >= MAPSlope_UpperAlarm
                disp('Administer MAP Slope Upper Alarm')
                MAPIteration = MAPSlopeAlarm;
                MAPAlarmTimePrediction = AlarmPredictor(MAPSlope(end), MAP(end), MAPData_UpperAlarm, MAPData_LowerAlarm);
                Class = {'MAP'; 'Slope'; 'Upper'};
                UpperSlopeAlarm_MAP = jsonencode(Class);
            elseif MAPSlope(end) <= MAPSlope_LowerAlarm
                disp('Administer MAP Slope Lower Alarm')
                MAPIteration = MAPSlopeAlarm;
                MAPAlarmTimePrediction = AlarmPredictor(MAPSlope(end), MAP(end), MAPData_UpperAlarm, MAPData_LowerAlarm);
                Class = {'MAP'; 'Slope'; 'Lower'};
                LowerSlopeAlarm_MAP = jsonencode(Class);
            else 
                MAPSlopeAlarm = MAPSlopeAlarm + 1;
            end
        end
        
        SVRISlope = SVRI_SlopeVector(SVRI);
        if SVRISlopeAlarm ~= 0
            if SVRISlope(end) >= SVRISlope_UpperAlarm
                disp('Administer SVRI Slope Upper Alarm')
                SVRIIteration = SVRISlopeAlarm;
                SVRIAlarmTimePrediction = AlarmPredictor(SVRISlope(end), SVRI(end), SVRIData_UpperAlarm, SVRIData_LowerAlarm);
                Class = {'SVRI'; 'Slope'; 'Upper'};
                UpperSlopeAlarm_SVRI = jsonencode(Class);
            elseif SVRISlope(end) <= SVRISlope_LowerAlarm
                disp('Administer SVRI Slope Lower Alarm')
                SVRIIteration = SVRISlopeAlarm;
                SVRIAlarmTimePrediction = AlarmPredictor(SVRISlope(end), SVRI(end), SVRIData_UpperAlarm, SVRIData_LowerAlarm);
                Class = {'SVRI'; 'Slope'; 'Lower'};
                LowerSlopeAlarm_SVRI = jsonencode(Class);
            else 
                SVRISlopeAlarm = SVRISlopeAlarm + 1;
            end
        end
    end

    iter = iter + 1;
end

end
