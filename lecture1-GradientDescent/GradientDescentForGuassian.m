% 二维高斯分布用于测试梯度下降法
close all;
clear all;
clc;

% 产生高斯分布
mu = [0, 0]; % 均值向量
sigma = [3.3, 0.2; -1, 1]; % 方差矩阵
x = [-3: 0.1 :3];
y = [-3: 0.1 :3];
const = (2*pi*sqrt(det(sigma)))^(-1);
Z = zeros(length(x), length(y));
for ii = 1:length(x)
    for jj = 1:length(y)
        Z(ii, jj) = const * exp(-0.5*([x(ii); y(jj)] - mu')'*inv(sigma)*([x(ii); y(jj)] - mu'));
    end
end
figure; % 绘制三维平面图和轮廓图
surf(x, y, Z);
figure;
contour(x, y, Z);
hold on;

% 梯度上升（下降）法
syms tx ty tz;
tz = const * exp(-0.5*([tx; ty] - mu')'*inv(sigma)*([tx; ty] - mu'));
grad = [diff(tz, tx), diff(tz, ty)]; % 求梯度
xold = 1.2;
yold = 2.9; % 起始点位置
alpha = 10; % 学习率设置
plot(xold, yold, 'r*');
hold on;
delt = 100; % 每个线段之间的
for n = 1:20
    res = alpha * double(subs(grad, {tx,ty}, {xold, yold}));
    xnew = xold + res(1);
    ynew = xold + res(2);
    plot(xold:(xnew-xold)/100:xnew,yold:(ynew-yold)/100:ynew,'r');
    hold on;
    plot(xnew, ynew, 'r*');
    hold on;
    xold = xnew;
    yold = ynew;
end

