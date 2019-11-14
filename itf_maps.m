clc
clear
close all

tsrc = '/home/ee401_2/Documents/HMDB_itf/';
src = dir(tsrc);
src = src(3:end);

outdir = '/home/ee401_2/Documents/HMDB_itf_maps/';

heat_map = '/home/ee401_2/Documents/HMDB_traj/Mixed_5c/';
heat_map_dir = dir(heat_map);
heat_map_dir = heat_map_dir(3:end);

heat_feat = '/home/ee401_2/Documents/HMDB_new/';
heat_feat_dir = dir(heat_feat);
heat_feat_dir = heat_feat_dir(3:end);


count = 0;
for i = 40:length(src)
    tclass = [tsrc, src(i).name];
    classv = dir([tclass,'/','*.avi']);
    
    tmaps = [heat_map,heat_map_dir(i).name,'/'];
    maps = dir(tmaps);
    maps = maps(3:end);
    
    class_minii = [heat_feat, heat_feat_dir(i).name];
    class_minii_dir = dir([class_minii]);
    class_minii_dir = class_minii_dir(3:end);
    
    
    for j = 1:length(classv)
        count = count + 1;
        
        vidx = [class_minii,'/', class_minii_dir(j).name,'/mini_x/'];
        vidy = [class_minii,'/', class_minii_dir(j).name,'/mini_y/'];
        video = dir([vidx, '*.jpg']);
        
        tvidmap = [tmaps,maps(j).name,'/heat/'];
        vidmap = dir([tvidmap,'*.jpeg']);
        
        vid = [tclass,'/' ,classv(j).name];
        mov = VideoReader(vid);
        t = mov.numberofframes;
        
        disp([num2str(count), ' - ',vid])
        
        outfile = [outdir, src(i).name,'/', classv(j).name(1:end-4),'/itf/'];
        if ~exist(outfile) mkdir(outfile)
        end
        
        for k = 15:t
            img = read(mov,k);
            s = sprintf('%.4d',k);
            filesave = [outfile,'/',s,'.jpg'];
            imwrite(img,filesave);
        end
        ts = sprintf('%.4d',t);
        if t~= length(vidmap)
            for ttk = t+1:length(vidmap)
                tts = sprintf('%.4d',ttk);
                copyfile([filesave(1:end-8),ts,'.jpg'],[filesave(1:end-8),tts,'.jpg'])
            end
        end
        for l = 1:14
            s = sprintf('%.4d',l);
            copyfile([filesave(1:end-8),'0015.jpg'],[filesave(1:end-8),s,'.jpg'])
        end
        
        
        
        for m = 1:length(vidmap)
            tt = sprintf('%.4d',m);
            hc = m/length(vidmap);
            tra = imread([filesave(1:end-8),tt,'.jpg']);
            background = tra;
            foreground = imread([tvidmap, vidmap(m).name]);
            
            S2 = background(:,:,2);
            V2 = background(:,:,3);
            threshold = 245;
            imag(:,:,1) = foreground;
            imag(:,:,2) = foreground;
            imag(:,:,3) = foreground;
            H       = imag(:, :, 1);
            S       = imag(:, :, 2);
            V       = imag(:, :, 3);
            isWhite = H >= threshold & S >=threshold & V >=threshold;
            S(isWhite) = 0;
            V(isWhite) = 0;
            H = H*hc;
            trajmap_spatial  = cat(3, H, S2, V2);
            
            flowx = imread([vidx,video(m).name]);
            flowy = imread([vidy,'flow_y',video(m).name(7:end)]);
            flow = [];
            flow(:,:,1) = flowx;
            flow(:,:,2) = flowy;
            magflow = sqrt(sum(flow.^2,3));
            magflow = uint8(magflow);
            Hm = magflow*hc;
            trajmap_temporal  = cat(3, Hm, magflow, V2);
            
            % imshow(traj_temporal)
            
            
            % trajectory - spatial only
            filesave_spatial = [outdir, heat_map_dir(i).name,'/', maps(j).name,'/traj_spatial/'];
            if ~exist(filesave_spatial) mkdir(filesave_spatial)
            end
            imwrite(trajmap_spatial, [filesave_spatial,tt,'.jpg']);
            
            % trajectory - spatial+temporal
            filesave_temporal = [outdir, heat_map_dir(i).name,'/', maps(j).name,'/traj_temporal/'];
            if ~exist(filesave_temporal) mkdir(filesave_temporal)
            end
            imwrite(trajmap_temporal, [filesave_temporal,tt,'.jpg']);
            
        end
        
    end
end