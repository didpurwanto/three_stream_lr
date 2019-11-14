% Create list of training and testing data from IXMAS dataset

clc;
clear;

action_class = {'check-watch','cross-arms','scratch-head','sit-down','get-up','turn-around','walk','wave','punch','kick','point','pick-up'};

datapath = '/home/ee401_2/Documents/low_ixmas/raw';
datafold = dir(datapath);
datafold = datafold(3:end);
video    = []; 
for i = 1 : length(datafold)
    dataname = datafold(i).name;
    datameta = strsplit(dataname,'_');
    dataclass= datameta{3};
    for j = 1 : length(action_class)
       if strcmp(dataclass,action_class{j})
          class_id = j-1;
          break;
       end       
    end
    video(i).name = dataname;
    video(i).class= dataclass;
    video(i).class_id = class_id;
end

% Class Index 
vidcls = [video.class_id];
idx    = [];
train1 = [];
train2 = [];
train3 = [];
train4 = [];
train5 = [];
test1 = [];
test2 = [];
test3 = [];
test4 = [];
test5 = [];
for i = 1 : length(action_class)
    idx    = find(vidcls == i-1);
    idxi   = randperm(length(idx));
    idxr   = idx(idxi);
    test1 = [test1 , idxr(1:15)];
    test2 = [test2 , idxr(16:30)];
    test3 = [test3 , idxr(31:45)];
    test4 = [test4 , idxr(46:60)];
    test5 = [test5 , idxr(61:75)];
    train1 = [train1 , idxr(16:150)];
    train2 = [train2 , idxr(1:15), idxr(31:150)];
    train3 = [train3 , idxr(1:30), idxr(46:150)];
    train4 = [train4 , idxr(1:45), idxr(61:150)];
    train5 = [train5 , idxr(1:60), idxr(76:150)];    
end

vid = [];
vid(1).train = train1;
vid(2).train = train2;
vid(3).train = train3;
vid(4).train = train4;
vid(5).train = train5;
vid(1).test  = test1;
vid(2).test  = test2;
vid(3).test  = test3;
vid(4).test  = test4;
vid(5).test  = test5;

for i = 1 : 5
    savepath_1 = ['trainlist_',num2str(i),'.list'];
    savepath_2 = ['testlist_',num2str(i),'.list'];
    
    ftrain = fopen(savepath_1,'a');
    vidid  = vid(i).train;
    for j = 1 : length(vidid)
        ids = vidid(j);
        videoname = video(ids).name;
        videoclass= num2str(video(ids).class_id);
        fprintf(ftrain, [  datapath,'/',videoname ,' ',videoclass '\n']);
    end
    fclose(ftrain);
    ftest = fopen(savepath_2,'a');
    vidid  = vid(i).test;
    for j = 1 : length(vidid)
        ids = vidid(j);
        videoname = video(ids).name;
        videoclass= num2str(video(ids).class_id);
        fprintf(ftrain, [datapath,'/',videoname ,' ',videoclass '\n']);
    end
    fclose(ftest);
end
