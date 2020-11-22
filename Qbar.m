function [ Qbar ] = Qbar(E11, E22, nu12, nu21, G12, theta)

thetas = [0; -30; 30; -45; 45; -60; 60; 90];

theta = thetas(theta);
theta = theta*pi/180;

Q11 = E11/(1-nu12*nu21);
Q22 = E22/(1-nu12*nu21);
Q12 = (nu12*E22)/(1-nu12*nu21);
Q66 = G12;

Qb11 = Q11*cos(theta)^4 + 2*(Q12+2*Q66)*sin(theta)^2*cos(theta)^2 + Q22*sin(theta)^4;
Qb12 = Q12*(sin(theta)^4 + cos(theta)^4) + (Q11+Q22-4*Q66)*sin(theta)^2*cos(theta)^2;
Qb22 = Q11*sin(theta)^4 + 2*(Q12+2*Q66)*sin(theta)^2*cos(theta)^2 + Q22*cos(theta)^4;
Qb16 = (Q11-Q12-2*Q66)*sin(theta)*cos(theta)^3 + (Q12-Q22+2*Q66)*sin(theta)^3*cos(theta);
Qb26 = (Q11-Q12-2*Q66)*cos(theta)*sin(theta)^3 + (Q12-Q22+2*Q66)*cos(theta)^3*sin(theta);
Qb66 = (Q11+Q22-2*Q12-2*Q66)*sin(theta)^2*cos(theta)^2 + Q66*(sin(theta)^4+cos(theta)^4);

Qbar = [Qb11, Qb12, Qb16; Qb12, Qb22, Qb26; Qb16, Qb26, Qb66];

end