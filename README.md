# I - Fluorescence spectroscopy (e.g. C:\Users\Public\fluorescence_spectroscopy)

## 1. Open 'I_I_start_control.m' in MATLAB.
1.1 Adjust folder path in line 4.

## 2. Open 'I_II_PARAFAC.m' in MATLAB.
2.1 Adjust folder path in line 2, 7, 10, 34, 83, 108, and 127.
2.2 If needed, adjust the number of base data samples in line 15.

## 3. Prepare excel/txt files.
3.1 'fingerprints_model6.xlsx' no changes needed.
3.2 'model_data_6.xlsx': to initialize, delete the old 'model_data_6.xlsx', make a copy of 'fingerprints_model6.xlsx' and rename it to 'model_data_6.xlsx'.
3.3 'sak254.txt' value must be 1.
3.4 'sak436.txt' value must be 1.
3.5 'scores.xlsx' should only contain the data of 72 base data samples and header, otherwise delete the rows below (i>72).
3.6 'scores_sak254.xlsx' only values in first row and header, delete rows below. Values for first row: SAK 254 -> 100, Date/Time -> 1, Absorbance in 1/nm -> nan, Sample ID -> nan.
3.7 'scores_sak436.xlsx' only 100 in first row and header, delete rows below.

## 4. Start 'I_I_start_control.m' in MATLAB


# II - Flow cytometry

## 1. Open 'II_fcm.py' in an environment such as spyder.
1.1 Press 'Run' and follow trough the request process.
1.2 Go until the 'WAIT'. When first flow cytometry measurement is completed, continue by pressing enter.

## 2. Prepare excel files
2.1 Open 'fcm_results.xlsx' and delete all rows except header.
2.2 Open 'fcm_scores.xlsx' and delete all rows except first and header. Set Default value of -1 at Index column.


# III - Dashboard

## 1. Open 'III_app_online_dashboard.py' in an environment such as spyder and press 'Run'.
1.2 Follow through the request process.