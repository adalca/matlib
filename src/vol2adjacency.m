function A = vol2adjacency(volSize, connectivity)
% A = vol2adjacency([10, 10], 8);
% [x, y] = ndgrid(1:10, 1:10);
% gplot(A, [x(:), y(:)]);


    nNodes = prod(volSize);
    B = ones(nNodes, connectivity);
    
    
    
    switch connectivity
        case 26
            [ii, jj, kk] = ndgrid(-1:1, -1:1, -1:1);
            r = repmat(volSize(:)', [27, 1]);
            
            % get sizes
            s1 = volSize(1);
            s2 = volSize(2);
            s3 = volSize(3);
              
            % bottom neighbor
            del = 1;
            % right neighbours
            del = [del, s1-1:s1+1];
            % next plane neighbors
            del = [del, (s1*s2-s1) + (-1:1), (s1*s2) + (-1:1), (s1*s2+s1) + (-1:1)];
            % opposite neighbors
            del = [del, -del];
            A = spdiags(B, del, nNodes, nNodes); % look up how to do properly.

            % TODO - this has a problem with numbering :(
            
            % get all edge pixels
            [x1, y1, z1] = ndgrid(1, 1:s2, 1:s3);
            [x2, y2, z2] = ndgrid(s1, 1:s2, 1:s3);
            [x3, y3, z3] = ndgrid(1:s1, 1, 1:s3);
            [x4, y4, z4] = ndgrid(1:s1, s2, 1:s3);
            [x5, y5, z5] = ndgrid(1:s1, 1:s2, 1);
            [x6, y6, z6] = ndgrid(1:s1, 1:s2, s3);
            x = [x1(:);x2(:);x3(:);x4(:);x5(:);x6(:)];
            y = [y1(:);y2(:);y3(:);y4(:);y5(:);y6(:)];
            z = [z1(:);z2(:);z3(:);z4(:);z5(:);z6(:)]; 
            idx = sub2ind(volSize, x, y, z);
            
            % second method - very slow!
            A(idx, :) = 0;
            A(:, idx) = 0;
            for i = 1:numel(idx);        
                % get the 26 neighbours
                
                % exclude negative of volSize exclude
                newsub = [x(i) + ii(:), y(i) + jj(:), z(i) + kk(:)];
                bad = sum(newsub <= 0, 2) > 0 | sum(newsub > r, 2) > 0;
                bad(14) = true;

                %%%%        
                f = find(~bad);
                f = sub2ind(volSize, newsub(f, 1), newsub(f, 2), newsub(f, 3));
                
                A(idx(i), f) = 1;
                A(f, idx(i)) = 1;
            end
            
        case 8
            [ii, jj] = ndgrid(-1:1, -1:1);
            r = repmat(volSize(:)', [9, 1]);
            
            % get sizes
            s1 = volSize(1);
            s2 = volSize(2);
              
            % bottom neighbor
            del = 1;
            % right neighbours
            del = [del, s1-1:s1+1];
            % opposite neighbors
            del = [del, -del];
            A = spdiags(B, del, nNodes, nNodes); % look up how to do properly.

            % TODO - this has a problem with numbering :(
            
            % get all edge pixels
            [x1, y1] = ndgrid(1, 1:s2);
            [x2, y2] = ndgrid(s1, 1:s2);
            [x3, y3] = ndgrid(1:s1, 1);
            [x4, y4] = ndgrid(1:s1, s2);
            x = [x1(:);x2(:);x3(:);x4(:)];
            y = [y1(:);y2(:);y3(:);y4(:)];
            idx = sub2ind(volSize, x, y);
            
            % second method - very slow!
            A(idx, :) = 0;
            A(:, idx) = 0;
            for i = 1:numel(idx);        
                % get the 8 neighbours
                
                % exclude negative of volSize exclude
                newsub = [x(i) + ii(:), y(i) + jj(:)];
                bad = sum(newsub <= 0, 2) > 0 | sum(newsub > r, 2) > 0;
                bad(5) = true;

                %%%%        
                f = find(~bad);
                f = sub2ind(volSize, newsub(f, 1), newsub(f, 2));
                
                A(idx(i), f) = 1;
                A(f, idx(i)) = 1;
            end

        case 4
            % from UGM's getNoisyX
            adj = sparse(nNodes,nNodes);
            nRows = volSize(1);
            nCols = volSize(2);

            % Add Down Edges
            ind = 1:nNodes;
            exclude = sub2ind([nRows nCols],repmat(nRows,[1 nCols]),1:nCols); % No Down edge for last row
            ind = setdiff(ind,exclude);
            adj(sub2ind([nNodes nNodes],ind,ind+1)) = 1;

            % Add Right Edges
            ind = 1:nNodes;
            exclude = sub2ind([nRows nCols],1:nRows,repmat(nCols,[1 nRows])); % No right edge for last column
            ind = setdiff(ind,exclude);
            adj(sub2ind([nNodes nNodes],ind,ind+nRows)) = 1;

            % Add Up/Left Edges
            adj = adj+adj';
            A = adj;
            
        otherwise
            error('connectivity not implemented');
    end



end