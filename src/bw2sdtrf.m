function dst = bw2sdtrf(bwimg, sc)
% BW2SDTRF compute a signed distance transform 
%   dst = bw2sdtrf(bwimg) computes the signed distance transform from the surface between the
%   binary elements of logical bwimg, which can be of any dimentions that bwdist accepts. 
%   By default, the distance computation assumes isotropic voxels. 
%
%   dst = bw2sdtrf(bwimg, voxSize). allows for specification of non-isotropic voxel size. In this
%   case, bwdistsc (by Yuriy Mishchenko - see MATLAB Central File Exchange) will be used instead of 
%   bwdist. 
%
%   Note: the distance transform on either side of the surface will be +1/-1 (or whatever ths 
%   size is) - i.e. there are no voxels for which the dst should be 0.
%   
%   Runtime: currently the function uses bwdist/bwdistsc twice. If there is a quick way to 
%   compute the surface, bwdist could be used only once.
%
%   See Also: bwdist, bwdistsc
%
% Contact: Adrian Dalca, http://adalca.mit.edu


    % assumption: 1. voxels are isotropic; 
    fa = max(size(bwimg)) / min(size(bwimg));
    if fa > 2 % large matrix difference might indicate non-isotropic voxels
        warning('BW:SDTRF', 'Volume of irregular size *might* indicate non-isotropic voxels.');
    end

    % assumption: 2. bwimg is logical or 0/1
    if ~islogical(bwimg);
        warning('BW:SDTRF', 'bwimg is not logical. using logical(bwimg)');
        bwimg = logical(bwimg);
    end
    
    fcn = @bwdist; args = {};
    if nargin == 2,
        msg = 'function bwdistsc not found, please visit matlab file exchange';
        assert(exist('bwdistsc', 'file') == 2, msg);
        fcn = @bwdistsc;
        args = {sc};
    end
    
    % get the positive distances
    posdst = fcn(bwimg, args{:});
    
    % get surface just outside positive elements and get negative distances (within bwimg)
    outerSurface = isclose(posdst, min(sc), min(sc)/10000); % WAS: posdst == min(sc);
    assert(sum(outerSurface(:)) > 0);
    negdst = fcn(outerSurface, args{:});
    
    % compute the final signed distance transform
    dst = posdst.*(~bwimg) - negdst.*(bwimg);
end
