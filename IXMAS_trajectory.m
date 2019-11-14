clc
clear
close all

tsrc = '/home/ee401_2/Documents/low_ixmas/xmas_itf/';
src = dir([tsrc,'*.avi']);


outdir = '/home/ee401_2/Documents/low_ixmas/ixmas_itf_maps2/';

class_minii = '/home/ee401_2/Documents/low_ixmas/raw/';
class_minii_dir = dir([class_minii]);
class_minii_dir = class_minii_dir(3:end);

for i = 1:length(src)
    raw = ['/home/ee401_2/Documents/low_ixmas/vid_mini/', class_minii_dir(i).name,'.avi'];
    movraw = VideoReader(raw);
    
    % if exist([class_minii,class_minii_dir(i).name,'/mini_i/'])
    %     rmdir([class_minii,class_minii_dir(i).name,'/mini_i/'], 's')
    % end
    if ~exist([class_minii,class_minii_dir(i).name,'/mini_i/'])
        mkdir([class_minii,class_minii_dir(i).name,'/mini_i/'])
    end
        
    for kr = 1:movraw.numberofframes
        img = read(movraw,kr);
        sr = sprintf('%.4d',kr);
        filesave = [class_minii,class_minii_dir(i).name,'/mini_i/',sr,'.jpg'];
        imwrite(img,filesave);
    end
    
    vidi = [class_minii,class_minii_dir(i).name,'/mini_i/'];
    vidx = [class_minii,class_minii_dir(i).name,'/mini_x/'];
    vidy = [class_minii,class_minii_dir(i).name,'/mini_y/'];
    videoi = dir([vidi, '*.jpg']);
    videox = dir([vidx, '*.jpg']);
    videoy = dir([vidy, '*.jpg']);
    
    if length(videoi) ~= length(videox)
        disp(['WARNINGGGGGGG ----!!!!!!!!!!!!!!!!!!!!', class_minii_dir(i).name])
    end
    
    disp([num2str(i)]);
    vid = [tsrc, src(i).name];
    mov = VideoReader(vid);
    t = mov.numberofframes;
    
    outfile = [outdir, src(i).name(1:end-4),'/itf/'];
    if ~exist(outfile) mkdir(outfile)
    end
    
    for k = 15:t
        img = read(mov,k);
        s = sprintf('%.4d',k);
        filesave = [outfile,s,'.jpg'];
        imwrite(img,filesave);
    end
    
    ts = sprintf('%.4d',t);
    if t~= length(videoi)
        for ttk = t+1:length(videoi)
            tts = sprintf('%.4d',ttk);
            copyfile([filesave(1:end-8),ts,'.jpg'],[filesave(1:end-8),tts,'.jpg'])
        end
    end
    for l = 1:14
        s = sprintf('%.4d',l);
        copyfile([filesave(1:end-8),'0015.jpg'],[filesave(1:end-8),s,'.jpg'])
    end
    
    for m = 1:length(videoi)
        tt = sprintf('%.4d',m);
        hc = m/length(videoi);
        tra = imread([filesave(1:end-8),tt,'.jpg']);
        imagi = imread([vidi,videoi(m).name]);
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

        flowx = imread([vidx,videox(m).name]);
        flowy = imread([vidy,'flow_y',videox(m).name(7:end)]);

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

        filesave_flot = [outdir, class_minii_dir(i).name,'/flowt/'];
        if ~exist(filesave_flot) mkdir(filesave_flot)
        end
        imwrite(flowt, [filesave_flot,'flowt_',tt,'.jpg']);

    end
    
    
    
    
    
end