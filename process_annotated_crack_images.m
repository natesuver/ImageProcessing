% Author:   Nate Suver
% Version:  1.0
% Date:     March 1 2020
% Purpose:  Output a folder containing annotated crack images as binary matrices
close all;
path = "c:\img\crack\annotated\";
outputPath = "c:\img\crack\annotated\output\";
folderInfo = dir(append(path,'*.jpg'));
crackPixelCount = [];
for i = 1 : length(folderInfo)
    filename = append(append(folderInfo(i).folder,"\"), folderInfo(i).name); 
    img = rgb2gray(imread(filename)); 
    result = ~imbinarize(img);
    disp(filename);
    crackPixelCount= [crackPixelCount;nnz(result)];
    figure;
    imshow(result);
    outputFilename = append(outputPath, folderInfo(i).name,".mat"); 
    save(outputFilename,'result');
end
