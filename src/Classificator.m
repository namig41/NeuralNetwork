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

        function [analysisError, h] = bootstrap(self, data, n, h_range)
            globalError = NMatrix(ones(n, h_range)*inf);
            analysisError = NMatrix(zeros(2, h_range));
            for r=1:n
                data_sample = NMatrix(data.matrix(randi(data.n, data.n, 1), :));
                data_sample.unique();
                data_control = data_sample.unique_matrix(data.matrix);
                for th=1:h_range
                    tE=0;
                    for i=1:data_control.n
                        if sign(self.triangular(self.dist(data_sample.matrix(:, 1:data_sample.m-1),...
                            data_control.matrix(i, 1:data_control.m-1), self.p) ./ th)' * data_sample.matrix(:, end)) ~=...
                            data_control.matrix(i, end)
                            tE = tE + 1;
                        end
                    end
                    globalError.matrix(r, th) = min(globalError.matrix(th), tE);
                end
            end
            for i=1:analysisError.m
                analysisError.matrix(1, i) = mean(globalError.matrix(:, i));
                analysisError.matrix(2, i) = std(globalError.matrix(:, i));
            end
            mean_min = inf;
            h = 1;
            while 1
               for i=h:analysisError.m
                    if mean_min > analysisError.matrix(1, i)
                        h = i;
                        mean_min = analysisError.matrix(1, i);
                    else break;
                    end
               end
               if h == find(analysisError.matrix(2, h) == min(analysisError.matrix(2, h), 1, 'first'))
                   break;
               end
            end
        end
        
        function globalError = LOO(self, data, h_range)
            globalError = NMatrix(ones(1, h_range)*inf);
            tmp = NMatrix(data.matrix);
            for th=1:h_range
                tE = 0;
                for i=1:tmp.n - 1
                    data.matrix(i, :) = 0;
                    if sign(self.triangular(self.dist(data.matrix(:, 1:data.m-1),...
                            tmp.matrix(i, 1:data.m-1), self.p) ./ th)' * data.matrix(:, end)) ~=...
                            tmp.matrix(i, end)
                      tE = tE + 1;
                    end
                    data.matrix = tmp.matrix;
                end
                globalError.matrix(th) = min(globalError.matrix(th), tE); 
            end
        end
    end
end
