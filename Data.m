classdef Data < handle

  properties
    matrix = 0;
    n = 0;
    m = 0;
  endproperties

  methods
    function self = Data(d=[])
        if ismatrix(d)
            self.matrix = d;
            self.update_size();
        else
            error("ERROR. is not a matrix");
        endif
    endfunction

    function print(self)
        disp("Data"); disp(self.matrix);
    endfunction

    function save_on_file(self, path)
        dlmwrite(path, self.matrix, ',');
    endfunction

    function read_file(self, path)
        self.matrix = dlmread(path, ',');
    endfunction

    function add_row(self, v)
        self.matrix = [self.matrix; v];
        self.update_size();
    endfunction
    
    function add_col(self, v)
        self.matrix = [self.matrix, v];
        self.update_size();
    endfunction

    function update_size(self)
        self.m = size(self.matrix, 2);
        self.n = size(self.matrix, 1);
    endfunction

    function sort(self, value=0, p=2)
         i = 0;
         j = 0;

         for i=1:self.n
            for j=i+1:self.n-1
                if norm(self.matrix(i, 1:self.m-1)-value, p) > norm(self.matrix(j, 1:self.m-1)-value, p)
                    tmp = self.matrix(i, :);
                    self.matrix(i, :) = self.matrix(j, :);
                    self.matrix(j, :) = tmp;
                endif
            endfor
        endfor
    endfunction

    function U = unique(self, ch=false, mf=false)
        if mf 
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
            if ch
                self.matrix = U.matrix;
            endif
        else
           unique(self.matrix, "rows");
        endif
    endfunction
  endmethods
endclassdef
