% Compute Pivotability Index
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
VolumeData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
VolumeData(cellfun(@(x) any(ismissing(x)),VolumeData))={[]};
%load OBB box,a,b,c
load(['..\OBB Box\Sample',num2str(SampleNum,'%02d'),'_OBBbox.mat']);

%Head of column: Sample Number, Cell Name, Cell Index, Frame, Pivotability Index
Pivotability=cell(size(OBBbox,1),5);Pivotability(:,1:4)=OBBbox(:,1:4);
%Create a cell to store pivotability index
Pivtable=cell(size(VolumeData));
Pivtable(1,:)=VolumeData(1,:);Pivtable(:,1)=VolumeData(:,1);
for VariNum=1:size(OBBbox,1)
    CellName=OBBbox{VariNum,2};CellIndex=OBBbox{VariNum,3};Timepoint=OBBbox{VariNum,4};
    %The triaxial axis
    a=OBBbox{VariNum,5};b=OBBbox{VariNum,7};c=OBBbox{VariNum,9};
    [Namerow,Namecol]=find(cellfun(@(x) strcmp(x,CellName),VolumeData(1,:)));
    RI=c/b;
    %Put the data into cell and table respectively
    Pivtable{Timepoint+1,Namecol}=RI;
    Pivotability{VariNum,5}=RI;
end

%save to csv and mat
writecell(Pivtable,['.\Sample',num2str(SampleNum,'%02d'),'_Pivotability.csv']);
save(['.\Sample',num2str(SampleNum,'%02d'),'_Pivotability.mat'],'Pivotability','-v7.3');

