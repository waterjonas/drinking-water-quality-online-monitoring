# Automatic data analysis of fluorescence spectroscopy (PARAFAC) and flow cytometry drinking water quality monitoring
## Overview
This is an approach to deal with continuous and automatic drinking water analysis via fluorescence spectroscopy with integrated PARAFAC analysis and flow cytometry. It enables a rapid and reliable status of the organic and microbial composition of the drinking water. Sudden changes in the drinking water quality can be identified and reacted accordingly. 

<img src="schematic_overview.png" width="400">

## Features
- Read DAT files (fluorescence spectroscopy) and FCS files (flow cytometry) automatically
- Perform PARAFAC analysis with a six-component model, and count cells automatically
- Visualize the data automatically
## Requirements 
### Hardware
- Fluorescence spectrometer Aqualog (HORIBA) plus  external sipper for sampling
- Flow cytometer CyFlow Cube 6 (Sysmex) with integrated measuring software CyView plus external OC-300 add-on (onCyt) for sampling and staining
### Software
- Fluorescence spectroscopy PARAFAC analysis is performed via open source [drEEM toolbox](https://dreem.openfluor.org/) [^1]
- Flow cytometry data analysis is performed via open source [FlowKit toolbox](https://github.com/whitews/FlowKit?tab=readme-ov-file#documentation) [^2]

[^1]: Murphy, K. R., Stedmon, C. A., Graeber, D., and Bro, R. (2013). Fluorescence spectroscopy and multi-way techniques. PARAFAC. Anal. Methods 5, 6557–6566. https://doi:10.1039/c3ay41160e.
[^2]: White, S., Quinn, J., Enzor, J., Staats, J., Mosier, S. M., Almarode, J., Denny, T. N., Weinhold, K. J., Ferrari, G., & Chan, C. (2021). FlowKit: A Python toolkit for integrated manual and automated cytometry analysis workflows. Frontiers in Immunology, 12. https://doi.org/10.3389/fimmu.2021.768541

## Documentation
### Preparation
1. Download both folders [flow_cytometry](/flow_cytometry/) and [fluorescence_spectroscopy](/fluorescence_spectroscopy/) including their containing subfolder and files.
2. Test data can be downloaded from [examples_raw_data_flow_cytometry](/examples_raw_data_flow_cytometry/) and [examples_raw_data_fluorescence_spectroscopy](/examples_raw_data_fluorescence_spectroscopy/).

### I - Fluorescence spectroscopy
1. Open [I_II_start_control.m](/I_I_start_control.m) in MATLAB
   - Adjust folder path in line 4

2. Open [I_II_PARAFAC.m](/I_II_PARAFAC.m) in MATLAB
   - Adjust folder path in line 2, 7, 10, 34, 83, 108, and 127
   - If needed, adjust the number of base data samples in line 15. No changes needed when using the data set provided here.

3. Prepare .xlsx and .txt files
   - [fingerprints_model6.xlsx](/fluorescence_spectroscopy/fingerprints_model6.xlsx): no changes needed when using the data set provided here.
   - [model_data_6.xlsx](/fluorescence_spectroscopy/model_data_6.xlsx): delete the old [model_data_6.xlsx](/fluorescence_spectroscopy/model_data_6.xlsx) from your drive, make a copy of [fingerprints_model6.xlsx](/fluorescence_spectroscopy/fingerprints_model6.xlsx) and rename the copy to 'model_data_6.xlsx'. This is the file for your new project.
   - [sak254.txt](/fluorescence_spectroscopy/sak254.txt): change value to 1.
   - [sak436.txt](/fluorescence_spectroscopy/sak436.txt): change value to 1.





## Contribution and funding

jkhkjhhk

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
