close all;
clear all;
clc;

% choose a kernel (covariance function)
kernel = 2;
switch kernel
    case 1; k = @(x,y) 1*x'*y;
    case 2; k = @(x,y) exp(-100*(x-y)'*(x-y));
    case 4; k = @(x,y) exp(-1*sqrt((x-y)'*(x-y)));
    case 6; k = @(x,y) exp(-100*min(abs(x-y),abs(x+y)));
end

% choose points at which to sample
points = (0:0.05:1)';
[U,V] = meshgrid(points,points);
x = [U(:) V(:)]';
n = size(x,2);

% construct the covariance matrix
C = zeros(n,n);
for ii = 1:n
    for jj = 1:n
        C(ii,jj) = k(x(:,ii),x(:,jj));
    end
end

%sample from the Guassian process at these points
u = randn(n,1);     %sample u ~ N(0, I)
[A,S,B] = svd(C);   %factor C = ASB'
z = A*sqrt(S)*u;    %z = AS^.5u ~ N

%plot
figure(2);clf;
Z = reshape(z, sqrt(n), sqrt(n));
surf(U,V,Z);
