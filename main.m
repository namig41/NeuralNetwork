clc;
clear all;
close all;


Obj1 = Data([randi(100, 500, 1) randi(50, 500, 1)]);
Obj2 = Data([randi(100, 500, 1) randi([51, 100], 500, 1)]);

Obj1.unique();
Obj2.unique();

hold on;
title("Parzen Window");
x = 0:0.1:100;
plot(x, 51);
scatter(Obj1.matrix(:, 1), Obj1.matrix(:, 2), "r", "filled"); 
scatter(Obj2.matrix(:, 1), Obj2.matrix(:, 2), "g", "filled");
hold off;


x = Data([0; 0]);

for i=1:50
    for j=1:100
        x.add_col([i; j]);
    endfor
endfor

disp(x.matrix);
