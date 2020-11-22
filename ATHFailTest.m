function [fail] = ATHFailTest(laminaStress, theta, SLt, STt, SLTs)

thetas = [0; -30; 30; -45; 45; -60; 60; 90];
theta = thetas(theta);
theta = theta*pi/180;

sig11 = laminaStress(1)*cos(theta)^2 + laminaStress(2)*sin(theta)^2 + 2*laminaStress(3)*cos(theta)*sin(theta);
sig22 = laminaStress(1)*sin(theta)^2 + laminaStress(2)*cos(theta)^2 - 2*laminaStress(3)*cos(theta)*sin(theta);
tau12 = (-laminaStress(1) + laminaStress(2))*sin(theta)*cos(theta) + laminaStress(3)*(cos(theta)^2-sin(theta)^2);

fail = (sig11^2/SLt^2-(sig11*sig22)/SLt^2+sig22^2/STt^2+tau12^2/SLTs^2);

end

