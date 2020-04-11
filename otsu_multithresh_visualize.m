clear all;
clc;
close all;
filepath = 'c:\img\exhibit\7004-63.jpg';
%Loosely based on the simple non-optimized c implementation of otsu taken from here: https://stackoverflow.com/questions/34856019/multi-level-thresholding-otsus-method
img = (rgb2gray(imread(filepath)));
histogram = imhist(img);
thresh = multithresh(img,2);
mat_size = size(img);
N = mat_size(1)*mat_size(2);
W0K = 0;
W1K = 0;
M0K = 0;
M1K = 0;
MT = 0;
optimalThresh1=0;
optimalThresh2=0;
counts=[];
grayLevels=[];
maxBetweenVar = 0;

subplot(1,2,1);imhist(img);
subplot(1,2,2);imshow(img);
pause(4);
for k=1:256
    MT = MT + (k * (histogram(k) / N));
end

for t1=1:256
    W0K =W0K+ histogram(t1) / N;
    M0K = M0K + (t1 * (histogram(t1) / N));
    M0 = M0K / W0K; 

    W1K = 0;
    M1K = 0;

    for t2 = t1+1:256
        W1K = W1K + histogram(t2) / N;
        M1K = M1K + (t2 * (histogram(t2) / N)); 
        M1 = M1K / W1K; 
        W2K = 1 - (W0K + W1K);
        M2K = MT - (M0K + M1K);

        if W2K <= 0
            break;
        end
        M2 = M2K / W2K;

        currVarB = W0K * (M0 - MT) * (M0 - MT) + W1K * (M1 - MT) * (M1 - MT) + W2K * (M2 - MT) * (M2 - MT);

        if maxBetweenVar < currVarB
            maxBetweenVar = currVarB;
            optimalThresh1 = t1;
            optimalThresh2 = t2;
            if (mod(t1,3)==0)
                labelImg = img;
                labelImg(labelImg>=0 & labelImg<optimalThresh1) = 1;
                labelImg(labelImg>=optimalThresh1 & labelImg<optimalThresh2) = 2;
                labelImg(labelImg>optimalThresh2) = 3;
                RGB = label2rgb(labelImg, 'spring', 'c','shuffle'); 

                if exist('c1','var')
                    delete(c1);
                    delete(c2);
                    delete(text1);
                    delete(text2);
                end
                hold on;
                subplot(1,2,1);imhist(img);
                 yl = ylim();

                c1= line([optimalThresh1, optimalThresh1], [yl(1), yl(2)],'Color', 'r', 'LineWidth', 2);
                c2= line([optimalThresh2, optimalThresh2], [yl(1), yl(2)],'Color', 'g', 'LineWidth', 2);
                text1 = text(optimalThresh1,yl(2),num2str(optimalThresh1));
                text2 = text(optimalThresh2,yl(2),num2str(optimalThresh2));
                 subplot(1,2,2);imshow(RGB);
                 pause(.0001); %required to update image frames
            end
        end
        
    end
   
            
 end