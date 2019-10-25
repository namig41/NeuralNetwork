clc;
clear all;
close all;

tic
Class1 = Data([randi(100, 500, 1) randi(50, 500, 1)]);
Class2 = Data([randi(100, 500, 1) randi([51, 100], 500, 1)]);

%methodparzena
Class1.unique();
Class2.unique();

nn = Classificator();

C1 = Data();
C2 = Data();

for i=1:100
    for j=1:100
        if nn.binaryClassificationParzenWindow(Class1.matrix, Class2.matrix, [j i])
            C1.add_row([j i]);
        else
            C2.add_row([j i]);
        endif
    endfor
endfor

Class1.add_col(ones([Class1.n 1]));
Class2.add_col(ones([Class2.n 1]) * -1);
a = Data([Class1.matrix; Class2.matrix]);
nn.bootstrap(a, 950)

%methodKNN
%Class1.unique();
%Class2.unique();
%
%Class1.add_col(ones([Class1.n 1]))
%Class2.add_col(ones([Class2.n 1]) * -1)
%Class = Data([Class1.matrix; Class2.matrix]);
%
%nn = Classificator();
%
%C1 = Data();
%C2 = Data();
%
%for i=1:10:100
%    for j=1:10:100
%        if nn.binaryClassificationKNN(Class.matrix, 2, i) > 0;
%            C1.add_col([j i]);
%        else
%            C2.add_col([j i]);
%        endif
%    endfor
%endfor
%
%a = Data([Class1.matrix; Class2.matrix]);

figure(1)
%subplot(1, 2, 1);
hold on;
line([0 100], [51 51], "color", "m", "linewidth", 2);
scatter(Class1.matrix(:, 1), Class1.matrix(:, 2), "r", "filled"); 
scatter(Class2.matrix(:, 1), Class2.matrix(:, 2), "g", "filled"); 
hold off;

figure(2)
%subplot(1, 2, 2);
hold on;
title("PARZEN WINDOW");
scatter(C1.matrix(:, 1), C1.matrix(:, 2), "r", "filled"); 
scatter(C2.matrix(:, 1), C2.matrix(:, 2), "g", "filled");
hold off;
toc
