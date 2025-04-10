function [nsv,beta,bias]=svr(X,Y,ker,C,loss,e)

% SVR Support Vector Regression
% Usage : [nsv beta bias]=svr(X,Y,ker,C,loss,e)
% Parameters : X - Training inputs
% Y - Training targets
% ker - kernel function
% C - upper bound ( non - separable case )
% loss - loss function
% e - insensitivity
% nsv - number of support vectors
% beta - Difference of Lagrange Multipliers
% bias - bias term
%
% Author : Steve Gunn ( srg@ecs . soton . ac .uk )
if (nargin<3|nargin>6) % check correct number of arguments
help svr
else
fprintf ('Support Vector Regressing ...\n')
fprintf ('______________________________\n')
n = size (X ,1);
if(nargin<6) e =0.0;end
if(nargin<5) loss='eInsensitive';end
if(nargin<4) C=Inf;end
if(nargin<3) ker='linear';end
% Construct the Kernel matrix
fprintf ('Constructing ...\n');
H = zeros (n,n);
for i =1: n
for j =1: n
H(i,j)=svkernel(ker,X(i ,:),X(j ,:));
end
end
% Set up the parameters for the Optimisation problem
switch lower ( loss )
case ' einsensitive '
Hb = [ H -H ; - H H];
c = [( e* ones (n ,1) - Y ); ( e* ones (n ,1) + Y )];
vlb = zeros (2* n ,1); % Set the bounds : alphas >= 0
vub = C* ones (2* n ,1); % alphas <= C
x0 = zeros (2* n ,1); % The starting point is [0 0 0 0]
neqcstr = nobias ( ker ); % Set the number of equality constraints (1 or 0)
if neqcstr
A=ones(1,n)-ones(1,n); b = 0; % Set the constraint Ax = b
else
A = []; b = [];
end
end