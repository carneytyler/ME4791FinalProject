function [ E11, E22, nu12, nu21, G12, SLt, STt, SLTs ] = materialConstants(Ef, Em, vf, nuf, num, Sfu, Smu)  

vm = 1 - vf;

E11 = Ef*vf + Em*vm;
E22 = (Ef*Em)/(Ef*vm + Em*vf);
nu12 = nuf*vf + num*vm;
nu21 =  E22/E11*nu12;

Gf = Ef/(2*(1+nuf));
Gm = Em/(2*(1+num));
G12 = (Gf*Gm)/(Gf*vm + Gm*vf);

epsfu=Sfu/Ef;
epsmu=Smu/Em;
if epsmu>=epsfu
    Smp=Em*epsfu; 
else
    Smp=Smu;
end
SLt=Sfu*vf+Smp*vm; % Sfu is fiber longitudinal tensile strength, Smp is the matrix stress below or at the fiber's ultimate strain.
KS=(1-vf*(1-(Em/Ef)))/(1-sqrt(4*vf/pi)*(1-Em/Ef));
STt=Smu/KS;
% Major assumption: shear stress is 60% of tensile strength
SLTs=0.6*SLt;

end