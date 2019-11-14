clc
clear 
close all

samples = './samples/';
samples_dir = dir(samples);
samples_dir = samples_dir(3:end);
samples_img = './samples_img/';
for i = 1:length(samples_dir)
    data = VideoReader([samples,samples_dir(i).name]);
    for j = 1:5:50
        k = sprintf('%.4d', j);
        out = [samples_img, samples_dir(i).name, '/',k];
        if ~exist([samples_img, samples_dir(i)]) mkdir([samples_img, samples_dir(i)])
        end
        imwrite(out)
    end
end