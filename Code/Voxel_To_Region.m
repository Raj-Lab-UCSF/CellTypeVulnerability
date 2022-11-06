function [cell_types_sum,cell_types_mean] = Voxel_To_Region(D,directory)

if nargin < 2
    directory = [cd filesep 'MatFiles'];
end

load([directory filesep 'regionlabs.mat'],'regionlabs');

if size(D,1) < size(D,2)
    D = D.';
end
rhem_ind = 1:(size(D,1)/2);
lhem_ind = (size(D,1)/2)+1:size(D,1);
D_r = D(rhem_ind,:);
D_l = D(lhem_ind,:);
regionlabs_r = regionlabs(rhem_ind);
regionlabs_l = regionlabs(lhem_ind);

for i = 1:length(unique(regionlabs_r))
    indi_r = regionlabs_r == i;
    regi_r = D_r(indi_r,:);
    cell_types_sum_r(i,:) = sum(regi_r);
    cell_types_mean_r(i,:) = mean(regi_r);
end
for i = 1:length(unique(regionlabs_l))
    indi_l = regionlabs_l == i;
    regi_l = D_l(indi_l,:);
    cell_types_sum_l(i,:) = sum(regi_l);
    cell_types_mean_l(i,:) = mean(regi_l);
end

zvec = zeros(1,size(cell_types_sum_r,2));
cell_types_sum_r = [cell_types_sum_r(1:11,:);zvec;cell_types_sum_r(12:end,:)];
cell_types_sum_l = [cell_types_sum_l(1:11,:);zvec;cell_types_sum_l(12:end,:)];
cell_types_sum = [cell_types_sum_r; cell_types_sum_l];
cell_types_mean_r = [cell_types_mean_r(1:11,:);zvec;cell_types_mean_r(12:end,:)];
cell_types_mean_l = [cell_types_mean_l(1:11,:);zvec;cell_types_mean_l(12:end,:)];
cell_types_mean = [cell_types_mean_r; cell_types_mean_l];
end
