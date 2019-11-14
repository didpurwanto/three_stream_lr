clc
clear 
close all

ixmas = '/home/ee401_2/Documents/low_ixmas/raw/';
video_dir = dir(ixmas);
video_dir = video_dir(3:end);

outvid_mini = '/home/ee401_2/Documents/low_ixmas/vid_mini/';
if ~exist(outvid_mini) mkdir(outvid_mini)
end


for i  = 1800:length(video_dir)
    i
    filevid = [ixmas, video_dir(i).name,'/mini_i/'];
    file_vid = dir([filevid, '*.jpg']);
    
    % output_vid = VideoWriter([outvid_mini, video_dir(i).name]);
    output_vid = VideoWriter('a')
    output_vid.FrameRate = 10;
    open(output_vid);
    
    for j = 1:length(file_vid)
        j
        imag = imread([filevid,file_vid(j).name]);
        imshow(imag)
        writeVideo(output_vid, imag);
    end
end

