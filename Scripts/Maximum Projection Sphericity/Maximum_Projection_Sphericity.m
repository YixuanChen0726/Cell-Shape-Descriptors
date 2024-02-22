% Compute Maximum Projection Sphericity
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
VolumeData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
VolumeData(cellfun(@(x) any(ismissing(x)),VolumeData))={[]};
%load OBB box,a,b,c
load(['..\OBB Box\Sample',num2str(SampleNum,'%02d'),'_OBBbox.mat']);

%Head of column: Sample Number, Cell Name, Cell Index, Frame, maximum projection sphericity
MPsphericity=cell(size(OBBbox,1),5);MPsphericity(:,1:4)=OBBbox(:,1:4);
%Create a cell to store maximum projection sphericity
MPSphtable=cell(size(VolumeData));
MPSphtable(1,:)=VolumeData(1,:);MPSphtable(:,1)=VolumeData(:,1);
for VariNum=1:size(OBBbox,1)
    CellName=OBBbox{VariNum,2};CellIndex=OBBbox{VariNum,3};Timepoint=OBBbox{VariNum,4};
    %The triaxial axis
    a=OBBbox{VariNum,5};b=OBBbox{VariNum,7};c=OBBbox{VariNum,9};
    [Namerow,Namecol]=find(cellfun(@(x) strcmp(x,CellName),VolumeData(1,:)));
    MPS=(c^2/(a*b)).^(1/3);
    %Put the data into cell and table respectively
    MPSphtable{Timepoint+1,Namecol}=MPS;
    MPsphericity{VariNum,5}=MPS;
end

%save to csv and mat
writecell(MPSphtable,['.\Sample',num2str(SampleNum,'%02d'),'_MPSphericity.csv']);
save(['.\Sample',num2str(SampleNum,'%02d'),'_MPsphericity.mat'],'MPsphericity','-v7.3');

