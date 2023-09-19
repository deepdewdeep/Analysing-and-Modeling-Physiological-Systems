% Define necessary constants for H-H equations

% Define variables of global scope
global g_na_max g_k_max g_l e_vr e_na e_k e_l CM yo;
global delay1 delay2 sramp tempc width1 amp1 width2 amp2;
global co_na co_k ci_na ci_k kt vclamp;
global minfr hinfr ninfr
global g_na_vr g_k_vr ic;
global cmap numover odesolver;
global odeopt;

% Set the temperature (in degrees Celsius)
tempc = 6.3;

% Stimulus parameters
delay1 = 0;
delay2 = 0;
width1 = 40;
width2 = 0;
amp1 = 5; % Stimulating current in microamps/cm^2
amp2 = 0;
sramp = 0; % Square wave pulse in microamps/(cm^2 ms)
vclamp = 0; % Voltage clamp in mV
ic = 0; % External current in microamps/cm^2

% Membrane capacitance (Cm) in microfarads/cm^2
CM = 1;

% Default ion concentrations for squid axon in sea water (mmol/l)
co_na = 491;
co_k = 20.11;
ci_na = 50;
ci_k = 400;

% Set maximum channel conductances in mS/cm^2
g_na_max = 120;
g_k_max = 36;
g_l = 0.3;

% Unchanging leakage reversal potential
e_l = -49;

% Basic text color map
numover = 0;
cmap = ['y' 'b' 'r' 'g' 'c' 'm'];

% Determine the MATLAB version and choose an appropriate ODE solver
mver = version;

if str2num(mver(1)) >= 5
    odesolver = 'ode15s(fh,ts,yo,odeopt)';
    odeopt = odeset('RelTol', 1e-6, 'AbsTol', 1e-9, 'Refine', 4);
else
    odesolver = 'ode45(fh,ts(1),ts(2),yo)';
end
