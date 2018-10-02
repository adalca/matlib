function Y = logdet(X)
% LOGDET log-determinant of a square matrix.
%   Y = logdet(X) computes the log-determinant of a square matrix X. X can also be a D-by-D-by-K
%   array, in which case K logdets are computed, and Y is K x 1.
%
% See Also: det, cond
%
% contact: adalca at csail

    % input checking w
    narginchk(1, 1);
    [S, S2, K] = size(X);
    assert(S == S2, 'A must be square')

    % compute the determinant
    Y = zeros(K, 1, class(X));
    for i = 1:K
        det = diag(chol(X(:, :, i)))';
        Y(i) = 2*sum(log(det), 2);
    end
end
