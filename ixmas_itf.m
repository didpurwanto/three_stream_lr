clc
clear
close all

ixmas = '/home/ee401_2/Documents/low_ixmas/vid_mini/';
vid_dir = dir([ixmas, '*.avi']);
path_dir = 'E:/DidikProjects/cvpr2019';

outdirect = '/home/ee401_2/Documents/low_ixmas/itf/';

for i = 1:length(vid_dir)
    fname = vid_dir(i).name;
    filename = [ixmas, vid_dir(i).name];
    outfile = [outdirect, vid_dir(i).name(1:end-4)];
    
    system(['DenseTrackStab.exe -f',' ',filename]);
    
    src2 = dir([path_dir,'*.avi']);
    for i = 1:length(src2)
        if strcmp(src2(i).name,'out.avi')
            tmp = 'out.avi';
            temp = [outdirect,fname,'.bin'];
            movefile(tmp,temp);
        end
    end

    src3 = dir([path_dir,'*.avi']);
    for j = 1:length(src3)
        if strcmp(src3(j).name,'test.bin')
            tmp = 'test.bin';
            temp = [outdirect,fname,'.bin'];
            movefile(tmp,temp);
        end    
    end
    
    
end

