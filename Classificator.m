classdef Classificator < handle

    properties
        p;
        h;
    end

    methods (Static = true)
        function Kr = quadratic(r)
            Kr = 15 / 16 * (1 - r.^2) .* (abs(r) <= 1);
        end

        function Kr = triangular(r)
            Kr = (1 - abs(r)) .* (abs(r) <= 1);
        end

        function Kr = gauss(r)
            Kr = (2 * pi())^(1 / 2) .* exp(-1 / 2 * r.^2);
        end

        function Kr = rectangular(r)
            Kr = 1 / 2 * (abs(r) <= 1);
        end

        function V = linear(i, k)
            V = (k + 1 - i) / k;
        end

        function V = exps(i, q)
            V = q^i;
        end

        function r = dist(X, Y, p)
            if p < 1
                error('AXIOMS OF METRICS ARE NOT SATISFIED');
            else
                r = sum(abs(bsxfun(@(x,y) x - y, X, Y)).^p, 2).^(1 / p);
            end
        end

    end

    methods
        function self = Classificator(p, h)
            if nargin < 1
                self.h = 10;
                self.p = 2;
            elseif nargin < 2
                self.h = 1;
            else 
                self.p = p;
                self.h = h;
            end
        end

        function disp(self)
            printf('h = %d\np = %d\n', self.h, self.p)
        end

        function s = binaryClassificationParzenWindow(self, X, Y, x)
            s = self.methodParzenWindow(X, x) > self.methodParzenWindow(Y, x);
        end

        function s = binaryClassificationKNN(self, X, x, k, i)
            X.sort(x, 2, self.p);
            s = X(1:k, self.m-1:self.m-1)' * self.exps(i:i+k);
        end

        function res = methodParzenWindow(self, X, x)
            res = sum(self.triangular(self.dist(X, x, self.p) ./ self.h));
        end

        function [globalError, oh] = bootstrap(self, data, n)
            globalError = NMatrix(ones(1, 15)*inf);
            for r=1:n
                data_sample = NMatrix(data.matrix(randi(floor(n * 0.7), n, 1), :));
                data_sample.unique(true, true);
                data_control = data_sample.unique_matrix(data.matrix);
                E = inf;

                for th=1:15
                    tE=0;
                    for i=1:data_control.n
                        if sign(self.triangular(self.dist(data_sample.matrix(:, 1:data_sample.m-1),...
                            data_control.matrix(i, 1:data_control.m-1), self.p) ./ th)' * data_sample.matrix(:, end)) ~=...
                            data_control.matrix(i, end)
                            tE = tE + 1;
                        end
                    end
                    
                    if tE == 0
                        oh = th;
                        break
                    elseif E > tE
                        oh = th;
                        E = tE;
                    end
                end
            end
        end
        
        function globalError = LOO(self, data)
            
        end

    end
end
