close all;
clear all;
clc;

% 训练集生成
rng('default'); %默认模式，使得每次生成的随机数样本都相同
N = 200;
X = 10*rand(N, 2) - 5; % 第一列和第二列分别是横坐标和纵坐标
y = zeros(N, 1) - 1;
y((X(:, 1).^3 + X(:, 1).^2 + X(:, 1) + 1)/20 < X(:, 2)) = 1; % 在曲线上方区域内的标记为1

% 数据可视化
scatter(X(y == -1, 1), X(y == -1, 2), 'k.');
hold on;
scatter(X(y == 1, 1), X(y == 1, 2), 'g.');
t = -5: 0.01 :5;
plot(t, (t.^3 + t.^2 + t + 1)/20, 'r'); % 分界面

% 生成测试样本
N2 = 200;
X2 = 10*rand(N2, 2) - 5;
y2 = zeros(N2, 1) - 1;
y2((X2(:, 1).^3 + X2(:, 1).^2 + X2(:, 1) + 1)/20 < X2(:, 2)) = 1;

% 计算高斯核矩阵K
sigma = 5;
K = zeros(N, N);
for i = 1:N
    for j= i:N
        t = X(i, :) - X(j, :);
        K(i, j) = exp(-(t * t')/sigma^2);
        K(j, i) = K(i, j);
    end
end

% 适配对应QP函数的参数
H = (y*y').* K;
f = -ones(N, 1);
A = -eye(N);
b = zeros(N, 1);
Aeq = y';
beq = 1;

% 计算α和b*
alpha = quadprog(H, f, A, b, Aeq, beq);
idx = find(abs(alpha) > 1e-4) ; %画出支持向量
plot(X(idx, 1), X(idx, 2), 'bo');
b = y(idx(1)) - (alpha.*y)'*K(:, idx(1));

% 预测过程
K2 = zeros(N, N2);
for i = 1:N2
    t = sum((X - (X2(i, :)'*ones(1, N))').^2, 2);
    K2(:, i) = exp(-t/sigma^2);
end
y_pred = sign((alpha.*y)'*K2 + b)';
sum(y2 == y_pred)/N2 % 计算精度
