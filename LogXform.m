function [result] = LogXform(img, alpha, beta)
%Compute log transform based on The Study of Logarithmic Image Processing
%Model and Its Application to Image Enhancement by Deng/Cahill/Tobin
    windowSize = 1;
    img = im2double(img);
    padded = padarray(img,[windowSize windowSize],0,'both'); %pad the matrix with zeros so we can compute average.
    imageSizeX = length(img(:,1));
    imageSizeY = length(img(1,:));
    outputImg = zeros([imageSizeX imageSizeY]);
    for x=2:imageSizeX+windowSize
        for y=2:imageSizeY+windowSize
            localNeighbors = padded(x-windowSize:x+windowSize,y-windowSize:y+windowSize);
            logNeighbors = log(1+localNeighbors);
            localMean = mean2(logNeighbors); %for each pixel compute the mean of all his immediate neighbors.
            logPix = log(1 + img(x-1,y-1)); %this corresponds to log(f(i, j))
            result = (alpha*localMean) + (beta*(logPix-localMean));
            outputImg(x-1,y-1) = result;
        end
    end
    result = outputImg;
end

