function [rayPosition,xWidth,yWidth] = getRayPositionVectorFromFitshape(fitShape,mlc)
%  Given Fitshape Get the Bev CT Phantom coordinates of bixel
%  fitshape: the max fitted MLC Shape 
%  mlc: mlc structure
%  bixelwidth: bixelwidth of X direction
%  rayPosition:BEV CT Phantom coordinate array in isocenter plane, index mens 

Xoffset = mlc.coverRegion(1)/2;
Yoffset = mlc.coverRegion(2)/2;

bixelWidth = fitShape.bixelWidth;

nBixels =  mlc.coverRegion(1)/bixelWidth;

%the mid line position of MLC Leaf
midPositionY =  cumsum(mlc.leafWidth) - Yoffset - mlc.leafWidth/2.0;

%the mid line of overage bixel 
midPositionX = bixelWidth * ones(1,nBixels);
midPositionX = cumsum(midPositionX) - Xoffset - bixelWidth/2.0;



rayPosition = zeros(fitShape.totalBixels,3);

xWidth = bixelWidth * ones(fitShape.totalBixels,1);
yWidth = zeros(fitShape.totalBixels,1);

%used for rayPosition 1 Dimension vector index
i = 1;

%Used for access leaf X range index
j = 1; 


for leafn = fitShape.indexStartY:fitShape.indexEndY 

    for  bixeln = fitShape.indexStartX(j): fitShape.indexEndX(j) 
        rayPosition(i,1) = midPositionX(bixeln);
        
        rayPosition(i,2) = 0;
        
        rayPosition(i,3) = midPositionY(leafn);
       
        yWidth(i) = mlc.leafWidth(leafn);
        
        i = i +1; % 1D Vector index of rayposition
    end
    
    j = j + 1;
end


end

