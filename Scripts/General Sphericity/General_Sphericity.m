% Compute General Sphericity
clear all;

%load cell name and its corresponding index
NameDic=table2cell(readtable('..\bin\name_dictionary.csv'));

%The Sample number of embryo
SampleNum=4;
VolumeData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundaryVolume.csv']);
VolumeData(cellfun(@(x) any(ismissing(x)),VolumeData))={[]};
SurfaceData=readcell(['..\Surface Volume\Sample',num2str(SampleNum,'%02d'),'_BoundarySurface.csv']);
SurfaceData(cellfun(@(x) any(ismissing(x)),SurfaceData))={[]};

%Create a cell to store general sphericity
%Head of column: Sample Number, Cell Name, Cell Index, Frame, [volume,surface,sphericity]
Sphericity=cell(1,5);LinIndex=0;
%Create a cell to store general sphericity
Sphtable=cell(size(VolumeData));
Sphtable(1,:)=VolumeData(1,:);Sphtable(:,1)=VolumeData(:,1);
for NameIndex=2:size(VolumeData,2)
    CellIndex=find(strcmp(NameDic(:,2),VolumeData{1,NameIndex}))-1;
    for Timepoint=2:size(VolumeData,1)
        if isempty(VolumeData{Timepoint,NameIndex})
            Sphtable{Timepoint,NameIndex}=[];
            continue;
        else
            S=SurfaceData{Timepoint,NameIndex};V=VolumeData{Timepoint,NameIndex};
            Sph=((36*pi*V.^2).^(1/3))./S;
            %Put the data into cell and table respectively
            Sphtable{Timepoint,NameIndex}=Sph;
            Temp=cell(1,5);Temp={SampleNum,VolumeData{1,NameIndex},CellIndex,Timepoint-1,[V,S,Sph]};
            LinIndex=LinIndex+1;Sphericity(LinIndex,:)=Temp;
        end
    end
end

%save to csv and mat
writecell(Sphtable,['.\Sample',num2str(SampleNum,'%02d'),'_Sphericity.csv']);
save(['.\Sample',num2str(SampleNum,'%02d'),'_Sphericity.mat'],'Sphericity','-v7.3');

