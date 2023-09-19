function [minf,tm,hinf,th,ninf,tn] = hhrate(v)
% Calculate the values of the rate constants for a membrane depolarization/hyperpolarization of v mV
% v > 0 = depolarization
% v < 0 = hyperpolarization

% Calculate rate constants for the activation variable 'n'
alphan = 0.01*(10-v)/(exp((10-v)/10)-1);
betan = 0.125*exp(-v/80);

% Calculate rate constants for the activation variable 'm'
alpham = 0.1*(25-v)/(exp((25-v)/10)-1);
betam = 4*exp(-v/18);

% Calculate rate constants for the inactivation variable 'h'
alphah = 0.07*exp(-v/20);
betah = 1/(exp((30-v)/10)+1);

% Calculate time constants for 'm', 'h', and 'n'
tm = 1/(alpham+betam);
th = 1/(alphah+betah);
tn = 1/(alphan+betan);

% Calculate the steady-state values for 'm', 'h', and 'n'
minf = alpham*tm;
hinf = alphah*th;
ninf = alphan*tn;
