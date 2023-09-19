function hhmplot(to, tf, ol)
% hhmplot - Hodgkin-Huxley neuron model simulation and plotter
%
% This function numerically solves the Hodgkin-Huxley equations for a specified
% time range and plots the membrane potential (V_m), sodium activation gate (m),
% sodium inactivation gate (h), and potassium gate (n).
%
% Input:
%   to: Initial time
%   tf: Final time
%   ol: Overlay flag (1 for overlay, 0 for replace)

global yo e_vr minfr hinfr ninfr;
global amp1 amp2 width1 width2 delay1 delay2 ic vclamp;
global cmap numover;

% Update all necessary precalculated parameters
hhparams;

% Integrate the equations up to the first stimulus (if applicable)
[ti, yi] = hode('hh', [to, to + delay1], yo);
len = length(yi(:, 1));
yo = yi(len, :)';

% Handle voltage clamp or current clamp scenarios
if vclamp ~= 0
    yo = [vclamp; yo(2:4)];
    [t1, y1] = hode('hh', [to + delay1, to + delay1 + width1], yo);
    len = length(t1);
    yo = [e_vr; y1(len, 2:4)'];
    [t2, y2] = hode('hh', [to + delay1 + width1, tf], yo);
    t = [ti; t1; t2];
    y = [yi; y1; y2];
elseif amp1 ~= 0
    ic = amp1;
    [t1, y1] = hode('hh', [to + delay1, to + delay1 + width1], yo);
    len = length(t1);
    yo = y1(len, 1:4)';
    ic = 0;
    [t2, y2] = hode('hh', [to + delay1 + width1, to + delay1 + width1 + delay2], yo);
    len = length(t2);
    yo = y2(len, 1:4)';
    ic = amp2;
    [t3, y3] = hode('hh', [to + delay1 + width1 + delay2, to + delay1 + width1 + delay2 + width2], yo);
    len = length(t3);
    yo = y3(len, 1:4)';
    ic = 0;
    [t4, y4] = hode('hh', [to + delay1 + width1 + delay2 + width2, tf], yo);
    t = [ti; t1; t2; t3; t4];
    y = [yi; y1; y2; y3; y4];
end

% Extend the time axis to indicate when the stimulus was applied
t = [-0.1 * (tf - to); to; t];
y = [e_vr minfr hinfr ninfr; e_vr minfr hinfr ninfr; y];
to = -0.1 * (tf - to);

cline = 'y';
figure(1);
set(1, 'Position', [200 150 620 600], 'Color', 'k');
if ol
    cindx = rem(numover, 6);
    cline = cmap(cindx + 1);
    subplot(2, 2, 1); hold on; subplot(2, 2, 2); hold on; subplot(2, 2, 3); hold on; subplot(2, 2, 4); hold on;
    numover = numover + 1;
else
    numover = 1;
    subplot(2, 2, 1); hold off; subplot(2, 2, 2); hold off; subplot(2, 2, 3); hold off; subplot(2, 2, 4); hold off;
end

subplot(2, 2, 1); plot(t, y(:, 1), cline);
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
xlabel('time (ms)', 'Color', 'w'), ylabel('V_m (mV)', 'Color', 'w'), axis([to tf -100 50]);
title('Membrane potential', 'Color', 'w');

subplot(2, 2, 2); plot(t, y(:, 2), cline);
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
xlabel('time (ms)', 'Color', 'w'), ylabel('m(t) (dimensionless)', 'Color', 'w'), axis([to tf 0 1]);
title('Sodium activation gate', 'Color', 'w');

subplot(2, 2, 3); plot(t, y(:, 3), cline);
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
xlabel('time (ms)', 'Color', 'w'), ylabel('h(t) (dimensionless)', 'Color', 'w'), axis([to tf 0 1]);
title('Sodium inactivation gate', 'Color', 'w');

subplot(2, 2, 4); plot(t, y(:, 4), cline);
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
xlabel('time (ms)', 'Color', 'w'), ylabel('n(t) (dimensionless)', 'Color', 'w'), axis([to tf 0 1]);
title('Potassium gate', 'Color', 'w');
