clc
clear
close all

heat_itf = '/home/ee401_2/Documents/HMDB_itf/';
heat_itf_dir = dir(heat_itf);
heat_itf_dir = heat_itf_dir(3:end);

heat_feat = '/home/ee401_2/Documents/HMDB_new/';
heat_feat_dir = dir(heat_feat);
heat_feat_dir = heat_feat_dir(3:end);

heat_map = '/home/ee401_2/Documents/HMDB_traj/Mixed_5c/';
heat_map_dir = dir(heat_map);
heat_map_dir = heat_map_dir(3:end);

outdir = '/home/ee401_2/Documents/HMDB_traj-spatial/';
outdir_crop = '/home/ee401_2/Documents/HMDB_traj-spatial_crop/';


vidcount = 0;
for i=1:length(heat_itf_dir)
   vidcount = vidcount+1
   
   class_itf = [heat_itf, heat_itf_dir(i).name];
   class_itf_dir = dir([class_itf, '/*.bin']);
   
   class_minii = [heat_feat, heat_feat_dir(i).name];
   class_minii_dir = dir([class_minii]);
   class_minii_dir = class_minii_dir(3:end);
   
   class_map = [heat_map, heat_map_dir(i).name];
   class_map_dir = dir([class_map]);
   class_map_dir = class_map_dir(3:end);
   
   for j = 1:length(class_minii_dir)
       vid = [class_minii,'/', class_minii_dir(j).name,'/mini_i/'];
       video = dir([vid, '*.jpg']);
       n_mini = length(video);
       
       vidx = [class_minii,'/', class_minii_dir(j).name,'/mini_x/'];
       vidy = [class_minii,'/', class_minii_dir(j).name,'/mini_y/'];
       maps = [class_map,'/', class_map_dir(j).name,'/heat/'];
       
       outvidx = [outdir, heat_feat_dir(i).name,'/', class_minii_dir(j).name,'/flow_x/'];
       outvidy = [outdir, heat_feat_dir(i).name,'/', class_minii_dir(j).name,'/flow_y/'];
       outvidfm = [outdir, heat_feat_dir(i).name,'/', class_minii_dir(j).name,'/flow_map/'];
       outvidf = [outdir, heat_feat_dir(i).name,'/', class_minii_dir(j).name,'/flow/'];
       if ~exist(outvidx) mkdir(outvidx)
       end
       if ~exist(outvidy) mkdir(outvidy)
       end
       if ~exist(outvidfm) mkdir(outvidfm)
       end
       if ~exist(outvidf) mkdir(outvidf)
       end
       
       outvidx_crop = [outdir_crop, heat_feat_dir(i).name,'/', class_minii_dir(j).name,'/flow_x/'];
       outvidy_crop = [outdir_crop, heat_feat_dir(i).name,'/', class_minii_dir(j).name,'/flow_y/'];
       outvidfm_crop = [outdir_crop, heat_feat_dir(i).name,'/', class_minii_dir(j).name,'/flow_map/'];
       outvidf_crop = [outdir_crop, heat_feat_dir(i).name,'/', class_minii_dir(j).name,'/flow/'];
       if ~exist(outvidx_crop) mkdir(outvidx_crop)
       end
       if ~exist(outvidy_crop) mkdir(outvidy_crop)
       end
       if ~exist(outvidfm_crop) mkdir(outvidfm_crop)
       end
       if ~exist(outvidf_crop) mkdir(outvidf_crop)
       end
       
       itf_data = [class_itf,'/',class_itf_dir(j).name];
       data = import_idt(itf_data);
       
       info = data.info;
       tra = data.tra;
       indx = info(1,:);
       [in, val] = unique(indx);
       
       for k = 1:length(val)-1
           temp{1,k} = in(k);
           temp{2,k} = tra(:,val(k):val(k+1)-1);
       end
       temp{1,k+1} = in(k+1);
       temp{2,k+1} = tra(:,val(k+1):length(indx));       
       temp{1,k+2} = n_mini;
       temp{2,k+2} = tra(:,val(k+1):length(indx));
       
       indnew = [];
       for l = 1:length(temp)-1
           nrep = cell2mat(temp(1,l+1))-cell2mat(temp(1,l))-1;
           rep = repmat(temp(:,l),1,nrep+1);
           indnew = [indnew rep];
       end
       indnew{1,length(indnew)+1} = in(end);
       indnew{2,length(indnew)} = cell2mat(temp(2,end));
       
       tmp = repmat(temp(:,1),1,14);
       traj = [tmp indnew];
       
       if length(traj) ~= n_mini
           disp(['WARNINGGGGG!!!!!', num2str(n_mini),'<>', num2str(length(traj)),' -- ',itf_data])
       end
       
       for m = 1:n_mini
           flowx = imread([vidx,'flow_x_',video(m).name]);
           flowy = imread([vidy,'flow_y_',video(m).name]);
           map = imread([maps,video(m).name(1:end-4),'.jpeg',]);
           map = map-128;
           
           flow = [];
           flow(:,:,1) = flowx;
           flow(:,:,2) = flowy;
           magflow = sqrt(sum(flow.^2,3));
           magflow = uint8(magflow);
           
           heat(:,:,1) = map;
           heat(:,:,2) = magflow;
           heatmap = sum(heat,3)-128;
           heatmap = uint8(heatmap);
           
           h = figure;
           imshow(heatmap)
           hold on
           
           coord = cell2mat(traj(2,m));
           for n = 1:size(coord,2)
               XY = coord(:,n);
               plot(XY(1:2:30),XY(2:2:30),'LineWidth',2,'Color',[0 1 0]);               
           end
           hold off
           
           cou = sprintf('%.4d', m);
           saveas(h,[outvidf, cou,'.jpg']);
            % saveas(h,[outvidy, cou,'.jpg']);
            % saveas(h,[outvidfm, cou,'.jpg']);
            % saveas(h,[outvidx, cou,'.jpg']);
           
           close all
           
            % channel_h(m) = m/n_mini;
            % for c = 1:15
            %     channel_s(c) = (c/15)*0.8;
            % end
            
            imagf = imread([outvidf, cou,'.jpg']);
            Jf = imcrop(imagf,[150 61 180 180]);
            Jf = imresize(Jf, [112, 112]);
            % hsv_f = rgb2hsv(Jf);
            % hsv_f(:,:,1) = hsv_f(:,:,1)*(m/n_mini);
            % hsv_f(x,:,2) = hsv_f(:,:,2)*0.8;
           
            % imshow(hsv_x)          
            imwrite(Jf,[outvidf_crop, cou,'.jpg']);
            
           
       end
   end
end

function feature = import_idt(file,tra_len)
if nargin < 2
    tra_len = 15;
end
    fid = fopen(file,'rb');
    feat = fread(fid,[10+4*tra_len+96*3+108,inf],'float');
	feature = struct('info',[],'tra',[],'tra_shape',[],'hog',[],'hof',[],'mbhx',[],'mbhy',[]);
	if ~isempty(feat)
		feature.info = feat(1:10,:);
		feature.tra = feat(11:10+tra_len*2,:);
        feature.tra_shape = feat(11+tra_len*2:10+tra_len*4,:);
        ind = 10+tra_len*4;
		feature.hog = feat(ind+1:ind+96,:);
		feature.hof = feat(ind+97:ind+204,:);
		feature.mbhx = feat(ind+205:ind+300,:);
		feature.mbhy = feat(ind+301:end,:);
	end
    fclose(fid);
end

