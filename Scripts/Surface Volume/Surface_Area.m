% The surface area of each cell
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

%Create a cell to store surface area
BoundarySurface=cell(size(SurfaceData));
BoundarySurface(1,:)=SurfaceData(1,:);BoundarySurface(:,1)=SurfaceData(:,1);

for NameIndex=2:size(SurfaceData,2)
    CellIndex=find(strcmp(NameDic(:,2),SurfaceData{1,NameIndex}))-1;
    for Timepoint=2:size(SurfaceData,1)
        if isempty(SurfaceData{Timepoint,NameIndex})
            BoundarySurface{Timepoint,NameIndex}=[];
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
            CellAxisNew=unique([CellAxis1;CellAxis2;CellAxis3;CellAxis4;CellAxis5;CellAxis6;CellAxis7;CellAxis8],'rows','stable');
            %Find the compact surface enclosing the area
            [SurfaceAxis,VolumeTemp]=boundary(CellAxisNew,1);
            SurfaceArea=0;
            for TriNum=1:size(SurfaceAxis,1)
                AreaTemp=area(CellAxisNew(SurfaceAxis(TriNum,1),:),CellAxisNew(SurfaceAxis(TriNum,2),:),CellAxisNew(SurfaceAxis(TriNum,3),:));
                SurfaceArea=SurfaceArea+AreaTemp;
            end
            BoundarySurface{Timepoint,NameIndex}=SurfaceArea*(0.25.^2);
        end
    end
end

%save to csv
writecell(BoundarySurface,['.\Sample',num2str(SampleNum,'%02d'),'_BoundarySurface.csv']);

%The area of triangle: Heron's formula
function s=area(A,B,C)
a=norm(A-B);b=norm(B-C);c=norm(C-A);
p=(a+b+c)./2;
s=sqrt(p.*(p-a).*(p-b).*(p-c));
end