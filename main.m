clc;
clear all;
close all;

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
% [X,Y] = meshgrid([1:100], [1:100]);
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
% Eb = nn.bootstrap(NMatrix([Class1.matrix; Class2.matrix]), 50, 10);
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
% bar(Eb.matrix);
% title('Bootstrap');
% disp('h'); disp(find(Eb.matrix == min(Eb.matrix)));
% xlabel('h');
% ylabel('Error');
% 
% figure(4)
% bar(El.matrix);
% title('LOO');
% disp('h'); disp(find(El.matrix == min(El.matrix)));
% xlabel('h');
% ylabel('Error');
% toc

% LAB 2
k = randi([5 50]) / 10;
b = 1;

[X,Y] = meshgrid(1:100, 1:100);
XY = [X(:) Y(:)];

C1 = NMatrix(XY(find(k*X(:) + b > Y(:)), :));
C2 = NMatrix(XY(find(k*X(:) + b < Y(:)), :));

C = NMatrix([[C1.matrix(randi(C1.n, 500, 1), :) ones(500, 1)];
             [C2.matrix(randi(C2.n, 500, 1), :) zeros(500, 1)]]);
C.unique();
El = Classificator.LOO_RF(C, 3);
Nopt = min(El.matrix);

RF = 1:Nopt;
for i=1:Nopt
    sample = C.matrix(randi(C.n, C.n, 1), :);
    RF(i) = treefit(sample(:, [1 2]), sample(:, end));
end

XY = C1.unique_matrix(XY);
XY = C2.unique_matrix(XY);

T1 = NMatrix();
T2 = NMatrix();

for i=1:XY.n
    s = 0;
    for j=1:Nopt
        s = s + treeval(RF(j), XY.matrix(i, [1, 2]));
    end
    if round(s / Nopt)
        T1.add_row(XY(i, :));
    else
        T2.add_row(XY(i, :));
    end
end

figure(1)
hold on
scatter(C1.matrix(:, 1), C1.matrix(:, 2), 'r', 'filled'); 
scatter(C2.matrix(:, 1), C2.matrix(:, 2), 'g', 'filled'); 
hold off

figure(2)
hold on
scatter(T1.matrix(:, 1), T1.matrix(:, 2), 'r', 'filled'); 
scatter(T2.matrix(:, 1), T2.matrix(:, 2), 'g', 'filled'); 
hold off

figure(3)
bar(El.matrix);
title('LOO');
xlabel('N');
ylabel('Error');





