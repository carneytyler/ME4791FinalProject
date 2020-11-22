function [ totalThickness ] = laminateThickness(designVar)

plyThickness = designVar(2);
numPlies = size(designVar);
numPlies = (numPlies(2) - 2)*2;

totalThickness = plyThickness * numPlies;

end