clear all;
clc;
%close all;
filepath = 'c:\img\exhibit\7004-63.jpg';
%filepath = 'c:\img\lena.tif';

img = (rgb2gray(imread(filepath)));
histogram = imhist(img);

    
subplot(1,2,1);imhist(img);
subplot(1,2,2);imshow(img);title('Original Image');
pause(3);
for i=1:15
    [L C] = imsegkmeans(img,3,'NumAttempts',3,'MaxIterations',i); 
    kmean_label_overlay  = labeloverlay(img,L);
    RGB = label2rgb(L); 
    mat_size = size(img);
    clust1=[];
    clust2=[];
    clust3=[];
    for x=1:mat_size(1)
       for y=1:mat_size(2)
           if L(x,y)==2
              clust1=[clust1 img(x,y)];
           elseif L(x,y)==3
              clust2=[clust2 img(x,y)];
           else
              clust3=[clust3 img(x,y)];
           end
       end
    end
  
    subplot(1,2,2);imshow(RGB);title({'Iteration ',num2str(i)});
    histTitle1 = append('Cluster 1: ',num2str(min(clust1)),'-',num2str(max(clust1)));
    histTitle2 = append('Cluster 2: ',num2str(min(clust2)),'-',num2str(max(clust2)));
    histTitle3 = append('Cluster 3: ',num2str(min(clust3)),'-',num2str(max(clust3)));
    subplot(1,2,1);imhist(img);title({histTitle1,histTitle2,histTitle3});
    hold on;
    yl = ylim();
    if exist('c1','var')
        delete(c1);
        delete(c2);
        delete(c3);
        delete(text1);
        delete(text2);
        delete(text3);
    end

    c1= line([C(1), C(1)], [yl(1), yl(2)],'Color', 'r', 'LineWidth', 1);
    c2= line([C(2), C(2)], [yl(1), yl(2)],'Color', 'g', 'LineWidth', 1);
    c3= line([C(3), C(3)], [yl(1), yl(2)],'Color', 'b', 'LineWidth', 1);
    text1 = text(double(C(1)),1400,num2str(C(1)));
    text2 = text(double(C(2)),1200,num2str(C(2)));
    text3 = text(double(C(3)),1200,num2str(C(3)));
    if exist('old_c','var')
        if C==old_c
           %break; 
        end
    end
    old_c = C;
    pause(1);
end
