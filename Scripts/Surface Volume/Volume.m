%The volume of each cell
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
SurfaceData=readcell(['..\bin\Sample',num2str(SampleNum,'%02d'),'_surface.csv']);
SurfaceData(cellfun(@(x) any(ismissing(x)),SurfaceData))={[]};

%load the segmentation results of all timepoints
AllSpace=cell(1,size(SurfaceData,1)-1);
for Timepoint=2:size(SurfaceData,1)
    Rawdata=load_nii(['..\bin\SegCell\Sample',num2str(SampleNum,'%02d'),'_',num2str(Timepoint-1,'%03d'),'_segCell.nii.gz']);
    AllSpace{1,Timepoint-1}=Rawdata.img;
end

%Create a cell to store cell volume
BoundaryVolume=cell(size(SurfaceData));
BoundaryVolume(1,:)=SurfaceData(1,:);BoundaryVolume(:,1)=SurfaceData(:,1);
for NameIndex=2:size(SurfaceData,2)
    CellIndex=find(strcmp(NameDic(:,2),SurfaceData{1,NameIndex}))-1;
    for Timepoint=2:size(SurfaceData,1)
        if isempty(SurfaceData{Timepoint,NameIndex})
            BoundarySurface{Timepoint,NameIndex}=[];
            BoundaryVolume{Timepoint,NameIndex}=[];
            continue;
        else
            Space=AllSpace{1,Timepoint-1};
            %Find all the pixel coordinates
            ind=find(Space==CellIndex);[X,Y,Z]=ind2sub(size(Space),ind);CellAxis=[X,Y,Z];
            CellAxis1=CellAxis+repmat([-0.5 -0.5 -0.5],[size(CellAxis,1),1]);
            CellAxis2=CellAxis+repmat([-0.5 0.5 -0.5],[size(CellAxis,1),1]);
            CellAxis3=CellAxis+repmat([0.5 -0.5 -0.5],[size(CellAxis,1),1]);
            CellAxis4=CellAxis+repmat([0.5 0.5 -0.5],[size(CellAxis,1),1]);
            CellAxis5=CellAxis+repmat([-0.5 -0.5 0.5],[size(CellAxis,1),1]);
            CellAxis6=CellAxis+repmat([-0.5 0.5 0.5],[size(CellAxis,1),1]);
            CellAxis7=CellAxis+repmat([0.5 -0.5 0.5],[size(CellAxis,1),1]);
            CellAxis8=CellAxis+repmat([0.5 0.5 0.5],[size(CellAxis,1),1]);
            CellAxisNew=unique([CellAxis;CellAxis1;CellAxis2;CellAxis3;CellAxis4;CellAxis5;CellAxis6;CellAxis7;CellAxis8],'rows','stable');
            %Find the compact surface enclosing the area
            [SurfaceAxis,VolumeTemp]=boundary(CellAxisNew,1);
            BoundaryVolume{Timepoint,NameIndex}=VolumeTemp*(0.25.^3);
        end
    end
end

%save to csv
writecell(BoundaryVolume,['.\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
