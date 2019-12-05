classdef NeuralNetwork < handle
    
    properties
        setting
    end
    
    properties (Access = private)
        W
    end
    
    methods (Static = true)
        % activation function
        
        function Y = af_sigmoid(X)
            Y = 1 ./ (1 + exp(-X));
        end
        
        function Y = af_ReLu(X)
            Y = X > 0;
            Y = Y.*X;
        end
        
        function Y = af_tanh(X)
            Y = 2 * sigmoid(2 * X) - 1;
        end
        
        function Y = af_log(X)
            Y = log(X + sqrt(X.^2 + 1));
        end
        
        function Y = af_exp(X)
            Y = expt(-X.^2 ./ 2);
        end
    end
    
    methods (Static = true)
        % normalization
        
        function nX = n_min_max(X)
            nX = (X - min(X)) ./ (max(X) - min(X));
        end
        
        function nX = n_mean(X)
            nX = (X - mean(X)) ./ std(X);
        end
    end
    
    methods

        function self = NeuralNetwork(nn_setting)
            self.setting = nn_setting;
            self.setting.nnodes = NMatrix([nn_setting.inodes, nn_setting.hnodes, nn_setting.onodes]);
            self.createNeuralNetwork();
        end
        
        function createNeuralNetwork(self)
            self.W = cell(1, self.setting.nnodes.m - 1);
            self.initW();
        end
        
        function initW(self)
            for i=1:self.setting.nnodes.m - 1
                self.W{i} = randi([-150 150], [self.setting.nnodes.matrix(i + 1), self.setting.nnodes.matrix(i) + 1]) ./ 1e5;
            end
        end
        
        function [error, outputs_data, outputs_errors] = backpropagation(self, inputs_data, targets_data, index)
            inputs_data = [inputs_data; -1];
            if index < self.setting.nnodes.m
                [error, outputs_data, outputs_errors] = self.backpropagation(self.af_sigmoid(self.W{index} * inputs_data), targets_data, index + 1);
                self.W{index} = self.W{index} - self.setting.lr * (outputs_errors .* (1 - outputs_data) .* outputs_data * inputs_data');
                outputs_errors = self.W{index}(:, 1:end - 1)' * (outputs_errors .* (1 - outputs_data) .* outputs_data);
            else
                outputs_errors = inputs_data(end - 1, :) - targets_data;
                error = sum(outputs_errors.^2);
            end
            outputs_data = inputs_data(end - 1, :);
        end
        
        function train(self, inputs_data, epochs)
            for e=1:epochs
                Q = 0;
                Qi = inf;
                rx = inputs_data(randi(size(inputs_data, 1), 1), :);
                while abs(Q - Qi) > 1e-2
                    Qi = self.backpropagation(rx(:, [1 2])', rx(:, end), 1);
                    Q = (1 - 1e-3)* Q + 1e-3 * Qi;
                end
            end
        end
        
        function nn_setting = search_optimalNN(self, train_set, train_control, lr)
            % initial setting
            globalError = zeros(1, 9);
            
            for i=1
            end
            
        end
        
        function outputs_data = query(self, inputs_data)
            outputs_data = inputs_data';
            for i=1:length(self.W)
                outputs_data = self.af_sigmoid(self.W{i} * [outputs_data; -1]);
            end
        end
        
        function [C1, C2] = classification(self, data)
            C1 = NMatrix();
            C2 = NMatrix();
            for i=1:size(data, 1)
                if self.query(data(i, :)) >= 1e-2;
                    C1.add_row(data(i, :));
                else
                    C2.add_row(data(i, :));
                end
            end
        end
    end
end