classdef Classificator < handle
    
    properties
        metrics;
        kernel_function;
        p;
        h;
    endproperties

    methods
        
        function self = Classificator(metrics_p, name_kernel_function, h)
            self.p = metrics_p;
            self.kernel_function = get_kernel_function(name_kernel_function);
            self.h = h;
        endfunction

        function res = methodParzenWindow(self, X, x0, h, metrika, K)
                sumK = 0;
                for i=1:X.n
                  sumK = (sumK + K(metrika(X(i), x0) / self.h) * X(i, 2);
                res = sign(sumK);
        endfunction

        function data_bootstrap = bootstrap(self, data, n)
            data_bootstrap = Data(0)
            for i=1:n
                for j=1:Data_test
                    data_bootstrap.add_row(data.matrix(randi(data.n), :));
                endfor
            endfor
        endfunction
        
        function Kr = get_kernel_function(self, name_kernel_function)
            if name_kernel_function == "quadratic"
                Kr = quadratic;
            elseif name_kernel_function == "triangular"
                Kr = triangular;
            elseif name_kernel_function == "qauss"
                Kr = qauss;
            elseif name_kernel_function == "rectangular"
                Kr = rectangular;
            endif
        endfunction

        function Kr = quadratic(self, r)
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

    endmethods
endclassdef


