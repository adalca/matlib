function vec = modifyVector(vec, entry, val)
    vec(entry) = val;
    
% useful to combine lines like:
% >> vec1 = vec;
% >> vec1(3) = 7;
% into:
% >> vec1 = modifyVector(vec, 3, 7);