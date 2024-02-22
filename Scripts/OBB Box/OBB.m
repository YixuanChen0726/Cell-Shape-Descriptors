%The principle axis of OBB box by PCA
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
VolumeData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
VolumeData(cellfun(@(x) any(ismissing(x)),VolumeData))={[]};
%load the coordinates of the cell boundary pixels
load(['.\Sample',num2str(SampleNum,'%02d'),'_SurfaceBoundary.mat']);

%load the segmentation results of all timepoints
AllSpace=cell(1,size(VolumeData,1)-1);
for Timepoint=2:size(VolumeData,1)
    Rawdata=load_nii(['..\bin\SegCell\Sample',num2str(SampleNum,'%02d'),'_',num2str(Timepoint-1,'%03d'),'_segCell.nii.gz']);
    AllSpace{1,Timepoint-1}=Rawdata.img;
end

%Create a cell to store OBB box
%Head of column: Sample Number, Cell Name, Cell Index, Frame,
%a, the end coordinates of a, b, the end coordinates of b, c, the end coordinates of c
OBBbox=BoundaryAxis;
for VariNum=1:size(BoundaryAxis,1)
    CellIndex=BoundaryAxis{VariNum,3};Timepoint=BoundaryAxis{VariNum,4};Surface=BoundaryAxis{VariNum,5};
    %Find all the pixel coordinates
    Space=AllSpace{1,Timepoint};
    ind=find(Space==CellIndex);[X,Y,Z]=ind2sub(size(Space),ind);CellAxis=[X,Y,Z];
    %covariance matrix of CellAxis
    covMatrix=cov(CellAxis);
    %eigenvector
    [NewVector,EigValue]=eig(covMatrix);
    %Base vector conversion
    NewCellAxis=CellAxis*NewVector;
    %the length of triaxial axis and its coordinates
    [xmax,xmaxin]=max(NewCellAxis(:,1));[xmin,xminin]=min(NewCellAxis(:,1));
    [ymax,ymaxin]=max(NewCellAxis(:,2));[ymin,yminin]=min(NewCellAxis(:,2));
    [zmax,zmaxin]=max(NewCellAxis(:,3));[zmin,zminin]=min(NewCellAxis(:,3));
    PrincipalLengthTemp=[xmax-xmin,ymax-ymin,zmax-zmin];
    AxisNumTemp=[xmaxin,xminin;ymaxin,yminin;zmaxin,zminin];
    %sort by length
    [PrincipalLength,sorting]=sort(PrincipalLengthTemp,'descend');
    a=0.25*PrincipalLength(1);b=0.25*PrincipalLength(2);c=0.25*PrincipalLength(3);
    AxisNum=[AxisNumTemp(sorting,:)]';
    NewPrincipalAxis=[];
    for j=1:numel(AxisNum)
        NewPrincipalAxis=[NewPrincipalAxis;NewCellAxis(AxisNum(j),:)];
    end
    %Rotate back to the original base vector
    PrincipalAxis=NewPrincipalAxis*NewVector';
    Temp={a,PrincipalAxis([1,2],:),b,PrincipalAxis([3,4],:),c,PrincipalAxis([5,6],:)};
    OBBbox(VariNum,5:10)=Temp;
end
save(['.\Sample',num2str(SampleNum,'%02d'),'_OBBbox.mat'],'OBBbox','-v7.3');
