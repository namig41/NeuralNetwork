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

        function V = linear(X, i, k)
            V = (k + 1 - i) / k;
        endfunction

        function V = exps(X, i, q)
            V = q**i;
        endfunction

        function r = dist(X, Y, p)
            r = 0;
            if p < 1
                error("AXIOMS OF METRICS ARE NOT SATISFIED");
            else
                r = sum(abs(X - Y).^p, 2).^(1 / p);
            endif
        endfunction

    endmethods

    methods
        function self = Classificator(p=2, h=10)
             self.p = p;
             self.h = h;
        endfunction

        function disp(self)
            printf("h = %d\np = %d\n", self.h, self.p)
        endfunction

        function s = binaryClassificationParzenWindow(self, X, Y, x)
            s = self.methodParzenWindow(X, x) > self.methodParzenWindow(Y, x);
        endfunction

        function s = binaryClassificationKNN(self, X, x, k=1, i)
            X.sort(x, 2, self.p);
            s = X(1:k, self.m-1:self.m-1)' * self.exps(i:i+k);
        endfunction

        function res = methodParzenWindow(self, X, x)
            res = sum(self.triangular(self.dist(X, x, self.p) ./ self.h));
        endfunction

        function oh = bootstrap(self, data, n)
            gloablError = Data();
            for r=1:n
                data_sample= Data([data.matrix(randi(data.n, 1, floor(n * 0.7)), :)]);
                data_control = Data();
                E = intmax('uint64');

                data_sample.unique();
                for i=1:data.n
                    fl=1;
                    for j=1:data_sample.n
                    if data.matrix(i, :) == data_sample.matrix(j, :)
                            fl = 0;
                            break
                        endif
                    endfor
                    if fl
                        data_control.add_row(data.matrix(i, :));
                    endif
                endfor

                for th=2:15
                    tE=0;
                    for i=1:data_control.n
                        if sign((self.triangular(self.dist(data_sample.matrix(:, 1:data_sample.m-1),
                            data_control.matrix(i, 1:data_control.m-1), self.p) ./ th)' .*
                            data_sample.matrix(:, end))) ~= data_control.matrix(i, end)
                            tE += 1;
                        endif
                    endfor
                    if tE == 0
                        oh = th;
                        break
                    elseif E > tE
                        oh = th;
                        E = tE;
                        printf("h=%d E=%d\n", oh, E);
                    endif
                endfor
                gloablError.add_row([r oh]);
                printf("%d. h=%d\n", r, oh);
            endfor
        endfunction

    endmethods
endclassdef
