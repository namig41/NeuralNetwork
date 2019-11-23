clc;
clear all;
close all;
% 
% tic
% Class1 = NMatrix([randi(100, 500, 1) randi(50, 500, 1)]);
% Class2 = NMatrix([randi(100, 500, 1) randi([51, 100], 500, 1)]);
% 
% Class1.unique();
% Class2.unique();
% 
% clr = Classificator(2, 10);
% 
% C1 = NMatrix();
% C2 = NMatrix();
% 
% [X,Y] = meshgrid(1:100, 1:100);
% XY = Class1.unique_matrix([X(:) Y(:)]);
% clear X; clear Y; clear ans;
% 
% for i=1:XY.n
%     row = XY.get_row(i);
%     if clr.binaryClassificationParzenWindow(Class1.matrix, Class2.matrix, row)
%         C1.add_row(row);
%     else
%         C2.add_row(row);
%     end
% end
% clear i; clear row;
% 
% Class1.add_col(ones([Class1.n 1]));
% Class2.add_col(ones([Class2.n 1]) * -1);
% [analysisError, h] = clr.bootstrap(NMatrix([Class1.matrix; Class2.matrix]), 50, 30);
% El = clr.LOO(NMatrix([Class1.matrix; Class2.matrix]), 10);
% 
% figure(1)
% hold on;
% line([0 100], [51 51], 'color', 'm', 'linewidth', 2);
% scatter(Class1.matrix(:, 1), Class1.matrix(:, 2), 'r', 'filled'); 
% scatter(Class2.matrix(:, 1), Class2.matrix(:, 2), 'g', 'filled'); 
% hold off;
% 
% figure(2)
% hold on;
% scatter(C1.matrix(:, 1), C1.matrix(:, 2), 'r', 'filled'); 
% scatter(C2.matrix(:, 1), C2.matrix(:, 2), 'g', 'filled');
% hold off;
% 
% figure(3)
% hold on
% plot(1:analysisError.m, analysisError.matrix(1, :));
% plot(1:analysisError.m, analysisError.matrix(2, :));
% xlabel('h');
% ylabel('STD MEAN');
% hold off
% 
% disp('Bootstrap: h='); disp(h);
% disp('LOO: h='); disp(find(El.matrix == min(El.matrix)));
% 
% figure(4)
% bar(El.matrix);
% title('LOO');
% xlabel('h');
% ylabel('Error');
% toc

% LAB 2
% tic
% k = randi([5 50]) / 10;
% b = 1;
% 
% [X,Y] = meshgrid(1:100, 1:100);
% XY = [X(:) Y(:)];
% 
% C1 = NMatrix(XY(find(k*X(:) + b > Y(:)), :));
% C2 = NMatrix(XY(find(k*X(:) + b < Y(:)), :));
% clear k; clear b;
% clear X; clear Y;
% 
% CR1 = NMatrix(C1.matrix(randi(C1.n, 500, 1), :));
% CR2 = NMatrix(C2.matrix(randi(C2.n, 500, 1), :));
% 
% CR1.unique();
% CR2.unique();
% 
% C = NMatrix([[CR1.matrix ones(CR1.n, 1)];
%              [CR2.matrix zeros(CR2.n, 1)]]);
% 
% Nopt = Classificator.LOO_RF(C, 40);
% 
% 
% RF = cell(Nopt);
% for j=1:Nopt
%     sample = C.matrix(randi(C.n, C.n, 1), :);
%     RF{j} = treefit(sample(:, [1 2]), sample(:, end));
% end
% 
% for i=1:size(XY, 1)
%     s = 0;
%     for j=1:Nopt
%         s = s + treeval(RF{j}, XY(i, :));
%     end
%     if round(s / Nopt)
%         scatter(XY(:, 1), XY(:, 2), 'r', 'filled'); 
%     else
%         scatter(XY(:, 1), XY(:, 2), 'g', 'filled'); 
%     end
% end
% 
% figure(1)
% hold on
% scatter(CR1.matrix(:, 1), CR1.matrix(:, 2), 'r', 'filled');
% scatter(CR2.matrix(:, 1), CR2.matrix(:, 2), 'g', 'filled');
% hold off
% toc

% LAB 3
tic
k = randi([5 50]) / 10;
b = 1;

[X,Y] = meshgrid(1:100, 1:100);
XY = [X(:) Y(:)];

C1 = NMatrix(XY(find(k*X(:) + b > Y(:)), :));
C2 = NMatrix(XY(find(k*X(:) + b < Y(:)), :));
clear k; clear b;
clear X; clear Y;

train_set1 = NMatrix(C1.matrix(randi(C1.n, 500, 1), :));
train_set2 = NMatrix(C2.matrix(randi(C2.n, 500, 1), :));

train_set1.unique();
train_set2.unique();

C1 = train_set1.unique_matrix(C1.matrix);
C2 = train_set2.unique_matrix(C2.matrix);

control_set1 = NMatrix(C1.matrix(randi(C1.n, 170, 1), :));
control_set2 = NMatrix(C2.matrix(randi(C2.n, 170, 1), :));

control_set1.unique();
control_set2.unique();

nn_setting.inodes = 2;
nn_setting.hnodes = 2;
nn_setting.onodes = 1;
nn_setting.lr = 0.3;

nn = NeuralNetwork(nn_setting);

train_set = [train_set1.matrix ones(train_set1.n, 1); 
          train_set2.matrix -ones(train_set2.n, 1)];

nn.train(train_set(randi(size(train_set, 1), 10000, 1), :), 10);

figure(1)
hold on
scatter(control_set1.matrix(:, 1), control_set1.matrix(:, 2), 'r', 'filled');
scatter(control_set2.matrix(:, 1), control_set2.matrix(:, 2), 'g', 'filled');
hold off
toc

figure(2)
hold on
for i=1:size(XY, 1)
    if sign(nn.query(XY(i, :))) >= 0;
        scatter(XY(:, 1), XY(:, 2), 'r', 'filled');
    else
        scatter(XY(:, 1), XY(:, 2), 'g', 'filled');
    end
end
hold off




%imshow(reshape(data(2, 2:end), [28, 28])')
