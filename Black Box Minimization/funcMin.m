%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Minimization
%
% Inputs
%   f - handle for function evaluation
%   getDirection - function handle for computing direction
%   x0 - initial point
%   param - structure of optional parameters
%       lambda - learning rate (optional)
%       getStepSize - function handle for computing step size
%       itCount - max number of iterations
%       verbose - boolean variable that denotes whether or not to output full information
%       eps - epsilon tolerance for quitting
%
% Outputs
%   solu - final converged value
%   output - structure containing output values
%       exitFlag - how the code exited
%       x - history of iterates
%       objVal - vector of objective values
%
%
% Notes
%   funcMin is broken down into four steps. While we have not met exit
%   conditions,
%   1. Decide on a direction.  This is done by the param.getDirection function
%   2. Decide on a step size.  This is done by the param.lambda value or
%   values.  If this is empty, then a linesearch method must be provided
%   into param.linesearch
%   3. Update our point, check exit conditions.
%
% Author
%   Trevor Squires
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [solu,output] = funcMin(f,getDirection,x0,param)
%% Initialize variables
if ~(isfield(param,'getStepSize'))
    lambda = defaultField(param,'lambda',0.001);
    getStepSize = @(x,d) lambda;
else %if we don't have a get step size function, user must have input one
    getStepSize = param.getStepSize;
end

eps = defaultField(param,'eps',1e-8);
itCount = defaultField(param,'itCount',1000);
verbose = defaultField(param,'verbose',0);


n = length(x0);
x = zeros(n,itCount);
fVal = zeros(1,itCount);
x(:,1) = x0;
fVal(1) = f(x0);

totCalls = 0;

for it = 1:itCount
    % Compute direction 
    direction = getDirection(x(:,it));
    
    % Compute step size
    [lambda,funcCalls] = getStepSize(x(:,it),direction);
    totCalls = totCalls+funcCalls;
    
    % New point
    x(:,it+1) = x(:,it) + lambda*direction;

    
    %Optional verbose variables
    if verbose
        fVal(it+1) = f(x(:,it+1));
        if fVal(it+1) >= fVal(it)
            disp('help')
        end
    end
    
    % Compute exit conditions
    if fVal(it+1) < eps
        break;
    end
end

% Set output parameters
if it == itCount
    output.exitFlag = 1;
else
    output.exitFlag = 0;
end

solu = x(:,it-1);
output.it = it;
if verbose
    output.iterates = x(:,1:it);
    output.objVal = fVal(:,1:it);
    output.funcCalls = totCalls;
end

        
end
