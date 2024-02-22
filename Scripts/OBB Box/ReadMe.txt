OBB Box
Note:
(i) Please run the scripts in the dictionary 'Surface Volume' first.
(ii) Please run the script 'SurfaceBoundary.m' first and then 'OBB.m'.
(ii) Please ensure the completion of the Output file 'Sample*_OBBbox.mat' before calculating the cell shape descriptors.

Script: SurfaceBoundary.m
Input: 
(i) name_dictionary.csv
(ii) cell volume, ..\Surface Volume\Sample*_BoundaryVolume.csv
(iii) segmentation results, ..\bin\SegCell\Sample*_***_segCell.nii.gz
Output: Sample*_SurfaceBoundary.mat, contain the sample number, cell name, cell index, frame and the coordinates of the cell boundary pixels

Script: OBB.m
Input: 
(i) name_dictionary.csv
(ii) cell volume, ..\Surface Volume\Sample*_BoundaryVolume.csv
(iii) the coordinates of the cell boundary pixels, Sample*_SurfaceBoundary.mat
(iv) segmentation results, ..\bin\SegCell\Sample*_***_segCell.nii.gz
Output: Sample*_OBBbox.mat, contain the sample number, cell name, cell index, frame, the length and direction of the triaxial axis vectors