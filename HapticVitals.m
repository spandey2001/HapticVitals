% HapticVitals is a script for conducting automated data analysis 
% depending on user input of a patient vital data file containing SVV, SVI,
% SVRI, and MAP vitals.

clear;
close all;
clc;

% function [] = ()
%% Define Thresholds

SVIData_UpperAlarm = 70;
SVIData_LowerAlarm = 20;
SVISlope_UpperAlarm = 5;
SVISlope_LowerAlarm = -5;

SVVData_UpperAlarm = 20;
SVVData_LowerAlarm= 0;

SVRIData_UpperAlarm = 3000;
SVRIData_LowerAlarm = 1000;
SVRISlope_UpperAlarm = 500;
SVRISlope_LowerAlarm = -500;

MAPData_UpperAlarm = 120;
MAPData_LowerAlarm = 60;
MAPSlope_UpperAlarm = 5;
MAPSlope_LowerAlarm = -5;

SVIDataAlarm = 1;
SVVDataAlarm = 1;
SVRIDataAlarm = 1;
MAPDataAlarm = 1;

SVISlopeAlarm = 1;
SVRISlopeAlarm = 1;
MAPSlopeAlarm = 1;
%% Determine Data Files to Read
% uigetfile syntax allows for analysis of a single file by using 
% control+select or shift+select.

[fname, fpath] = uigetfile('*.XLSX','Select data file to analyze.',...
    'MultiSelect','off');    % Use for .xlsx files.

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

while SVIDataAlarm ~= 0 || SVVDataAlarm ~= 0 || SVRIDataAlarm ~= 0 || MAPDataAlarm ~= 0
    % Initialize
    data = xlsread(fname);
    SOURCE(iter,1:5) = data(iter,1:5);
    
    time = SOURCE(1:end,1);
    SVI = SOURCE(1:end,2);
    SVV = SOURCE(1:end,3);
    SVRI = SOURCE(1:end,4);
    MAP = SOURCE(1:end,5);
    
    % Pass Control to Next Iteration if No New Entries Detected
    if iter ~= 1
        if time(end) == time(end - 1)
            continue;
        end
    end
        
    % Alarm Triggering for SVI Data Thresholds 
    if SVIDataAlarm ~= 0
        if SVI(end) >= SVIData_UpperAlarm
            disp('Administer SVI Upper Alarm')
            SVIIteration = SVIDataAlarm;
            SVIDataAlarm = 0;
            Class = {'SVI'; 'Upper'};
            UpperAlarm_SVI = jsonencode(Class);
            
        elseif SVI(end) <= SVIData_LowerAlarm
            disp('Administer SVI Lower Alarm')
            SVIIteration = SVIDataAlarm;
            SVIDataAlarm = 0;
            Class = {'SVI'; 'Lower'};
            LowerAlarm_SVI = jsonencode(Class);
        else 
            SVIDataAlarm = SVIDataAlarm + 1;
        end
    end
    
    % Alarm Triggering for SVV Data Thresholds
    if SVVDataAlarm ~= 0
        if SVV(end) >= SVVData_UpperAlarm
            disp('Administer SVV Upper Alarm')
            SVVIteration = SVVDataAlarm;
            SVVDataAlarm = 0;
            Class = {'SVV'; 'Upper'};
            UpperAlarm_SVV = jsonencode(Class);
        elseif SVV(end) <= SVVData_LowerAlarm
            disp('Administer SVV Lower Alarm')
            SVVIteration = SVVDataAlarm;
            SVVDataAlarm = 0;
            Class = {'SVV'; 'Lower'};
            LowerAlarm_SVV = jsonencode(Class);
        else 
            SVVDataAlarm = SVVDataAlarm + 1;
        end
    end
    
    % Alarm Triggering for SVRI Data Thresholds
    if SVRIDataAlarm ~= 0
        if SVRI(end) >= SVRIData_UpperAlarm
            disp('Administer SVRI Upper Alarm')
            SVRIIteration = SVRIDataAlarm;
            SVRIDataAlarm = 0;
            Class = {'SVRI'; 'Upper'};
            UpperAlarm_SVRI = jsonencode(Class);
        elseif SVRI(end) <= SVRIData_LowerAlarm
            disp('Administer SVRI Lower Alarm')
            SVRIIteration = SVRIDataAlarm;
            SVRIDataAlarm = 0;
            Class = {'SVRI'; 'Lower'};
            LowerAlarm_SVRI = jsonencode(Class);
        else 
            SVRIDataAlarm = SVRIDataAlarm + 1;
        end
    end
    
    % Alarm Triggering for MAP Data Thresholds
    if MAPDataAlarm ~= 0
        if MAP(end) >= MAPData_UpperAlarm
            disp('Administer MAP Upper Alarm')
            MAPIteration = MAPDataAlarm;
            MAPDataAlarm = 0;
            Class = {'MAP'; 'Upper'};
            UpperAlarm_MAP = jsonencode(Class);
        elseif MAP(end) <= MAPData_LowerAlarm
            disp('Administer MAP Lower Alarm')
            MAPIteration = MAPDataAlarm;
            MAPDataAlarm = 0;
            Class = {'MAP'; 'Lower'};
            LowerAlarm_MAP = jsonencode(Class);
        else 
            MAPDataAlarm = MAPDataAlarm + 1;
        end  
    end
    
    % Terminate Script if All Data Thresholds are Surpassed
    if SVIDataAlarm == 0 && SVVDataAlarm == 0 && SVRIDataAlarm == 0 && MAPDataAlarm == 0
        break;
    end
    
    % Re-Establish Data Iterations and Store Alarms
    if SVIDataAlarm == 0
        SVIDataAlarm = SVIIteration;
        if SVIDataAlarm >= SVIData_UpperAlarm
            % AlarmTracker(time(iter),'SVI','Upper');
        elseif SVIDataAlarm <= SVIData_LowerAlarm
            % AlarmTracker(time(iter),'SVI','Lower');
        end
    end

    if SVVDataAlarm == 0
        SVVDataAlarm = SVVIteration;
        if SVVDataAlarm >= SVVData_UpperAlarm
            % AlarmTracker(time(iter),'SVV','Upper');
        elseif SVVDataAlarm <= SVVData_LowerAlarm
            % AlarmTracker(time(iter),'SVV','Lower');
        end            
    end

    if SVRIDataAlarm == 0
        SVRIDataAlarm = SVRIIteration;
        if SVRIDataAlarm >= SVRIData_UpperAlarm
            % AlarmTracker(time(iter),'SVRI','Upper');
        elseif SVRIDataAlarm <= SVRIData_LowerAlarm
            % AlarmTracker(time(iter),'SVRI','Lower');
        end
    end

    if MAPDataAlarm == 0
        MAPDataAlarm = MAPIteration;
        if MAPDataAlarm >= MAPData_UpperAlarm
            % AlarmTracker(time(iter),'MAP','Upper');
        elseif MAPDataAlarm <= MAPData_LowerAlarm
            % AlarmTracker(time(iter),'MAP','Lower');
        end
    end
    
    % Alarm Triggering for Slope Thresholds
    if iter > 1
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