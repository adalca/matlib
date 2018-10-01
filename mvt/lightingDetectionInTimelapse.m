%% setup

%% Process 2015_08_15 5D2
FULLPATH = 'N:\datasets\boston_dataset\2015_08_15 --- Storm Timelapse\*.jpg';
d = rdir(FULLPATH);
plot([d.bytes]);
d = d(251:end);
f = bytes2lightning([d.bytes], 2);
maxim = imagingDatasetCompose(d(f), 'max');

%% Process 2015_08_15 GoPro
d = rdir('N:\datasets\boston_dataset\2015_08_15 --- GoPro3 Storm Timelapse\*\*.jpg');
plot([d.bytes]);
d = d(1944:7534);
f = bytes2lightning([d.bytes], 2);
maxim = imagingDatasetCompose(d(f), 'max');

%% Process 2014_09 GoPro
d = rdir('N:\datasets\boston_dataset\2014_09 --- GoPro3 - storm timelapse\*GOPRO\*.jpg');
plot([d.bytes]);
d = d(2754:end-1000);
f = bytes2lightning([d.bytes], 2.5);
%f([1, 17, 21, 28, 9, 6, 11, 8]) = []; %?> 10, 12, 13, 15 (mostly light), 16 (mostly light), 17, 20, 22, 25(nicebuttoomuchlight), 
f([1, 17, 21, 28, 9, 6, 11, 8, 12, 13, 15, 16, 17, 20, 22, 25, 40:100]) = []; %?> 10, 12, 13, 15 (mostly light), 16 (mostly light), 17, 20, 22, 25(nicebuttoomuchlight), 
maxim = imagingDatasetCompose(d(f), 'max');
imwrite(maxim, 'E:\sel_storm_5.tiff');


% Idea: to avoid flight effects, jump over files under a certain size.

%% More complex: mean difference and canny edge count

FULLPATH = 'N:\datasets\boston_dataset\2015_08_15 --- Storm Timelapse\*.jpg';
FULLPATH = 'N:\datasets\boston_dataset\2014_09 --- GoPro3 - storm timelapse\138GOPRO\*.jpg';
% get files
d = sys.fulldir(FULLPATH);

imp = 0;
mdiff = zeros(1, numel(d));
count = 0;

vi = verboseIter(1:numel(d));

while vi.hasNext();
    i = vi.next();
    fname = d(i).name;
    im = im2double(imread(fname));
    
    e1 = edge(rgb2gray(im), 'canny');
    count = count + e1*1;
    
    if i == 1, imp = im; end
    mdiff(i) = msd(imp(:), im(:));
end
vi.close();    
plot(mdiff);
    
bcount = volblur(count, 10);

% after getting canny edge detection count, compare each canny to current image
vi = verboseIter(1:numel(d));
c = zeros(1, numel(d));
figure(); hold on;
while vi.hasNext();
    i = vi.next();
    fname = d(i).name;
    im = im2double(imread(fname));
    e1 = edge(rgb2gray(im), 'canny');
    c(i) =  sum(e1(:)*1 ./ bcount(:) > 0.1);
    plot(i, c(i), '*b');
    drawnow;
end
vi.close();
plot(c);
save c c;



%%

d = rdir('N:\datasets\boston_dataset\2013_02_09 --- GOPRO (unsure of date)\*\*.jpg');
d = rdir('N:\datasets\cambridge_dataset\2015_08_15 --- GoPro2 Thunderstorm Timelapse\*\*.jpg');

subplot(121); plot([d.bytes])
subplot(122); plot(diff([d.bytes]))


