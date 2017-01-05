function fitShape = getFitShapeStructure( vStructX, vStructZ, mlc)
%  get a fitShape struct for DAO, from the projected X,Z Vectors
%  vStructX: Structure projected on Isocenter plane, X coordinate vector 
%  vStructZ: Structure projected on Isocenter plane, Z coordinate vector
%  mlc: MLC Parameters

pln = evalin('base','pln');


bevYmin =  min(vStructZ);
bevYmax =  max(vStructZ);

% the MLC Leaf label index
indexStartY = getMLCLeafIndex(bevYmin,mlc);
indexEndY = getMLCLeafIndex(bevYmax,mlc);


fitShape = struct;

fitShape.nLeaves = indexEndY - indexStartY + 1;
fitShape.indexStartY = indexStartY;
fitShape.indexEndY = indexEndY;
fitShape.bixelWidth = pln.bixelWidth;

fitShape.leafWidth = mlc.leafWidth;

maxNBixels = mlc.coverRegion(1)/fitShape.bixelWidth;

fitShape.indexStartX  = zeros(1,fitShape.nLeaves);
fitShape.indexEndX  = zeros(1,fitShape.nLeaves);

%subindex
i = 1;

for leafn = fitShape.indexStartY:fitShape.indexEndY 
    
    [y1,y2] = getMLCLeafRangeY(leafn,mlc);
    
    %the index which xValue need to consider
    index = intersect(find( vStructZ > y1),find(vStructZ < y2));
    XValues = vStructX (index);
    Xmin = min (XValues);
    Xmax = max (XValues);
    
    minIndex = getBixelIndex(Xmin,fitShape.bixelWidth,mlc.coverRegion(1));
    maxIndex = getBixelIndex(Xmax,fitShape.bixelWidth,mlc.coverRegion(1));
    
    fitShape.indexStartX(i) = minIndex;
    fitShape.indexEndX(i)  = maxIndex;
    
    %*******************************
    bixelWidth = fitShape.bixelWidth ;
    midPosition = bixelWidth * ones(1,maxNBixels); 
    Xoffset = mlc.coverRegion(1)/2;
    %the mid line position of MLC Leaf
    midPosition = cumsum(midPosition) - Xoffset - bixelWidth/2.0;
    
    fitShape.boundaryX1(i) = midPosition(minIndex) - bixelWidth/2.0;
    fitShape.boundaryX2(i)  = midPosition(maxIndex) + bixelWidth/2.0;
    
    i = i +1;
end

 fitShape.totalBixels =  sum(fitShape.indexEndX - fitShape.indexStartX + 1);



end  %getFitShapeStructure

%Given the Y coordinate value, return the nearest MLC Leaf index label
function index = getMLCLeafIndex(Y,mlc)


Yoffset = mlc.coverRegion(2)/2;

%the mid line position of MLC Leaf
midPosition = cumsum(mlc.leafWidth) - Yoffset - mlc.leafWidth/2.0;

i = find(midPosition  > Y, 1);

if isempty(i)
    if (midPosition(end) + mlc.leafWidth(end)/2.0) >= Y
        index = numel(midPosition);
    else
        index = [];
        warning('The Y value exceeding the MLC biggest boundary');
    end
    return;
end

if ((midPosition(i) - mlc.leafWidth(i)/2.0) > Y )
    index = i -1;
    if index ==0 
         index = [];
         warning('The Y value exceeding the MLC biggest boundary');       
    end
else
    index = i;
end

end %getMLCLeafIndex



%Given a MLC Leaf label return the [y1,y2] position value
function [y1,y2] = getMLCLeafRangeY(N,mlc)


Yoffset = mlc.coverRegion(2)/2;

%the mid line position of MLC Leaf
midPosition = cumsum(mlc.leafWidth) - Yoffset - mlc.leafWidth/2.0;

y1 = midPosition(N) - mlc.leafWidth(N)/2.0 ;
y2 = midPosition(N) + mlc.leafWidth(N)/2.0 ;

end 



%Given the X coordinate value, return the nearest Bixel index
function index = getBixelIndex(X,bixelWidth,xRange)
%X value: the X position of target boundary
%bixelWidth: the predefined bixelWidth
%xRange: the total X direction cover range

nBixels = xRange / bixelWidth;

Xoffset = xRange/2;
midPosition = bixelWidth * ones(1,nBixels);

%the mid line position of MLC Leaf
midPosition = cumsum(midPosition) - Xoffset - bixelWidth/2.0;


i = find(midPosition  > X, 1);

if isempty(i)
    if (midPosition(end) + bixelWidth/2.0) >= X
        index = numel(midPosition);
    else
        index = [];
        warning('The X value exceeding the MLC biggest boundary');
    end
    return;
end

if ((midPosition(i) - bixelWidth/2.0) > X )
    index = i -1;
    if index ==0 
         index = [];
         warning('The X value exceeding the MLC biggest boundary');       
    end
else
    index = i;
end

end % getBixelIndex


