clc;
clear all;
close all;
tic

Obj1 = Data([randi(100, 500, 1) randi(50, 500, 1)]);
Obj2 = Data([randi(100, 500, 1) randi([51, 100], 500, 1)]);

%Obj1.unique(change=true);
%Obj2.unique(change=true);

Obj1 = unique(Obj1.matrix, "rows");
Obj2 = unique(Obj2.matrix, "rows");


nn = Classificator();
C1 = [];
C2 = [];
for i=1:5:100
    for j=1:5:100
        tmp = [];
        for k=1:size(Obj1, 1)
            t = nn.dist(Obj1(k, :), [j i]) / nn.h;
            if abs(t) <= 1
                tmp = [tmp; Obj1(k, :)];   
            endif
        endfor
        sum1 = 0;
        sum2 = 0;
        for k=1:size(tmp, 1)
            sum1 = sum1 + nn.methodParzenWindow(tmp, [j i]); 
        endfor
        tmp = [];
        for k=1:size(Obj2, 1)
            t = nn.dist(Obj2(k, :), [j i]) / nn.h;
            if abs(t) <= 1
                tmp = [tmp; Obj2(k, :)];
            endif
        endfor
        for k=1:size(tmp, 1)
            sum2 = sum2 + nn.methodParzenWindow(tmp, [j i]); 
        endfor
        if sum1 > sum2
            C1 = [C1; [j i]]; 
        else
            C2 = [C2; [j i]];
        endif
    endfor
endfor

subplot(1, 2, 1);
hold on;
title("parzen window");
line([0 100], [51 51], "color", "m", "linewidth", 2);
scatter(C1(:, 1), C1(:, 2), "r", "filled"); 
scatter(C2(:, 1), C2(:, 2), "g", "filled");
hold off;

subplot(1, 2, 2);
hold on;
title("parzen window");
line([0 100], [51 51], "color", "m", "linewidth", 2);
scatter(Obj1(:, 1), Obj1(:, 2), "r", "filled"); 
scatter(Obj2(:, 1), Obj2(:, 2), "g", "filled");
hold off;
toc