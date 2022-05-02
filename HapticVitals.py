# HapticVitals is a script for conducting automated data analysis
# depending on user input of a patient vital data file containing SVV, SVI,
# SVRI, and MAP vitals.
from tkinter import Tk
from tkinter.filedialog import askopenfilename
import os
import pandas as pd
import json

# ----------- Define Thresholds --------------#
SVIData_UpperAlarm = 70
SVIData_LowerAlarm = 20
SVISlope_UpperAlarm = 5
SVISlope_LowerAlarm = -5

SVVData_UpperAlarm = 20
SVVData_LowerAlarm = 0

SVRIData_UpperAlarm = 3000
SVRIData_LowerAlarm = 1000
SVRISlope_UpperAlarm = 500
SVRISlope_LowerAlarm = -500

MAPData_UpperAlarm = 120
MAPData_LowerAlarm = 60
MAPSlope_UpperAlarm = 5
MAPSlope_LowerAlarm = -5

SVIDataAlarm = 1
SVVDataAlarm = 1
SVRIDataAlarm = 1
MAPDataAlarm = 1

SVISlopeAlarm = 1
SVVSlopeAlarm = 1
SVRISlopeAlarm = 1
MAPSlopeAlarm = 1

iter = 0


def main():
    # ----------- Determine Data Files to Read --------------#
    Tk().withdraw()
    fileName = askopenfilename("Sample Data.xlsx")
    filePath = os.path.abspath(fileName)

    data = pd.read_excel(filePath)  # import data from excel file into pandas dataframe

    time = data.loc[:, "Time"]
    svi = data.loc[:, "SVI"]
    svv = data.loc[:, "SVV"]
    svri = data.loc[:, "SVRI"]
    map = data.loc[:, "MAP"]

    while (
        SVIDataAlarm != 0
        or SVVDataAlarm != 0
        or SVRIDataAlarm != 0
        or MAPDataAlarm != 0
    ):
        sviAlarmCheck(svi, iter)
        svvAlarmCheck(svv, iter)
        svriAlarmCheck(svri, iter)
        mapAlarmCheck(map, iter)

        iter += 1


# Alarm Triggering for SVI Data Thresholds
def sviAlarmCheck(self, svi, i):
    if svi[i] >= SVIData_UpperAlarm:
        print("Administer SVI Upper Alarm")
        sviIteration = SVIDataAlarm
        SVIDataAlarm = 0
        UpperAlarm_SVI = json.dumps({"SVI": "Upper"})
    elif svi[i] <= SVIData_UpperAlarm:
        print("Administer SVI Lower Alarm")
        sviIteration = SVIDataAlarm
        SVIDataAlarm = 0
        UpperAlarm_SVI = json.dumps({"SVI": "Lower"})
    else:
        SVIDataAlarm = SVIDataAlarm + 1


# Alarm Triggering for SVV Data Thresholds
def svvAlarmCheck(self, svv, i):
    if svv[i] >= SVVData_UpperAlarm:
        print("Administer SVV Upper Alarm")
        svvIteration = SVVDataAlarm
        SVVDataAlarm = 0
        UpperAlarm_SVV = json.dumps({"SVV": "Upper"})
    elif svv[i] <= SVVData_UpperAlarm:
        print("Administer SVV Lower Alarm")
        svvIteration = SVVDataAlarm
        SVVDataAlarm = 0
        UpperAlarm_SVV = json.dumps({"SVV": "Lower"})
    else:
        SVVDataAlarm = SVVDataAlarm + 1


# Alarm Triggering for SVRI Data Thresholds
def svriAlarmCheck(self, svri, i):
    if svri[i] >= SVRIData_UpperAlarm:
        print("Administer SVRI Upper Alarm")
        svriIteration = SVRIDataAlarm
        SVRIDataAlarm = 0
        UpperAlarm_SVRI = json.dumps({"SVRI": "Upper"})
    elif svri[i] <= SVRIData_UpperAlarm:
        print("Administer SVRI Lower Alarm")
        svriIteration = SVRIDataAlarm
        SVRIDataAlarm = 0
        UpperAlarm_SVRI = json.dumps({"SVRI": "Lower"})
    else:
        SVRIDataAlarm = SVRIDataAlarm + 1


# Alarm Triggering for MAP Data Thresholds
def mapAlarmCheck(self, map, i):
    if map[i] >= MAPData_UpperAlarm:
        print("Administer MAP Upper Alarm")
        mapIteration = MAPDataAlarm
        MAPDataAlarm = 0
        UpperAlarm_MAP = json.dumps({"MAP": "Upper"})
    elif map[i] <= MAPData_UpperAlarm:
        print("Administer MAP Lower Alarm")
        mapIteration = MAPDataAlarm
        MAPDataAlarm = 0
        UpperAlarm_MAP = json.dumps({"MAP": "Lower"})
    else:
        MAPDataAlarm = MAPDataAlarm + 1


if __name__ == "__main__":
    sys.exit(main())
