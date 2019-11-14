clc
clear 
close all

hmdb = '/home/ee401_2/Documents/HMDB_new/';
video_dir = dir(hmdb);
video_dir = video_dir(3:end);

outvid = '/home/ee401_2/Documents/HMDB_minivid/';

for i = 1:length(video_dir)
    class = [hmdb, video_dir(i).name,'/'];
    class_dir = dir(class);
    class_dir = class_dir(3:end);
    
    for j = 1:length(class_dir)
        frame = [class, class_dir(j).name,'/mini_i/'];
        frame_dir = dir([frame,'*.jpg']);
        
        if ~exist([outvid, video_dir(i).name]) mkdir([outvid, video_dir(i).name])
        end
        
        path_output = [outvid, video_dir(i).name, '/',class_dir(j).name]
        output_vid = VideoWriter(path_output);
        output_vid.FrameRate = 10;
        open(output_vid);
        
        for k = 1:length(frame_dir)
            path_img = [frame,frame_dir(k).name];
            img = imread(path_img);
            writeVideo(output_vid, img);
        end
        
    end
    
end


