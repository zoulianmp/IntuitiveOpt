function output = cutoffVector( input )
%UNTITLED Summary of this function goes here
%  assign 0 to element smaller than zero

index = find(input < 0);
input(index) = 0 ;

output = input;
end

