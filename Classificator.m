classdef Classificator < handle

    properties
        p;
        h;
    endproperties

    methods
        function Kr = quadratic(sefl, r)
            Kr = 15 / 16 * (1 - r**2) * (abs(r) <= 1);
        endfunction

        function Kr = triangular(self, r)
            Kr = (1 - abs(r)) * (abs(r) <= 1);
        endfunction

        function Kr = gauss(self, r)
            kr = 2 * pi;
        endfunction

        function Kr = rectangular(self, r)
            Kr = 1 / 2 * (abs(r) <= 1);
        endfunction

        function r = dist(self, X, Y)
            r = 0;
            if self.p < 1
                error("METRICS ERROR");
            else
                for i=1:size(X, 2)
                    r = r + (X(i) - Y(i))^self.p;
                endfor
                r = r^(1 / self.p);
            endif
        endfunction

        function data_bootstrap = bootstrap(self, data, n)
            data_bootstrap = Data()
            for i=1:n
                for j=1:data.n
                    data_bootstrap.add_row(data.matrix(randi(data.n), :));
                endfor
            endfor
        endfunction
    endmethods

    methods
        function self = Classificator(p=2, h=20)
             self.p = p;
             self.h = h;
        endfunction

        function disp(self)
            disp("h = "); disp(self.h);
            disp("p = "); disp(self.p);
        endfunction

        function res = methodParzenWindow(self, X, x0)
            res = 0;
            for i=1:size(X, 1)
                res = res + self.quadratic(self.dist(X(i, :), x0) / self.h);
            endfor
        endfunction

        function res = methodKNN(self, X, x0)
        
        endfunction
    endmethods
endclassdef