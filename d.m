function r = d(X, Y, p)
    r = 0;

    if X.n ~ Y.n
        error("SIZE ERROR");
    elseif p < 1
        error("METRIK ERROR");
    else
        for i=1:X.n
            r = r + (X(i, :) - Y(i, :))**p;

        r = r**(1 \ p);
    endif
endfunction
