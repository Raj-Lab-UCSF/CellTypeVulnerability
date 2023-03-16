function data_new = CCFToData(data_old, studyname, matdir_)

load([matdir_ filesep 'Mouse_Tauopathy_Data_HigherQ.mat'],'mousedata_struct');
load([matdir_ filesep 'DefaultAtlas.mat'],'DefaultAtlas')
voxels_2hem = DefaultAtlas.volumes.';
rois = mousedata_struct.(studyname).regions(:,2);
data_new = NaN(size(rois,1),size(data_old,2)); % n ROI in CCF
for i = 1:size(rois,1) 
    roi_inds_i = rois{i};
    vols_i = voxels_2hem(roi_inds_i);
    data_new(i,:) = (vols_i * data_old(roi_inds_i,:)) / sum(vols_i);
end
end