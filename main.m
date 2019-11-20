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
% nn = Classificator(2, 10);
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
%     if nn.binaryClassificationParzenWindow(Class1.matrix, Class2.matrix, row)
%         C1.add_row(row);
%     else
%         C2.add_row(row);
%     end
% end
% clear i; clear row;
% 
% Class1.add_col(ones([Class1.n 1]));
% Class2.add_col(ones([Class2.n 1]) * -1);
% [analysisError, h] = nn.bootstrap(NMatrix([Class1.matrix; Class2.matrix]), 50, 30);
% El = nn.LOO(NMatrix([Class1.matrix; Class2.matrix]), 10);
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
% T1 = NMatrix();
% T2 = NMatrix();
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
%         T1.add_row(XY(i, :));
%     else
%         T2.add_row(XY(i, :));
%     end
% end
% 
% figure(1)
% hold on
% scatter(CR1.matrix(:, 1), CR1.matrix(:, 2), 'r', 'filled');
% scatter(CR2.matrix(:, 1), CR2.matrix(:, 2), 'g', 'filled');
% hold off
% 
% figure(2)
% hold on
% scatter(T1.matrix(:, 1), T1.matrix(:, 2), 'r', 'filled'); 
% scatter(T2.matrix(:, 1), T2.matrix(:, 2), 'g', 'filled'); 
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

traning_set1 = NMatrix(C1.matrix(randi(C1.n, 500, 1), :));
traning_set2 = NMatrix(C2.matrix(randi(C2.n, 500, 1), :));

traning_set1.unique();
traning_set2.unique();

C1 = traning_set1.unique_matrix(C1.matrix);
C2 = traning_set2.unique_matrix(C2.matrix);

control_set1 = NMatrix(C1.matrix(randi(C1.n, 170, 1), :));
control_set2 = NMatrix(C2.matrix(randi(C2.n, 170, 1), :));

control_set1.unique();
control_set2.unique();

figure(1)
hold on
scatter(control_set1.matrix(:, 1), control_set1.matrix(:, 2), 'r', 'filled');
scatter(control_set2.matrix(:, 1), control_set2.matrix(:, 2), 'g', 'filled'); 
hold off

toc