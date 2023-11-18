%This wrapper script runs through the MISS pipeline using the Yao, et al., 
% 2021 scRNAseq dataset, which includes multiple neocortical and
% hippocampal regions
clear; clc;

%FILEPATH
matdir1 = '/Users/justintorok/Documents/MATLAB/CellTypeVulnerability_Project/Large_MatFiles'; %define directory to draw from and save data to
matdir2 = '/Users/justintorok/Documents/MATLAB/MISS/MISS-MatFiles'; %define directory to draw from and save data to
addpath('/Users/justintorok/Documents/MATLAB/MISS/MISS-Pipeline/');
% matdir = '/data/rajlab1/user_data/justin/MatFiles'; %define directory to draw from and save data to
% addpath('/home/jtorok/MISS-Pipeline/');

%LOADING INITIAL INPUT DATA
load([matdir1 filesep 'Yao_Inputs.mat'],'voxvgene','gene_names','genevct','classkey')

%MRx3 GENE RANKING USING scRNAseq FROM YAO, ET AL., 2021
lambda = 90; %percentile of genes to exclude from MRx3 ranking based on projection error added
makenew = 0; %binary flag for loading in already calculated MRx3 gene indices (0) or creating them anew (1)
if makenew
    geneinds =  MRx3_Selector_Prefilter(genevct,voxvgene,size(voxvgene,2),lambda,0); %#ok<UNRCH> %generating MRx3 gene indices
%     save([matdir filesep 'Yao_MRx3_inds'],'geneinds'); %Tasic MRx3 gene indices
else
    load([matdir1 filesep 'Yao_MRx3_inds.mat'],'geneinds'); %Tasic MRx3 gene indices
end

%% DEFINING ELBOW
load([matdir1 filesep 'CellDensity_Yao2021_lowrange.mat'],'outstruct','classkey');
outstruct_low = outstruct; clear outstruct;
load([matdir1 filesep 'CellDensity_Yao2021_medrange.mat'],'outstruct');
outstruct_med = outstruct; clear outstruct;
load([matdir1 filesep 'CellDensity_Yao2021_highrange.mat'],'outstruct');
outstruct_high = outstruct; clear outstruct;
outstruct = cat(2,outstruct_low,outstruct_med,outstruct_high);
clear outstruct_low outstruct_med outstruct_high

makefig = 1; %binary flag whether or not to make elbow curve plot
elbowind = ElbowSelector_MRx3(outstruct,makefig); %getting elbow index value and generating elbow curve
ng_param_list = NaN(1,length(outstruct));
for i = 1:length(outstruct)
    ng_param_list(i) = outstruct(i).nGen;
end
save([matdir1 filesep 'CellDensity_Yao2021_all.mat'],'outstruct','ng_param_list',... %saving cell mapping output
    'geneinds','classkey','elbowind','-v7.3');
