% Compute Elongation Ratio
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
VolumeData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
VolumeData(cellfun(@(x) any(ismissing(x)),VolumeData))={[]};
%load OBB box,a,b,c
load(['..\OBB Box\Sample',num2str(SampleNum,'%02d'),'_OBBbox.mat']);

%Head of column: Sample Number, Cell Name, Cell Index, Frame, Elongation Ratio
Elongation=cell(size(OBBbox,1),5);Elongation(:,1:4)=OBBbox(:,1:4);
%Create a cell to store elongation ratio
Elotable=cell(size(VolumeData));
Elotable(1,:)=VolumeData(1,:);Elotable(:,1)=VolumeData(:,1);Elotable{1,1}=[];
for VariNum=1:size(OBBbox,1)
    CellName=OBBbox{VariNum,2};CellIndex=OBBbox{VariNum,3};Timepoint=OBBbox{VariNum,4};
    %The triaxial axis
    a=OBBbox{VariNum,5};b=OBBbox{VariNum,7};c=OBBbox{VariNum,9};
    [Namerow,Namecol]=find(cellfun(@(x) strcmp(x,CellName),VolumeData(1,:)));
    ER=a/b;
    %Put the data into cell and table respectively
    Elotable{Timepoint+1,Namecol}=ER;
    Elongation{VariNum,5}=ER;
end

%save to csv and mat
writecell(Elotable,['.\Sample',num2str(SampleNum,'%02d'),'_Elongation.csv']);
save(['.\Sample',num2str(SampleNum,'%02d'),'_Elongation.mat'],'Elongation','-v7.3');


