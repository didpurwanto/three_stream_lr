
num = 192;

vidpath = '/home/ee401_2/Documents/low_ixmas/raw/';

vidlist = dir(vidpath);
vidlist = vidlist(3:length(vidlist));


for i = 1 : length(vidlist)
    i
    found = 0;
    filepath  = [vidpath, '/', vidlist(i).name];

    filelist = dir([filepath,'/mini_i/*.jpg']);
    
    if (length(filelist)<num)
        rep = ceil(num/length(filelist));
        for j = 1 : (length(filelist))
            fname = filelist(j).name;
            fnames = str2num(fname(1:(length(fname)-4)));
            for l = 1 : (rep-1)
                fnames = fnames + length(filelist);
                srcfb  = [filepath,'/mini_i/',fname];
                desfb  = [filepath,'/mini_i/',sprintf('%04d.jpg',fnames)];
                copyfile(srcfb,desfb);
            end
        end
        found = 1;
    end
    
    if found == 1
        disp(vidlist(i).name)
    end
end