function am = amParallel()
    am = matlabpool('size') == 0;