% Author:   Nate Suver
% Version:  1.0
% Date:     March 1 2020
% Purpose:  Segmentation approaches for detecting cracks in concrete
clear all;
clc;
close all;
metrics = [];
%parameters
pixelIslandSize = 20;
logAlpha = 1.9;
logBeta = .9;
kMeansNumAttempts =10;
%file
path = "C:\img\crack\"; 
outputPath = "C:\img\crack\out\";
annotatedPath = "C:\img\crack\annotated\";
folderInfo = dir(append(path,'*.jpg'));
for i = 1 : length(folderInfo)
    filename = append(append(folderInfo(i).folder,"\"), folderInfo(i).name); 
    img = rgb2gray(imread(filename));
    annotatedFilename = append(annotatedPath,folderInfo(i).name,".mat");
    annotated = load(annotatedFilename).result;
    orig = img;
    img = imcomplement(img);
    
    %otsu
    logXformImg = LogXform(img,logAlpha,logBeta);
    img=uint8(logXformImg*256);
    logTransformImg=img;
    thresh = multithresh(img,2);
    seg_I = imquantize(img,thresh);
    crackLabel = GetCrackLabel(seg_I);
    seg_I = seg_I==crackLabel;
    RGB = label2rgb(seg_I); 
    grayimg = rgb2gray(RGB);
    grayimg=grayimg<200;
    otusImg=grayimg;
    removeClutterImgOtsu = bwareaopen(grayimg,pixelIslandSize,8);
    otsuDisconnect=removeClutterImgOtsu;
    otsufinalImg = labeloverlay(orig,removeClutterImgOtsu); %,'colormap','hsv'

    %KMeans
    [L C] = imsegkmeans(orig,3,'NumAttempts',kMeansNumAttempts);
    kmean_label_overlay  = labeloverlay(orig,L);
    crackLabel = GetCrackLabel(L);
    L=L==crackLabel;
    RGB = label2rgb(L); 
    grayimg = rgb2gray(RGB);
    grayimg=grayimg<200;
    kmeansImg=grayimg;
    kMeansRemoveClutterImg = bwareaopen(grayimg,pixelIslandSize,8);
    kmeansDisconnect = kMeansRemoveClutterImg;
    kMeansFinalImg = labeloverlay(orig,kMeansRemoveClutterImg);
    
    actualPixelCount = nnz(annotated);
    kMeansPixelCount = nnz(kMeansRemoveClutterImg);
    otsuPixelCount = nnz(removeClutterImgOtsu);
    otsuError = (abs(otsuPixelCount-actualPixelCount)/actualPixelCount) * 100;
    kMeansError = (abs(kMeansPixelCount-actualPixelCount)/actualPixelCount) * 100;
    metrics=[metrics ;i actualPixelCount otsuPixelCount kMeansPixelCount otsuError kMeansError];

    subplot(221); imshow(orig);
    title({'a) Original'},'interpreter','latex','FontName','Times','fontsize',12); %,folderInfo(i).name
    subplot(222); imshow(logTransformImg);
    title('b) Pre-Processing','interpreter','latex','FontName','Times','fontsize',12);
    subplot(223); imshow(otusImg);
    title('c) Otsu Segmentation','interpreter','latex','FontName','Times','fontsize',12);
    subplot(224); imshow(otsuDisconnect);
    title('d) Clutter Removal','interpreter','latex','FontName','Times','fontsize',12);
    filename = append(outputPath,append("otsu-",folderInfo(i).name)); 
    saveas(gcf,filename);
    close all;
    subplot(221); imshow(orig);
    title({'a) Original'},'interpreter','latex','FontName','Times','fontsize',12);
    subplot(222); imshow(kmean_label_overlay);
    title('b) Kmeans Clustering','interpreter','latex','FontName','Times','fontsize',12);
    subplot(223); imshow(kmeansImg);
    title('c) Selected Cluster','interpreter','latex','FontName','Times','fontsize',12);
    subplot(224); imshow(kmeansDisconnect);
    title('d) Clutter Removal','interpreter','latex','FontName','Times','fontsize',12);
    filename = append(outputPath,append("kmeans-",folderInfo(i).name)); 
    saveas(gcf,filename);
    close all;
    disp(filename);
    subplot(131); imshow(orig);
    title({'Original'},'interpreter','latex','FontName','Times','fontsize',12)
    subplot(132); imshow(otsufinalImg);
    title('Otsu Output','interpreter','latex','FontName','Times','fontsize',12)
    subplot(133); imshow(kMeansFinalImg);
    title('Kmeans Output','interpreter','latex','FontName','Times','fontsize',12)
    filename = append(outputPath,append("results-",folderInfo(i).name)); 
    saveas(gcf,filename)
    close all;
end
matrix2latex(metrics, 'c:\img\crack\metrics.tex',  'alignment', 'l', 'format', '%-1.0f', 'size', 'tiny');
