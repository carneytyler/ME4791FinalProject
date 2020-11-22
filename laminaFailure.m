function [ c, ceq ] = laminaFailure(N, M, fiber, designVar)

designVar = designVar.';

Em = 3.52e9;        % Pa (Cycom 97702 expoxy)
num = .265;         % (typical for epoxy, from page 74 of textbook)
Smu = 81.4e6;       % Pa (Cycom 97702 epoxy)

vf = designVar(1);
plyThickness = designVar(2);
thetas = designVar(3:size(designVar));

% Imposes symmetry
thetas = [thetas; flip(thetas)];
numPlies = size(thetas);
numPlies = numPlies(1);

thetaVals = [0; -30; 30; -45; 45; -60; 60; 90];

cont = true;
% Imposes limits on interlaminar stress via ply angle differentials
for i = 1:numPlies-1
    theta1 = thetaVals(thetas(i));
    theta2 = thetaVals(thetas(i+1));
    if theta2 <= theta1 + 45 && theta2 >= theta1 - 45
        % Do nothing
    else
        cont = false;
    end
end

if cont
    switch(fiber)
        case 1 % T1100S Intermediate Modulus
            Ef = 324e9;     % Pa
            nuf = .2;       % (typical for carbon fiber, table 2.1)
            Sfu = 7000e6;   % Pa
            [ E11, E22, nu12, nu21, G12, SLt, STt, SLTs ] = materialConstants(Ef, Em, vf, nuf, num, Sfu, Smu);
        case 2 % M60J High Modulus
            Ef = 588e9;     % Pa
            nuf = .2;       %  (typical value)
            Sfu = 3820e6;   % Pa        
            [ E11, E22, nu12, nu21, G12, SLt, STt, SLTs ] = materialConstants(Ef, Em, vf, nuf, num, Sfu, Smu);
        case 3 % T800S Intermediate Modulus
            Ef = 294e9;     % Pa
            nuf = .2;       %  (typical value)
            Sfu = 5880e6;   % Pa
            [ E11, E22, nu12, nu21, G12, SLt, STt, SLTs ] = materialConstants(Ef, Em, vf, nuf, num, Sfu, Smu);
        case 4 % T1000G Intermediate Modulus
            Ef = 294e9;     % Pa
            nuf = .2;       % (typical value)
            Sfu = 6370e6;   % Pa
            [ E11, E22, nu12, nu21, G12, SLt, STt, SLTs ] = materialConstants(Ef, Em, vf, nuf, num, Sfu, Smu);  
    end

    [A, B, D] = ABD(thetas, plyThickness, E11, E22, nu12, nu21, G12);
    [ laminateStrain, laminateCurvature ] = laminateStrainCurv(A, B, D, N, M);

    failure = zeros(numPlies, 1);
    for i = 1:numPlies
        z = -(numPlies/2-.5)*plyThickness*((-2/(numPlies-1))*(i-1)+1);
        laminaStrain = laminateStrain + z*laminateCurvature;
        laminaQbar = Qbar(E11, E22, nu12, nu21, G12, thetas(i));
        laminaStress = laminaQbar*laminaStrain;
        failure(i) = ATHFailTest(laminaStress, thetas(i), SLt, STt, SLTs);
    end

    c = failure-1;
else
    c = zeros(numPlies, 1) + 1;
end

ceq = [];

end