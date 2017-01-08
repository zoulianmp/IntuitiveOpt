
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This Script add the MLC Physical Paramters
% All the length (Unit: mm )

% The total leaf pairs
MLC.numLeafPairs = 60;

% the leaf width per leaf pair and the label version
%
%   LN            Y2         BEV View     RN
%                 |
%         X1------|-------> X2
%   L2            |                       R2
%                 |
%   L1            Y1                      R1
%
% The width vector index means Leaf Label index , 
mid = 5.0* ones(1,40);
periphery = 10 * ones(1,10);
MLC.leafWidth = [periphery, mid, periphery ];
MLC.pairGapMax = 300;
MLC.pairGapMin = 1;

% add the target margin for compensating the mlc penumbra region
margin.x = 6;
margin.y = 6;
margin.z = 6;

MLC.targetMargin = margin;

%[X,Y axi]
MLC.coverRegion = [400,400];

%X offset for cover larger region, because of pairGapMax limit
MLC.carriageOffsetX = 0.0;

%Type 1 : X = 5 mm, Y= 5 m
MLC.daoBixelTypes(1,:) =[5,5];

%Type 1 : X = 5 mm, Y= 10 m
MLC.daoBixelTypes(2,:) =[5,10];






