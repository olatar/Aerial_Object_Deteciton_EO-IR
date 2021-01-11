the = imread('/Volumes/Samsung_T5/Project_Thesis/20200520_112543/preview/frame_000456.jpg');
rgb = imread('/Volumes/Samsung_T5/Project_Thesis/20200520_112543/rgb/frame_000454.jpg');

%%
%the = imread('/Volumes/Samsung_T5/Project_Thesis/20200520_104906/preview/frame_007850.jpg');
%rgb = imread('/Volumes/Samsung_T5/Project_Thesis/20200520_104906/rgb/frame_007849.jpg');
%%
figure, imshow(the)
figure, imshow(rgb)

%% https://se.mathworks.com/help/images/ref/cpselect.html
moving = rgb;
fixed = the;
cpselect(moving,fixed)
%%
%save('rgb_', 'movingPoints')
%save('the_', 'fixedPoints')
%%
load()
%%
show_the = imread('/Volumes/Samsung_T5/Project_Thesis/20200520_112543/preview/frame_002222.jpg');
show_rgb = imread('/Volumes/Samsung_T5/Project_Thesis/20200520_112543/rgb/frame_002222.jpg');
%%
tform = fitgeotrans(movingPoints, fixedPoints, 'affine');
%%
Roriginal = imref2d(size(the));
%%
recovered = (imwarp(show_rgb, tform, 'Outputview', Roriginal));
%% 'montage' 'falsecolor' 'checkerboard'
figure, imshowpair(show_the, recovered, 'montage');
figure, imshow(show_rgb)

%%
figure, imshowpair(show_the, recovered, 'blend');
figure, imshowpair(show_the, recovered, 'montage');

%% LOOPING

the = imread('/Volumes/Samsung_T5/Project_Thesis/20200520_112543/preview/frame_000487.jpg');

%tform = fitgeotrans(movingPoints_w2lag, fixedPoints_w2lag, 'polynomial', 2);
%tform = fitgeotrans(movingPoints_w2lag_2, fixedPoints_w2lag_2, 'lwm', 12);
%tform = fitgeotrans(mov_loop_2lag, fix_loop_2lag, 'affine');
%tform = fitgeotrans(mov_loop_0lag, fix_loop_0lag, 'similarity');
tform = fitgeotrans(mov_loop_2lag, fix_loop_2lag, 'similarity');
Roriginal = imref2d(size(the));


filePattern = fullfile('/Volumes/Samsung_T5/Project_Thesis/4/rgb', 'frame*.jpg'); % Change to whatever pattern you need.
theFiles = dir(filePattern);

%destPattern = '/Volumes/Samsung_T5/Project_Thesis/20200520_112543/rgb_tf/';

the_path = '/Volumes/Samsung_T5/Project_Thesis/4/preview/';
blend_path = '/Volumes/Samsung_T5/Project_Thesis/4/vid/';
%montage_path = '/Volumes/Samsung_T5/Project_Thesis/20200520_112543/montage/';

for i = 1 : length(theFiles)
    
    if i <= 2
        Frame_Ago = theFiles(i).name;
    else
        Frame_Ago = theFiles(i-1).name; % RGB is 1 frame behind
    end
    baseFileName = theFiles(i).name;
    
    fprintf('File %d of %d \n', i , length(theFiles));  
    fullFileName = fullfile(theFiles(i).folder, Frame_Ago);
    
    raw_rgb = imread(fullFileName);
    changed = (imwarp(raw_rgb, tform, 'Outputview', Roriginal));
    
    the__pth = [the_path baseFileName];
    the_image = imread(the__pth);
    %blend = imfuse(the_image, changed, 'blend');
    blend = imfuse(the_image, changed, 'blend');
    %blend = imfuse(the_image, changed,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
    blend__pth  = [blend_path baseFileName];
    
    %montage__pth  = [montage_path baseFileName];
    %montage = imfuse(the_image, changed, 'montage');
    
    %imwrite(montage, montage__pth);
    imwrite(blend, blend__pth);
    
    
    %dest = [destPattern baseFileName];
    %imwrite(changed, dest);
end

% Afterward, create a videosequence (for instance with Ffmpeg) and manually inspect.
% Change the "lag" until manually inspections give satisfactory results or
% no improved results are achievable


