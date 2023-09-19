% hode - Wrapper for ODE45 Solver
%   [t, y] = hode(fh, ts, yo) is a wrapper function for the ODE45 solver in
%   MATLAB. It is designed to handle the specific case where ts(1) is equal
%   to ts(2), returning an immediate result without solving the
%   differential equation in that case.
%
%   Inputs:
%     - fh: The handle to the differential equation function, which
%       describes the system of first-order ODEs.
%     - ts: A two-element array representing the time span [t_start, t_end].
%       If ts(1) is equal to ts(2), the function returns an immediate result
%       without solving the ODE.
%     - yo: The initial conditions for the differential equation, given as
%       a column vector.
%
%   Outputs:
%     - t: The time vector, containing time points at which the solution
%       was computed.
%     - y: The solution vector, containing the corresponding values of the
%       dependent variables at the time points specified in t.

function [t, y] = hode(fh, ts, yo)
    % Declare global variables for ODE solver and options
    global odesolver odeopt;
    
    % Check if the time span is non-trivial (ts(1) != ts(2))
    if ts(1) ~= ts(2)
        % Solve the differential equation using the specified ODE solver
        [t, y] = eval(odesolver);
    else
        % In the special case where ts(1) == ts(2), return immediate result
        
        % Set the time vector to the common time point
        t = ts(1);
        
        % Transpose the initial conditions to ensure correct dimensions
        y = yo';
    end
end
