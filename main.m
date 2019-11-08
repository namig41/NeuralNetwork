clc;
clear all;
close all;

tic
Class1 = NMatrix([randi(100, 500, 1) randi(50, 500, 1)]);
Class2 = NMatrix([randi(100, 500, 1) randi([51, 100], 500, 1)]);

Class1.unique();
Class2.unique();

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
Eb = nn.bootstrap(NMatrix([Class1.matrix; Class2.matrix]), 50, 10);
El = nn.LOO(NMatrix([Class1.matrix; Class2.matrix]), 10);

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

figure(3)
bar(Eb.matrix);
title('Bootstrap');
disp('h'); disp(find(Eb.matrix == min(Eb.matrix)));
xlabel('h');
ylabel('Error');

figure(4)
bar(El.matrix);
title('LOO');
disp('h'); disp(find(El.matrix == min(El.matrix)));
xlabel('h');
ylabel('Error');
toc