function subCell = subMat2cell(locVec)
    subCell = mat2cell(locVec, size(locVec, 1), ones(1, size(locVec, 2)));