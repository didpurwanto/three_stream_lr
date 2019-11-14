clc
clear
close all

rgb = '/home/ee401_2/Documents/HMDB_new/';
rgb_dir = dir(rgb);
rgb_dir = rgb_dir(3:end);

for category = 1:length(rgb)
    maps_path = [rgb(1:end-4),'traj/Mixed_5c/', rgb_dir(category).name,'/'];
    maps_folder = dir([maps_path]);
    maps_folder = maps_folder(3:end);
    category
    rgb_path = [rgb, rgb_dir(category).name,'/'];
    rgb_folder = dir([rgb_path]);
    rgb_folder = rgb_folder(3:end);
    
    for j = 1:length(maps_folder)
        namefile = [maps_path, maps_folder(j).name,'/heat/'];
        front_maps = dir([namefile, '*.jpeg']);
        
        namergb = [rgb_path, rgb_folder(j).name,'/mini_i/'];
        frame_rgb = dir([namergb, '*.jpg']);
        
        outfile = [maps_path, maps_folder(j).name,'/feature_map/'];
        if ~exist(outfile) 
            mkdir(outfile)
        end
        
        for k = 1:length(front_maps)
            img_path = [namergb, frame_rgb(k).name];
            background = imread(img_path);
            map_path = [namefile, front_maps(j).name];
            foreground = imread(map_path);

            G2 = background(:,:,2);
            B2 = background(:,:,3);


            threshold = 245;
            img(:,:,1) = foreground;
            img(:,:,2) = foreground;
            img(:,:,3) = foreground;
            R       = img(:, :, 1);
            G       = img(:, :, 2);
            B       = img(:, :, 3);
            isWhite = R >= threshold & B >=threshold & G >=threshold;
            G(isWhite) = 0;
            B(isWhite) = 0;
            newImg  = cat(3, R, G2, B2);


            count = sprintf('%.4d',k);

            path_imag = [outfile, count,'.jpg'];
            % disp(path_imag)
            imwrite(newImg,path_imag);

        end
            
        
    end
    
    
end