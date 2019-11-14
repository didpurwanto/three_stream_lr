clc
clear 
close all

ixmas = '/home/ee401_2/Documents/low_ixmas/ixmas/';
video_dir = dir([ixmas, '*.avi']);

outfile = '/home/ee401_2/Documents/low_ixmas/raw_noloop/';
% outvid_mini = '/home/ee401_2/Documents/low_ixmas/vid_mini/';
% if ~exist(outvid_mini) mkdir(outvid_mini)
% end


for i  = 1:length(video_dir)
    filevid = [ixmas, video_dir(i).name];
    outdir = [outfile,video_dir(i).name(1:end-4),'/mini_i/'];
    
    if ~exist(outdir) mkdir(outdir) 
    end
    
    video = [ixmas, video_dir(i).name];
    vid = VideoReader(video);
    n = vid.numberofFrames;
    disp([num2str(i),'/',num2str(length(video_dir)),' ---', video_dir(i).name,' -- fps --',num2str(n)]);
    
    % output_vid = VideoWriter([outvid_mini, video_dir(i).name]);
    % output_vid.FrameRate = 10;
    % open(output_vid);
    
    for j = 1:n
        imag = read(vid,j);
        %imshow(imag)
        tmp = imresize(imag,0.25);
        img = imresize(tmp,[112 112]);
        k = sprintf('%.4d', j);
        filesave = [outdir, num2str(k),'.jpg'];
        imwrite(img, filesave);
        
        % writeVideo(output_vid, img);
    end
    
    
    
end

