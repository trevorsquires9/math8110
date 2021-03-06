function [stepSize] = bisectSearch(gradf, tol, uB)

a = 0;
b = uB;

while b-a > tol
    stepSize = (b+a)/2;
    gradIterate = gradf(stepSize);
    if gradIterate == 0
        break;
    elseif gradIterate > 0
        b = stepSize;
    else
        a = stepSize;
    end
end


end

