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
        
        function nX = n_min(X)
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
            
            for i=1:self.setting.nnodes.m - 1
                self.W{i} = normrnd(0, sqrt(self.setting.nnodes.matrix(i + 1)),...
                                    [self.setting.nnodes.matrix(i + 1), self.setting.nnodes.matrix(i)]);
            end
        end
        
        function [outputs_data, outputs_errors] = backpropagation(self, inputs_data, targets_data, index)
            if index < self.setting.nnodes.m
                [outputs_data, outputs_errors] = self.backpropagation(self.af_sigmoid(self.W{index} * inputs_data), targets_data, index + 1);
                self.W{index} = self.W{index} + self.setting.lr * (outputs_errors .* outputs_data .* (1 - outputs_data) * inputs_data');
                outputs_errors = self.W{index}' * outputs_errors;
            else
                outputs_errors = inputs_data - targets_data;
            end
            outputs_data = inputs_data;
       end
        
        function train(self, inputs_data, epochs)
            for e=1:epochs
                for i=1:size(inputs_data, 1)
                    self.backpropagation(inputs_data(i, [1 2])', inputs_data(i, end), 1);
                end
            end
        end
        
        function outputs_data = query(self, inputs_data)
            outputs_data = inputs_data';
            for i=1:length(self.W)
                outputs_data = self.af_sigmoid(self.W{i} * outputs_data);
             end
        end
    end
    
end