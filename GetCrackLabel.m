function [labelNumber] = GetCrackLabel(img)
%Given an matrix of labels, return the label with the least number of pixels in the image.
    crackLabel = 1;
    label1 = nnz(img==1);
    label2 = nnz(img==2);
    if label2 < label1
        crackLabel = 2;
    end
    label3 = nnz(img==3);
    if label3 < label2
        crackLabel = 3;
    end
    labelNumber = crackLabel;
end

