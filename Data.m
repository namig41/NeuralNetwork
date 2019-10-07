classdef Data < handle

  properties
    matrix = 0;
    n = 0;
    m = 0;
  endproperties

  methods
    function self = Data(d)
        if ismatrix(d)
            self.matrix = d;
            self.n = size(d, 1);
            self.m = size(d, 2);
        else
            error("ERROR. is not a matrix");
        endif
    endfunction

    function print(self)
        disp("Data")
        disp(self.matrix)
    endfunction

    function save_on_file(self, path)
        dlmwrite(path, self.matrix, ',');
    endfunction

    function read_file(self, path)
        self.matrix = dlmread(path, ',');
    endfunction

    function self = add_row(self, v)
        if isvector(v) && self.m == size(v, 2)
            self.matrix = cat(1, self.matrix, v);
            self.n = self.n + 1;
        else
            error("ERROR. dont add")
        endif
    endfunction
    
    function sefl = add_col(self, v)
        if isvector(v) && self.n == size(v, 1)
            self.matrix = cat(2, self.matrix, v);
            self.m = self.m + 1;
        else
            error("ERROR. dont add")
        endif
    endfunction

    function U = unique(self)
        flag = 1;
        U = Data(self.matrix(1, :));
        for i=2:self.n
            for j=1:U.n
                if U.matrix(j, :) == self.matrix(i, :)
                    flag = 0;
                    break
                endif
            endfor
            if flag
                U.add_row(self.matrix(i, :));
            else
                flag = 1;
            endif
        endfor
    endfunction

  endmethods
endclassdef
