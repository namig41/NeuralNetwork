classdef RandomForest < handle 
    
    properties
        Nopt
        RF
    end
    
    methods (Static = true)        
        function globalError = LOO_RF(data, N)
            globalError = NMatrix(zeros(1, N));
            for i=1:data.n
                tmp = data.matrix;
                tmp(i, :) = [];
                s = 0;
                for j=1:N
                    sample = tmp(randi(data.n - 1, data.n - 1, 1), :);
                    tree = treefit(sample(:, [1, 2]), sample(:, end));
                    s = s + treeval(tree, data.matrix(i, [1, 2]));
                    globalError.matrix(j) = globalError.matrix(j) + ~(round(s / j) == data.matrix(i, end));
                end
            end
        end

%         function globalError = LOO_RF(data, N)
%             globalError = NMatrix(zeros(1, N));
%             for tN=1:N
%                 for i=1:data.n
%                     s = 0;
%                     tmp = data.matrix;
%                     tmp(i, :) = [];
%                     for j=1:tN
%                         sample = tmp(randi(data.n - 1, data.n - 1, 1), :);
%                         tree = treefit(sample(:, [1 2]), sample(:, end));
%                         s = s + treeval(tree, data.matrix(i, [1, 2]));
%                     end
%                     globalError.matrix(tN) = globalError.matrix(tN) + ~(round(s / tN) == data.matrix(i, end));
%                 end
%             end
%         end        
    end
    
    methods
        function self = RandomForest(N)
            self.Nopt = N;
        end
        
        function createRF(self, data)
            self.RF = cell(self.Nopt);

            for j=1:self.Nopt
                sample = data.matrix(randi(data.n, data.n, 1), :);
                self.RF{j} = treefit(sample(:, [1 2]), sample(:, end));
            end            
        end
        
        function [C1, C2] = classification(self, data)
            C1 = NMatrix();
            C2 = NMatrix();
            for i=1:size(data, 1)
                s = 0;
                for j=1:self.Nopt
                    s = s + treeval(self.RF{j}, data(i, :));
                end
                if round(s / self.Nopt)
                    C1.add_row(data(i, :));
                else
                    C2.add_row(data(i, :));
                end
            end 
        end
    end 
end

