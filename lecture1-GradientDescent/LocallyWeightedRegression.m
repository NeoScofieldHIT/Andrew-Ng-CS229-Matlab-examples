% 局部加权线性回归（Locally Weighted Linear Regression）
clear all;
close all;
clc;
rng('default');

% 产生数据集（Generating training set）
syms x f;
f = -(x-10)^2 + 100;
N = 30; % 数据集点数
noise = 4 * randn(1, N);
tx = 9 * rand(1, N);
ty = double(subs(f, {x}, {tx}));
ty = ty + noise;
figure;
scatter(tx, ty, 'r.');
hold on;

% 产生基准拟合曲线f
t = 0:0.05:10;
y = -(t - 10).^2 + 100;
plot(t, y, 'g');

% 预测：
weight = zeros(1, length(tx));
tau = 1; % bandwith parameter
syms deJ jj theta0 theta1;
alpha = 0.5; % learning rate
xold = 0; % 原点坐标，初始位置
yold = 0;
for query = 1:10
    theta0num = 1; % 参数初始值
    theta1num = 1;
    tmp = [theta0num, theta1num];
    for train = 1: length(tx)
        weight(train) = exp(-(tx(train) - query).^2/(2*tau^2));
        jj = weight .* (ty - theta0 - theta1 * tx).^2;
        deJ = [diff(sum(jj), theta0), diff(sum(jj), theta1)]; %梯度
        for kk = 1:5
            tmp = tmp - alpha*double(subs(deJ, {theta0, theta1}, {theta0num, theta1num}));
            theta0num = tmp(1);
            theta1num = tmp(2);
        end
    end
    plot(query, theta0num + theta1num*query, 'b*');
    hold on;
    plot(xold:(query - xold)/2:query, yold:(theta0num + theta1num*query - yold)/2:(theta0num + theta1num*query), 'b'); % 画直线
    hold on;
    xold = query;
    yold = theta0num + theta1num*query;
end

