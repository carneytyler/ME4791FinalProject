function [ strain, curvature ] = laminateStrainCurv(A, B, D, N, M)

Dstar = D - B*inv(A)*B;
A1 = inv(A) + inv(A)*B*inv(Dstar)*B*inv(A);
B1 = -inv(A)*B*inv(Dstar);
C1 = -inv(Dstar)*B*inv(A);
D1 = inv(Dstar);

strain = A1*N + B1*M;
curvature = C1*N + D1*M;

end