clc
clear
close all

tsrc = '/home/ee401_2/Documents/HMDB_itf/';
src = dir(tsrc);
src = src(3:end);

outdir = '/home/ee401_2/Documents/HMDB_itf_maps2/';

heat_map = '/home/ee401_2/Documents/HMDB_traj/Mixed_5c/';
heat_map_dir = dir(heat_map);
heat_map_dir = heat_map_dir(3:end);

heat_feat = '/home/ee401_2/Documents/HMDB_new/';
heat_feat_dir = dir(heat_feat);
heat_feat_dir = heat_feat_dir(3:end);


count = 0;
for i = 1: length(src)
    tclass = [tsrc, src(i).name];
    classv = dir([tclass,'/','*.avi']);
    
    tmaps = [heat_map,heat_map_dir(i).name,'/'];
    maps = dir(tmaps);
    maps = maps(3:end);
    
    class_minii = [heat_feat, heat_feat_dir(i).name];
    class_minii_dir = dir([class_minii]);
    class_minii_dir = class_minii_dir(3:end);
    
    
    for j = 1: length(classv)
        count = count + 1;
        
        vidi = [class_minii,'/', class_minii_dir(j).name,'/mini_i/'];
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
            imagi = imread([vidi,video(m).name(8:end)]);
            trai= tra-imagi;
            %imshow(trai)
            scale = 64;
            R = trai(:,:,1);
            G = trai(:,:,2);
            B = trai(:,:,3);
            ind_plain = find(R+G+B < 30);
            R(ind_plain) = 128;
            G(ind_plain) = 128;
            B(ind_plain) = 128;
            trajecnew = cat(3,R,G,B);
            trajecnew = rgb2gray(trajecnew);
            trajecnew = trajecnew-128;
            trajecnew = trajecnew/scale;
            trajecnew = trajecnew+128;
            
            
            % optical flows
            
            flowx = imread([vidx,video(m).name]);
            flowy = imread([vidy,'flow_y',video(m).name(7:end)]);
            
            flowx = double(flowx)-128;
            flowy = double(flowy)-128;
            flow = [];
            flow(:,:,1) = (double(flowx))./128;
            flow(:,:,2) = (double(flowy))./128;
            mag_flow = sqrt(sum(flow.^2,3));
            flow = flow*scale;  
            flow = flow+128; 
            flow(flow<0) = 0;
            flow(flow>255) = 255;
            mag_flow = mag_flow*scale;
            mag_flow = mag_flow+128;
            mag_flow(mag_flow<0) = 0;
            mag_flow(mag_flow>255) = 255;
            flow_img = cat(3,flow,mag_flow);
            flow_img = uint8(flow_img);
            
            flowt = cat(3, flow, trajecnew);
            flowt = uint8(flowt);

            filesave_flot = [outdir, heat_map_dir(i).name,'/', maps(j).name,'/flowt/'];
            if ~exist(filesave_flot) mkdir(filesave_flot)
            end
            imwrite(flowt, [filesave_flot,'flowt_',tt,'.jpg']);
            
        end
        
    end
end