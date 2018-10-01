function vecs = ends2vec(ends, centers, limits)
% ENDS2VEC
%   vec = ends2vec(ends) ends is [1x2] equiv to vec = ends(1):ends(2)
%   vec = ends2vec(ends, center) equiv to vec = center + (ends(1):ends(2));
%   
%   vecs = ends2vec(ends) ends is Nx2, vecs is a Nx1 cell array
%   vecs = ends2vec(ends, centers) ends is Nx2, centers is Nx1, vecs is a Nx1 cell array. Could also
%       have ends be 1x2 even if centers is Nx1, then those ends will repeat for each center
%
%   vecs = ends2vec(ends, centers, limits) allows you to specify limits of the vectors. parts of
%       vectors outside of these limits will be cropped out. limits can be 1x2 or Nx2 (if the
%       latter, those limits will be applied to all N vectors). limits are inclusive (i.e. nr in
%       limits is kept in vec)
%
% Contact: adalca@csail.mit.edu

    nVecs = size(ends, 1);
    
    if nargin == 1
        centers = zeros(nVecs, 1);
    else
        if nVecs == 1 && size(centers, 1) > 1
            nVecs = size(centers, 1);
            ends = repmat(ends, [nVecs, 1]);
        end
    end
    
    
    if nargin == 3 && size(limits, 1) == 1 && nVecs > 1
        limits = repmat(limits, [nVecs, 1]);
    end
    
    if nargin < 3
        limits = repmat([min(ends(:)), max(ends(:))], [nVecs, 1]);
    end
    
    % populate vectors
    vecs = cell(nVecs, 1);
    for i = 1:nVecs
         vec = centers(i) + (ends(i, 1):ends(i, 2));
         vec(vec > limits(i, 2)) = [];
         vec(vec < limits(i, 1)) = [];
         vecs{i} = vec;
    end
    if nVecs == 1
        vecs = vecs{1};
    end
