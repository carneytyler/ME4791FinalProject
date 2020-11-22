function [A, B, D] = ABD(plies, plyThickness, E11, E22, nu12, nu21, G12)

A = zeros(3,3);
B = zeros(3,3);
D = zeros(3,3);

numPlies = size(plies);
numPlies = numPlies(1);

z = zeros(numPlies + 1, 1);
z(1) = -numPlies*plyThickness/2;
for i = 2:numPlies + 1
    z(i) = z(i-1) + plyThickness;
end

for i = 2:numPlies+1
    theta = plies(i-1);
    QbarVal = Qbar(E11, E22, nu12, nu21, G12, theta);
    A = A + QbarVal*plyThickness;
    B = B + 1/2*QbarVal*(z(i)^2-z(i-1)^2);
    D = D + 1/3*QbarVal*(z(i)^3-z(i-1)^3);
end

end