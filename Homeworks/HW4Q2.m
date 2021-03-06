% MATH:8110 Spring 2019 
% Homework 4, Question 2
% You are encouraged to try different parameters, such as different starting points, to 
% see what happens

clear;
clc;
close all;

%% Rosenbrock function

f = @(x) 100*(x(2)-x(1).^2).^2+(1-x(1)).^2;
gradf = @(x) [-400*(x(2)-x(1).^2).*x(1)+2*(x(1)-1);
             200*(x(2)-x(1).^2)];
hessf = @(x) [-400*(x(2)-3*x(1).^2)+2, -400*x(1);
              -400*x(1),                    200];
          
%% Parameters

tol = 1e-4;     % gradient descent method terminates when ||gradf(x)|| < tol
x0 = [0;0];     % starting point
maxIter = 1e4;  % gradient descent method terminates when # iterations 
                % exceeds maxIter (in case it converges too slow)

H = @(x) [400*(3*x(1)^2-x(2))+2 -400*x(1); -400*x(1) 200];

%% Initialization
n = length(x0);
xk = zeros(n,maxIter);
fxk = zeros(1,maxIter);
alphak = zeros(1,maxIter);
gradfxk = zeros(n,maxIter);
normGrad = zeros(1,maxIter);

%% Step 0
xk(:,1) = x0;
fxk(1) = f(xk(:,1));
gradfxk(:,1) = gradf(xk(:,1));
normGrad(1) = norm(gradfxk(:,1),2);
it = 1;

%% Looping
while it <= maxIter && normGrad(it) > tol
    xk(:,it+1) = xk(:,it) - H(xk(:,it))\gradfxk(:,it); %update xk+1
    fxk(it+1) = f(xk(:,it+1)); %and other parameters
    gradfxk(:,it+1) = gradf(xk(:,it+1));
    normGrad(it+1) = norm(gradfxk(:,it+1),2);
    it = it+1;
    
end
x = xk(:,it);
xk = xk(:,1:it);
fxk = fxk(:,1:it);
gradfxk = gradfxk(:,1:it);
normGrad = normGrad(:,1:it);

%% Plot


% linear convergence
figure(2);
semilogy(fxk);

% zig-zag
figure(3);
[X,Y]=meshgrid(-0.1:0.01:1.1);
Z=100*(Y-X.^2).^2+(ones(size(X))-X).^2;
levels = 0:0.2:5;
contour(X,Y,Z,levels)
hold on;
plot(1,1,'x');
plot(xk(1,:),xk(2,:));
hold off;