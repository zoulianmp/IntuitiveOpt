global intOptParameters;
dim = intOptParameters.numOfBixels;
%%% *******************************************
%%% Here begins the cvx model
cvx_begin
cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available
cvx_precision high
%%%DAO Variables needed to be optimized
%%% Left Leaves Position Array Per Beam
variable LLeafPositions1(20,15) integer;

variable LLeafPositions2(20,15) integer;
variable LLeafPositions3(20,15) integer;
variable LLeafPositions4(20,15) integer;
variable LLeafPositions5(20,15) integer;
%%% Right Leaves Position Array Per Beam
variable RLeafPositions1(20,15) integer;
variable RLeafPositions2(20,15) integer;
variable RLeafPositions3(20,15) integer;
variable RLeafPositions4(20,15) integer;
variable RLeafPositions5(20,15) integer;

%%% ApertureWeights For Beams
variables ApertureWeights1(15) ApertureWeights2(15) ApertureWeights3(15) ApertureWeights4(15) ApertureWeights5(15);
%%% WV is the vector of beamlet intensities
expression WV(1610);
%%%Dummy expression hodlers to help calculate the truncated means
%%% Target dummy expression:
expression z3(2,7429);
%%% OAR dummy expressions:

%% PPP measures the infeasibility of satisfying the truncated means constraints
variable PPP
minimize(PPP)
subject to
  %************************Begin of Beam 1  WV Calculation
  fitShape1 = intOptParameters.fitShapes{1};
  BeamWV1 = zeros(1,351);
  for apertureindex = 1:15
      for leafindex = 1:20
           nleafBixels = fitShape1.indexEndX(leafindex) - fitShape1.indexStartX(leafindex)
           leafWV = zeros(1,nleafBixels);
           length = 5* ones(1,nleafBixels);
           cslen = cumsum(length);
           
           x1 = LLeafPositions1(leafindex,apertureindex);
           x2 = RLeafPositions1(leafindex,apertureindex);
           xindexStart = fitShape1.indexStartX;
           xindexEnd = fitShape1.indexEndX;
           
           i = x1 - xindexStart + 1;
           j = x2 - xindexStart + 1;
           
           weightI =ApertureWeights1(apertureindex);
           for index = i:j
               leafWV(index) = weightI;
           end
          
           if leafindex == 1 
                BeamWV1(1:fitShape1.cumsumIndex(leafindex)) = BeamWV1(1:fitShape1.cumsumIndex(leafindex)) + leafWV;
           else
                BeamWV1(fitShape1.cumsumIndex(leafindex-1)+1:fitShape1.cumsumIndex(leafindex))= BeamWV1(fitShape1.cumsumIndex(leafindex-1)+1:fitShape1.cumsumIndex(leafindex)) + leafWV; 
           end
       end
  end
  %************************End of Beam 1  WV Calculation
  %************************Begin of Beam 2  WV Calculation
  fitShape2 = intOptParameters.fitShapes{2};
  BeamWV2 = zeros(1,272);
  for apertureindex = 1:15
      for leafindex = 1:20
           nleafBixels = fitShape2.indexEndX(leafindex) - fitShape2.indexEndX(leafindex)
           leafWV = zeros(1,nleafBixels);
           x1 = LLeafPositions2(leafindex,apertureindex);
           x2 = RLeafPositions2(leafindex,apertureindex);
           boundary_x1 = fitShape2.boundaryX1(leafindex);
           boundary_x2 = fitShape2.boundaryX2(leafindex);
           i = ceil( (x1 - boundary_x1)/5 );
           weightI =ApertureWeights2(apertureindex)* ((i* 5) - (x1 - boundary_x1))/5;
           leafWV (i) = leafWV (i) + weightI;
           j = floor( (x2 - boundary_x1)/5 );
           weightJp1 = ApertureWeights2(apertureindex)*( (x2 - boundary_x1) - (j* 5))/5;
           if j +1 <= nleafBixels
                leafWV (j+1) = leafWV (j+1) + weightJp1;
           end
           if leafindex == 1 
                BeamWV2(1:fitShape2.cumsumIndex(leafindex)) = BeamWV2(1:fitShape2.cumsumIndex(leafindex)) + leafWV;
           else
                BeamWV1(fitShape2.cumsumIndex(leafindex-1)+1:fitShape2.cumsumIndex(leafindex))= BeamWV1(fitShape2.cumsumIndex(leafindex-1)+1:fitShape2.cumsumIndex(leafindex)) + leafWV; 
           end
       end
  end
  %************************End of Beam 2  WV Calculation
  %************************Begin of Beam 3  WV Calculation
  fitShape3 = intOptParameters.fitShapes{3};
  BeamWV3 = zeros(1,352);
  for apertureindex = 1:15
      for leafindex = 1:20
           nleafBixels = fitShape3.indexEndX(leafindex) - fitShape3.indexEndX(leafindex)
           leafWV = zeros(1,nleafBixels);
           x1 = LLeafPositions3(leafindex,apertureindex);
           x2 = RLeafPositions3(leafindex,apertureindex);
           boundary_x1 = fitShape3.boundaryX1(leafindex);
           boundary_x2 = fitShape3.boundaryX2(leafindex);
           i = ceil( (x1 - boundary_x1)/5 );
           weightI =ApertureWeights3(apertureindex)* ((i* 5) - (x1 - boundary_x1))/5;
           leafWV (i) = leafWV (i) + weightI;
           j = floor( (x2 - boundary_x1)/5 );
           weightJp1 = ApertureWeights3(apertureindex)*( (x2 - boundary_x1) - (j* 5))/5;
           if j +1 <= nleafBixels
                leafWV (j+1) = leafWV (j+1) + weightJp1;
           end
           if leafindex == 1 
                BeamWV3(1:fitShape3.cumsumIndex(leafindex)) = BeamWV3(1:fitShape3.cumsumIndex(leafindex)) + leafWV;
           else
                BeamWV1(fitShape3.cumsumIndex(leafindex-1)+1:fitShape3.cumsumIndex(leafindex))= BeamWV1(fitShape3.cumsumIndex(leafindex-1)+1:fitShape3.cumsumIndex(leafindex)) + leafWV; 
           end
       end
  end
  %************************End of Beam 3  WV Calculation
  %************************Begin of Beam 4  WV Calculation
  fitShape4 = intOptParameters.fitShapes{4};
  BeamWV4 = zeros(1,344);
  for apertureindex = 1:15
      for leafindex = 1:20
           nleafBixels = fitShape4.indexEndX(leafindex) - fitShape4.indexEndX(leafindex)
           leafWV = zeros(1,nleafBixels);
           x1 = LLeafPositions4(leafindex,apertureindex);
           x2 = RLeafPositions4(leafindex,apertureindex);
           boundary_x1 = fitShape4.boundaryX1(leafindex);
           boundary_x2 = fitShape4.boundaryX2(leafindex);
           i = ceil( (x1 - boundary_x1)/5 );
           weightI =ApertureWeights4(apertureindex)* ((i* 5) - (x1 - boundary_x1))/5;
           leafWV (i) = leafWV (i) + weightI;
           j = floor( (x2 - boundary_x1)/5 );
           weightJp1 = ApertureWeights4(apertureindex)*( (x2 - boundary_x1) - (j* 5))/5;
           if j +1 <= nleafBixels
                leafWV (j+1) = leafWV (j+1) + weightJp1;
           end
           if leafindex == 1 
                BeamWV4(1:fitShape4.cumsumIndex(leafindex)) = BeamWV4(1:fitShape4.cumsumIndex(leafindex)) + leafWV;
           else
                BeamWV1(fitShape4.cumsumIndex(leafindex-1)+1:fitShape4.cumsumIndex(leafindex))= BeamWV1(fitShape4.cumsumIndex(leafindex-1)+1:fitShape4.cumsumIndex(leafindex)) + leafWV; 
           end
       end
  end
  %************************End of Beam 4  WV Calculation
  %************************Begin of Beam 5  WV Calculation
  fitShape5 = intOptParameters.fitShapes{5};
  BeamWV5 = zeros(1,291);
  for apertureindex = 1:15
      for leafindex = 1:20
           nleafBixels = fitShape5.indexEndX(leafindex) - fitShape5.indexEndX(leafindex)
           leafWV = zeros(1,nleafBixels);
           x1 = LLeafPositions5(leafindex,apertureindex);
           x2 = RLeafPositions5(leafindex,apertureindex);
           boundary_x1 = fitShape5.boundaryX1(leafindex);
           boundary_x2 = fitShape5.boundaryX2(leafindex);
           i = ceil( (x1 - boundary_x1)/5 );
           weightI =ApertureWeights5(apertureindex)* ((i* 5) - (x1 - boundary_x1))/5;
           leafWV (i) = leafWV (i) + weightI;
           j = floor( (x2 - boundary_x1)/5 );
           weightJp1 = ApertureWeights5(apertureindex)*( (x2 - boundary_x1) - (j* 5))/5;
           if j +1 <= nleafBixels
                leafWV (j+1) = leafWV (j+1) + weightJp1;
           end
           if leafindex == 1 
                BeamWV5(1:fitShape5.cumsumIndex(leafindex)) = BeamWV5(1:fitShape5.cumsumIndex(leafindex)) + leafWV;
           else
                BeamWV1(fitShape5.cumsumIndex(leafindex-1)+1:fitShape5.cumsumIndex(leafindex))= BeamWV1(fitShape5.cumsumIndex(leafindex-1)+1:fitShape5.cumsumIndex(leafindex)) + leafWV; 
           end
       end
  end
  %************************End of Beam 5  WV Calculation
  WV = [ BeamWV1 BeamWV2 BeamWV3 BeamWV4 BeamWV5];
  % TM constraints for OuterTarget
  z3(1,:) =  pos( 1.930000-intOptParameters.targetSet(1).influenceM*WV) ;
  sum(z3(1,:))/7429<= 0.106400+0.005800+PPP

  z3(2,:) =  pos(intOptParameters.targetSet(1).influenceM*WV-2.000000) ;
  sum(z3(2,:))/7429<= 0.961100+0.013000+PPP
  % TM constraints for Core
  WV<=4.239946e-01;
  WV>=0;
  PPP>=0;
cvx_end 
%%% Here End the cvx model
%%% *******************************************
