clear
clc

% ME 4791 Project, Fall 2020
% Tyler Carney, Matthew Dudon, Paul Li, Noah Liebman, Myles Sun

%--------------------------------------------------------------------------
%Loads
Nxx = 200000; %N
Nyy = 150000; %N
Mxx = 2000;   %Nm

%Dimensions
L = 0.3048;     % m
w = 0.1270;     % m

Nxxpm = Nxx/w; %Nx per (p) m
Nyypm = Nyy/L; %Ny per (p) m
N = [Nxxpm; Nyypm; 0];
M = [Mxx; 0; 0];

% Design Variables
% [Fiber volume; Ply thickness; Ply angle; Ply angle; Ply angle...]

% The Ply angles from the design var vector are doubled and flipped to
% impose symmetry
% [1, 2, 3] as a result from the optimizer is actually a [1, 2, 3, 3, 2, 1]
% laminate.

% The solution in the stackup variable will be displayed in integers 1-8
% Each integer corresponds to the theta value from the vector below 
%           1;   2;  3;   4;  5;   6;  7;  8
% thetas = [0; -30; 30; -45; 45; -60; 60; 90];

%--------------------------------------------------------------------------

opts = optimoptions(@ga, ...
                    'PopulationSize', 200, ...
                    'MaxGenerations', 1000, ...
                    'EliteCount', 10, ...
                    'FunctionTolerance', 1e-9);
                
results = zeros(2, 2);
solutions = cell(2, 2);
exitConditions = zeros(2, 2);
for i = 1:4       %Tests each of our fiber types individually
    cntr = 1;
    for j = 5:8   %Tests different potential number of plies
        plyAngle = zeros(j, 1);
        lowerBound = [.55; .000125; plyAngle + 1];
        upperBound = [.55; .000300; plyAngle + 8];
        fiberType = i;
        
        objFun = @laminateThickness;
        nonlcon = @(designVar)laminaFailure(N, M, fiberType, designVar);
        
        [stackup, thickness, exitflag] = ga(objFun, j+2, [], [], [], [], lowerBound, upperBound, nonlcon, 3:j+2, opts);      
        results(cntr, i) = thickness;
        solutions{cntr, i} = stackup.';
        exitConditions(cntr, i) = exitflag;
        cntr = cntr + 1;
    end
end
results
solutions
exitConditions
