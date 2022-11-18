# RESTING-STATE fMRI NEONATAL ACQUISITION PROTOCOL AND HEAD MOTION QA
## CHU SAINTE-JUSTINE RESEARCH CENTER - LAB DR. LODYGENSKY


This neonatal RS-fMRI protocol has been developed in a 3T GE MR750 Discovery and includes 
T2-w and two GRE-EPI with reversed phase encoding polarity for distortion correction purpose.

![alt text](rs_protocol_img)

Equivalent 3D acquisition sequences can be found under different names for the different MRI constructors
- GE: CUBE
- SIEMENS: SPACE
- Philips: VISTA

A real-time head motion quality control script is also included with a video tutorial.
The script provide visual outputs.


## Installation
dcm2niix and FSL have to be previously installed before running the head motion QA script

## Notes
We recommend to use lower values of TR (i.e. 2s) for both GRE-EPI acquisitions to minimize motion artifacts and to obtain a higher number of samples per acquisition (if the TR is reduced, the number of acquired volumes should be increased).
