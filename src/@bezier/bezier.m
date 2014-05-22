classdef bezier < handle
    % BEZIER A class for ND bezier curves operations
    %   A bezier curve is parametrized by controlPts - which is [N x dim] for N control points of
    %       dimension dim. Note that we use matlab matrix ordering, so the first dimension will be
    %       treated as 'y' in the 2D case.
    %
    %   Current function support: 
    %       - eval: get curve point coordinates given specified point resolution 
    %       - draw: draw the curve into a volume 
    %       - view: display the curve in 2D or 3D.
    %       - test: show a variety of tests and examples on the bezier class.
    % 
    % See Also: eval, draw, view, test
    %
    % TODO: Might extend to bezier surfaces, but for now everything defaults to curve.
    %
    % Author: Adrian V. Dalca, adalca@csail.mit.edu
        
    properties (Constant)
        % constant for now, since only implementation. Everything, including the Static draw()
        % defaults to curves. When/if surfaces (or triangle) will be supported, the Static draw()
        % can still default to curves and drawsurface() could be used for surfaces, or the program
        % can perhaps figure it out from the controlPts.
        type = 'curve';

        % default number of points per voxel to use for nDrawPoints estimate
        pointsPerVoxelDist = 100;
    end
    
    methods (Static)
        
        % draw a bezier curve
        [vol, points, t] = draw(b, varargin);
        
        % eval a bezier curve
        [points, t] = eval(b, varargin);
        
        % view a bezier curve
        vol = view(controlPts, varargin);
        
        % test function
        test(testIDs);
    end
end
