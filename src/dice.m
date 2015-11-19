function d = dice(v1, v2, labels)
    if nargin < 3
        labels = 'all';
    end

    if ischar(labels)
        assert(strcmp(labels, 'all'));
        q = unique([v1(:); v2(:)]);
        d = dice(v1, v2, q);
    else
        for i = 1:numel(labels)
            label = labels(i);
            num = v1(:) == v2(:) & v1(:) == label & v2(:) == label;
            d(i) = 2 * sum(num) ./ (sum(v1(:) == label) + sum(v2(:) == label));
        end
    end
    