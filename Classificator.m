classdef Classificator < handle

    properties
        p;
        h;
    endproperties

    methods (Static = true)
        function Kr = quadratic(r)
            Kr = 15 / 16 * (1 - r.^2) .* (abs(r) <= 1);
        endfunction

        function Kr = triangular(r)
            Kr = (1 - abs(r)) .* (abs(r) <= 1);
        endfunction

        function Kr = gauss(self, r)
            kr = (2 * pi())^(1 / 2) .* exp(-1 / 2 * r.^2);
        endfunction

        function Kr = rectangular(r)
            Kr = 1 / 2 * (abs(r) <= 1);
        endfunction

        function r = dist(X, Y, p)
            r = 0;
            if p < 1
                error("AXIOMS OF METRICS ARE NOT SATISFIED");
            else
                r = sum(abs(X - Y).^p, 2).^(1 / p);
            endif
        endfunction

        function [h, p] = bootstrap(data, n)
            Data_set = Data([data.matrix(randi(data.n, 1, n), :)]);
            Data_test = Data();
            Error = Data();
            E = 0;

            Data_set.unique();
            disp(Data_set.matrix);
        endfunction
    endmethods

    methods
        function self = Classificator(p=2, h=10)
             self.p = p;
             self.h = h;
        endfunction

        function disp(self)
            disp("h = "); disp(self.h);
            disp("p = "); disp(self.p);
        endfunction

        function s = binaryClassification(self, X, Y, x)
            s = 0;
            if ~ismatrix(X) || ~ismatrix(Y)
                error("IS NOT MATRIX");
            endif

            s = self.methodParzenWindow(X, x) > self.methodParzenWindow(Y, x);
        endfunction

        function res = methodParzenWindow(self, X, x)
            res = 0;
            %for i=1:size(X, 1)
            %    res = res + self.triangular(self.dist(X(i, :), x, self.p) / self.h);
            %endfor
            res = sum(self.triangular(self.dist(X, x, self.p) ./ self.h));
        endfunction

        function res = methodKNN(self, X, x)
        
        endfunction
    endmethods
endclassdef
