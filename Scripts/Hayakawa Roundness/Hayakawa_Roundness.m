% Compute Hayakawa Roundness
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
SurfaceData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundarySurface.csv']);
SurfaceData(cellfun(@(x) any(ismissing(x)),SurfaceData))={[]};
VolumeData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
VolumeData(cellfun(@(x) any(ismissing(x)),VolumeData))={[]};
%load OBB box,a,b,c
load(['..\OBB Box\Sample',num2str(SampleNum,'%02d'),'_OBBbox.mat']);


%Head of column: Sample Number, Cell Name, Cell Index, Frame, Roundness
Roundness=cell(size(OBBbox,1),5);Roundness(:,1:4)=OBBbox(:,1:4);
%Create a cell to store Hayakawa Roundness
Routable=cell(size(VolumeData));
Routable(1,:)=VolumeData(1,:);Routable(:,1)=VolumeData(:,1);
for VariNum=1:size(OBBbox,1)
    CellName=OBBbox{VariNum,2};CellIndex=OBBbox{VariNum,3};Timepoint=OBBbox{VariNum,4};
    %The triaxial axis
    a=OBBbox{VariNum,5};b=OBBbox{VariNum,7};c=OBBbox{VariNum,9};
    [Namerow,Namecol]=find(cellfun(@(x) strcmp(x,CellName),VolumeData(1,:)));
    S=SurfaceData{Timepoint+1,Namecol};V=VolumeData{Timepoint+1,Namecol};
    Round=V./(S*(a*b*c).^(1/3));
    %Put the data into cell and table respectively
    Routable{Timepoint+1,Namecol}=Round;
    Roundness{VariNum,5}=Round;
end

%save to csv and mat
writecell(Routable,['.\Sample',num2str(SampleNum,'%02d'),'_HayakawaRoundness.csv']);
save(['.\Sample',num2str(SampleNum,'%02d'),'_HayakawaRoundness.mat'],'Roundness','-v7.3');


