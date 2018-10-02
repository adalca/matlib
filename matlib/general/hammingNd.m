function window = hammingNd(sz)
% HAMMINDND N-dimensional hammind window
%   window = hammingNd(sz) returns a N-dimensional hamming window. sz is a 1xN vector. window will
%   be N-dimensional of size sz.
%
% Contact: {adalca,klbouman}@csail.mit.edu

    if numel(sz) == 1
        window = hammind(sz);
        
    else
        window = ones(sz);
        o = ones(1, length(sz));
        % TODO - should be able to do this by simple tensor multiplication?
        for d = 1:numel(sz)
            % get hamming window in this dimension
            dimWindow = hamming(sz(d));

            % reshape it to be in current dimension
            elemVec = o;
            elemVec(d) = sz(d);
            wr = reshape(dimWindow, elemVec);

            % repmat in the other dimensions
            repVec = sz;
            repVec(d) = 1;
            wrr = repmat(wr, repVec);

            % multiply to get window so far
            window = window .* wrr;
        end
    end