Spreading Index
Note: Please run the script 'ConvexHull_Volume.m' and 'ConvexHull_SurfaceArea.m' first, and then calculate the spreading index in 'Spreading_Index.m'.

Script: ConvexHull_Volume.m
Input: 
(i) name_dictionary.csv
(ii) cell volume, ..\Surface Volume\Sample*_BoundaryVolume.csv
(iii) segmentation results, ..\bin\SegCell\Sample*_***_segCell.nii.gz
Output: Sample*_ConvexVolume.csv

Script: ConvexHull_SurfaceArea.m
Input: 
(i) name_dictionary.csv
(ii) cell surface, ..\Surface Volume\Sample*_BoundarySurface.csv
(iii) segmentation results, ..\bin\SegCell\Sample*_***_segCell.nii.gz
Output: Sample*_ConvexSurface.csv

Script: Spreading_Index.m
Input: 
(i) name_dictionary.csv
(ii) the convex hull volume of the cell, Sample*_ConvexVolume.csv
(iii) the convex hull surface area of the cell, Sample*_ConvexSurface.csv
Output: 
(i) Sample*_SpreadingIndex.csv
(ii) Sample*_SpreadingIndex.mat, contain the sample number, cell name, cell index, frame and convex volume, convex surface area, Spreading Index
