clear all;
close all;
clc;

% this is a demo for Gaussian Process Regression
% for more information please refer to 'Gaussian proecess regression a quick introduction.pdf'
% written by NeoChow @HIT 2017/10/10
% the x range from -1.8 to 0.2
x = [-1.5, -1.0, -0.75, -0.4, -0.25, 0.00]; % training set
y = 0.55*[-3 -2 -0.6 0.4 1 1.6];              % coresponding value of x
figure(1);
scatter(x,y,'r.');
hold on;
K = [1.70 1.42 1.21 0.87 0.72 0.51;         % covariance matrix of training set
    1.42 1.70 1.56 1.34 1.21 0.97;
    1.21 1.56 1.70 1.51 1.42 1.21;
    0.87 1.34 1.51 1.70 1.59 1.48;
    0.72 1.21 1.42 1.59 1.70 1.56;
    0.51 0.97 1.21 1.48 1.56 1.70];
sigman = 0.3;   % the covariance of the noise
sigmaf = 1.27;  % hyperparameter of SE kernel the constant factor
l = 1;          % hyperparameter of SE kernel the length factor
% compute the K*, the new x*'s are vector from -1.8 to 0.2
xtest = -1.8 : 0.01: 0.2;
K_ = zeros(length(x), length(xtest));       % K_ is the matrix(K(X, X*))
for ii = 1:length(x)
    for jj = 1:length(xtest)
        K_(ii,jj) = sigmaf^2*exp(-(x(ii) - xtest(jj))^2/(2*l*l));
%         if x(ii) == xtest(jj)
%             K_(ii,jj) = K_(ii,jj) + sigman^2;
%         end
    end
end
y_ = K_'*(inv(K))*(y');
plot(xtest,y_','k-');

