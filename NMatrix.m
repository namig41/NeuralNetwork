classdef NMatrix < handle

  properties
    matrix = 0;
    n = 0;
    m = 0;
  end

  methods
    function self = NMatrix(d)
        if nargin < 1
            self.matrix = [];
        else
            self.matrix = d;
        end
        self.update_size();
    end

    function save_on_file(self, path)
        dlmwrite(path, self.matrix, ',');
    end

    function read_file(self, path)
        self.matrix = dlmread(path, ',');
    end

    function add_row(self, v)
        self.matrix = [self.matrix; v];
        self.update_size();
    end
    
    function add_col(self, v)
        self.matrix = [self.matrix, v];
        self.update_size();
    end
    
    function pop_front(self)
        self.matrix(0) = [];
        self.update_size();
    end
    
    function pop_back(self)
        self.matrix(end) = [];
        self.update_size();
    end
    
    function pop_index(self, index)
        if nargin < 2
            index = 1;
        end
        self.matrix(index, :) = [];
        self.update_size();
    end
    
    function update_size(self)
        self.m = size(self.matrix, 2);
        self.n = size(self.matrix, 1);
    end
    
    function s = get_size(self)
        s = size(self.matrix);
    end

    function sort(self, value, p)
         for i=1:self.n
            for j=i+1:self.n-1
                if norm(self.matrix(i, 1:self.m-1)-value, p) > norm(self.matrix(j, 1:self.m-1)-value, p)
                    tmp = self.matrix(i, :);
                    self.matrix(i, :) = self.matrix(j, :);
                    self.matrix(j, :) = tmp;
                end
            end
        end
    end
    
    function L = get_row(self, l)
        if isnumeric(l) && (l > self.n || l <= 0)
            error('ERROR. INDEX OUT OF RANGE');
        else
            L = self.matrix(l, :);
        end
    end
    
    function L = get_col(self, l)
        if isnumeric(l) && (l > self.n || l <= 0)
            error('ERROR. INDEX OUT OF RANGE');
        else
            L = self.matrix(:, l);
        end
    end
    
    function U = unique_matrix(self, XY)
        U = NMatrix();
        XY = NMatrix(XY);
        
        for i=1:XY.n
            flag = 1;
            for j=1:self.n
                if XY.matrix(i, :) == self.matrix(j, :)
                    flag = 0;
                    break 
                end
            end
            if flag
                U.add_row(XY.matrix(i, :));
            end
        end
    end

    function U = unique(self, ch, mf)
        if nargin < 3
            mf = true;
        end
        if nargin < 2 
            mf = true;
            ch = true;
        end
        if mf
            U = NMatrix(self.matrix(1, :));
            for i=2:self.n
                flag = 1;
                for j=1:U.n
                    if U.matrix(j, :) == self.matrix(i, :)
                        flag = 0;
                        break
                    end
                end
                if flag
                    U.add_row(self.matrix(i, :));
                end
            end
            if ch
                self.matrix = U.matrix;
                self.update_size();
            end
        else
           unique(self.matrix, 'rows');
        end
    end
  end
end
