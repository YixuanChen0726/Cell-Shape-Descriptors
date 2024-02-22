% Compute Huang Shape Factor
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
VolumeData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
VolumeData(cellfun(@(x) any(ismissing(x)),VolumeData))={[]};
%load OBB box,a,b,c
load(['..\OBB Box\Sample',num2str(SampleNum,'%02d'),'_OBBbox.mat']);

%Head of column: Sample Number, Cell Name, Cell Index, Frame, Huang shape factor
Huang=cell(size(OBBbox,1),5);Huang(:,1:4)=OBBbox(:,1:4);
%Create a cell to store Huang shape factor
Huatable=cell(size(VolumeData));
Huatable(1,:)=VolumeData(1,:);Huatable(:,1)=VolumeData(:,1);
for VariNum=1:size(OBBbox,1)
    CellName=OBBbox{VariNum,2};CellIndex=OBBbox{VariNum,3};Timepoint=OBBbox{VariNum,4};
    %The triaxial axis
    a=OBBbox{VariNum,5};b=OBBbox{VariNum,7};c=OBBbox{VariNum,9};
    [Namerow,Namecol]=find(cellfun(@(x) strcmp(x,CellName),VolumeData(1,:)));
    HS=(b+c)./(2*a);
    %Put the data into cell and table respectively
    Huatable{Timepoint+1,Namecol}=HS;
    Huang{VariNum,5}=HS;
end

%save to csv and mat
writecell(Huatable,['.\Sample',num2str(SampleNum,'%02d'),'_Huang.csv']);
save(['.\Sample',num2str(SampleNum,'%02d'),'_Huang.mat'],'Huang','-v7.3');

