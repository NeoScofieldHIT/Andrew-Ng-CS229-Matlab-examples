close all;
clear all;
clc;

% choose a kernel (covariance function)
kernel = 5;
switch kernel
    case 1; k = @(x,y) 1*x'*y;
    case 2; k = @(x,y) 1*min(x,y);
    case 3; k = @(x,y) exp(-100*(x-y)'*(x-y));
    case 4; k = @(x,y) exp(-1*sqrt((x-y)'*(x-y)));
    case 5; k = @(x,y) exp(-1*sin(5*pi*(x-y))^2);
    case 6; k = @(x,y) exp(-100*min(abs(x-y),abs(x+y))^2);
end

% choose points at which to sample
x = (0:0.005:1);
n = length(x);

% construct the covariance matrix
C = zeros(n,n);
for ii = 1:n
    for jj = 1:n
        C(ii,jj) = k(x(ii),x(jj));
    end
end

%sample from the Guassian process at these points
u = randn(n,1);     %sample u ~ N(0, I)
[A,S,B] = svd(C);   %factor C = ASB'
z = A*sqrt(S)*u;    %z = AS^.5u ~ N

%plot
figure(2);
hold on;%clf;
plot(x,z,'.')
axis([0,1,-2,2])
