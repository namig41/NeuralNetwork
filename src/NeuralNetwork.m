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
        
        function globalError = search_optimalNN(train_set, train_control, lr)
            MAX_INODES = 2;            
            MAX_HNODES = 4;
            MAX_ONODES = 1;
            globalError = cell(MAX_HNODES, 2);
            iteratorError = 1;
            
            for hnodes=1:MAX_HNODES
                nn_setting.inodes = MAX_INODES;
                nn_setting.hnodes = hnodes;
                nn_setting.onodes = MAX_ONODES;
                nn_setting.lr = lr;

                NN = NeuralNetwork(nn_setting);
                NN.trainW(train_set, 3e2, 1e-2, 'backpropagation');

                globalError{iteratorError, 1} = 0;
                globalError{iteratorError, 2} = nn_setting;
                for i=1:size(train_control, 1)
                    globalError{iteratorError, 1} = globalError{iteratorError, 1} +...
                                                    (NN.query(train_control(i, [1, 2])) >= 0.5 ~= train_control(i, end));
                end
                iteratorError = iteratorError + 1;
            end            
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
        
        function [error, outputs_data, outputs_errors, prev_gradient] = DBD(self, inputs_data, targets_data, index)
            inputs_data = [inputs_data; -1];
            if index < self.setting.nnodes.m
                [error, outputs_data, outputs_errors, prev_gradient] = self.backpropagation(self.af_sigmoid(self.W{index} * inputs_data), targets_data, index + 1);
                gradient = (outputs_errors .* (1 - outputs_data) .* outputs_data * inputs_data');
                self.setting.lr = self.setting.lr + sign(gradient * prev_gradient) * 1e-2;
                self.W{index} = self.W{index} - self.setting.lr * gradient;
                outputs_errors = self.W{index}(:, 1:end - 1)' * (outputs_errors .* (1 - outputs_data) .* outputs_data);
            else
                outputs_errors = inputs_data(end - 1, :) - targets_data;
                error = sum(outputs_errors.^2);
                gradient = 0;
            end
            outputs_data = inputs_data(end - 1, :);
            prev_gradient = gradient;
        end
        
        function trainW(self, inputs_data, iteration_count, eps, method)
            for i=1:iteration_count
                Q = 0;
                Qi = inf;
                rx = inputs_data(randi(size(inputs_data, 1), 1), :);
                while abs(Q - Qi) > eps
                    switch method
                        case 'backpropagation'
                            Qi = self.backpropagation(rx(:, [1 2])', rx(:, end), 1);
                        case 'DBD'
                             Qi = self.backpropagation(rx(:, [1 2])', rx(:, end), 1);
                    end
                    Q = (1 - 1e-3)* Q + 1e-3 * Qi;
                end
            end
        end
        
        function [time, iteration_count] = train(self, inputs_data, eps, method)
            tic
            iteration_count = zeros(1, size(inputs_data, 1));
            for i=1:size(inputs_data, 1)
                Q = 0;
                Qi = inf;
                rx = inputs_data(randi(size(inputs_data, 1), 1), :);
                while abs(Q - Qi) > eps
                    switch method
                        case 'backpropagation'
                            Qi = self.backpropagation(rx(:, [1 2])', rx(:, end), 1);
                        case 'DBD'
                             Qi = self.backpropagation(rx(:, [1 2])', rx(:, end), 1);
                    end
                    Q = (1 - 1e-3)* Q + 1e-3 * Qi;
                    iteration_count(i) = iteration_count(i) + 1;
                end
            end
            time = toc;
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
                if self.query(data(i, :)) >= 0.5;
                    C1.add_row(data(i, :));
                else
                    C2.add_row(data(i, :));
                end
            end
        end
    end
end
