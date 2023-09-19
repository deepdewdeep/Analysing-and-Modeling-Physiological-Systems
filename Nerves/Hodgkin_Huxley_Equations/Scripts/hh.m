function yprime = hh(t, y)
% Hodgkin-Huxley (H-H) neuron model simulation
%
% This function implements the Hodgkin-Huxley equations to simulate the
% behavior of a neuron's membrane potential and gating variables over time.
%
% Input:
%   t: Time
%   y: Vector of state variables representing the neuron's membrane potential
%      and gating variables.
%
% Output:
%   yprime: Vector of derivatives of the state variables.

% Declare global variables to be used
global g_na_max g_k_max g_l e_vr e_na e_k e_l CM;
global amp1 vclamp ic sramp kt;

% Calculate rate constants for gating variables
[minf, tm, hinf, th, ninf, tn] = hhrate(y(1) - e_vr);

% Calculate the total membrane current (yp)
if amp1 ~= 0 || sramp ~= 0
    % Current calculation based on ion channel conductances
    jm = (g_na_max * (y(2)^3) * y(3) * (e_na - y(1)) + ...
          g_k_max * (y(4)^4) * (e_k - y(1)) + g_l * (e_l - y(1))) / CM;
    if sramp ~= 0
        % Square wave pulse (sramp) contribution
        yp = sramp * t + jm;
    else
        % External current (ic) contribution
        yp = ic + jm;
    end
elseif vclamp ~= 0
    % In voltage clamp mode, membrane potential is clamped
    yp = 0;
end

% Set up the system of differential equations
yprime = [yp;
          kt * (minf - y(2)) / tm;
          kt * (hinf - y(3)) / th;
          kt * (ninf - y(4)) / tn;];
