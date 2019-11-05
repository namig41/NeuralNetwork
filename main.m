clc;
clear all;
close all;

tic
Class1 = NMatrix([randi(100, 500, 1) randi(50, 500, 1)]);
Class2 = NMatrix([randi(100, 500, 1) randi([51, 100], 500, 1)]);

%methodparzena
Class1.unique(true, true);
Class2.unique(true, true);

nn = Classificator(2, 10);

C1 = NMatrix();
C2 = NMatrix();

[X,Y] = meshgrid([1:100], [1:100]);
XY = Class1.unique_matrix([X(:) Y(:)]);
clear X; clear Y; clear ans;

for i=1:XY.n
    row = XY.get_row(i);
    if nn.binaryClassificationParzenWindow(Class1.matrix, Class2.matrix, row)
        C1.add_row(row);
    else
        C2.add_row(row);
    end
end
clear i; clear row;

Class1.add_col(ones([Class1.n 1]));
Class2.add_col(ones([Class2.n 1]) * -1);
E = nn.bootstrap(NMatrix([Class1.matrix; Class2.matrix]), 1000);

figure(1)
hold on;
line([0 100], [51 51], 'color', 'm', 'linewidth', 2);
scatter(Class1.matrix(:, 1), Class1.matrix(:, 2), 'r', 'filled'); 
scatter(Class2.matrix(:, 1), Class2.matrix(:, 2), 'g', 'filled'); 
hold off;

figure(2)
hold on;
scatter(C1.matrix(:, 1), C1.matrix(:, 2), 'r', 'filled'); 
scatter(C2.matrix(:, 1), C2.matrix(:, 2), 'g', 'filled');
hold off;
toc
