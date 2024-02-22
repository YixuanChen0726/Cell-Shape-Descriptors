%The volume of the convex hull of each cell
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
VolumeData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
VolumeData(cellfun(@(x) any(ismissing(x)),VolumeData))={[]};

%load the segmentation results of all timepoints
AllSpace=cell(1,size(VolumeData,1)-1);
for Timepoint=2:size(VolumeData,1)
    Rawdata=load_nii(['..\bin\SegCell\Sample',num2str(SampleNum,'%02d'),'_',num2str(Timepoint-1,'%03d'),'_segCell.nii.gz']);
    AllSpace{1,Timepoint-1}=Rawdata.img;
end

%Create a cell to store the volume of convex hull
ConvexVolume=cell(size(VolumeData));
ConvexVolume(1,:)=VolumeData(1,:);ConvexVolume(:,1)=VolumeData(:,1);
for NameIndex=2:size(VolumeData,2)
    CellIndex=find(strcmp(NameDic(:,2),VolumeData{1,NameIndex}))-1;
    for Timepoint=2:size(VolumeData,1)
        if isempty(VolumeData{Timepoint,NameIndex})
            ConvexVolume{Timepoint,NameIndex}=[];
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
            %Find the convex hull surface of the area
            [SurfaceAxis,ConvexVolumeTemp]=convhull(CellAxisNew);
            ConvexVolume{Timepoint,NameIndex}=ConvexVolumeTemp*(0.25.^3);
        end
    end
end

%save to csv
writecell(ConvexVolume,['..\ConvexVolume\Sample',num2str(SampleNum,'%02d'),'_ConvexVolume.csv']);

