function dst = bw2sdtrf(bwimg)
% BW2SDTRF compute a signed distance transform 
%   dst = bw2sdtrf(bwimg) computes the signed distance transform from the surface between the
%   binary elements of logical bwimg, which can be of any dimentions that bwdist accepts. Note
%   that the function assumes isotropic matrix elements (e.g. be wary of non-isotropic voxels
%   in medical imaging).
%
%   Note: the distance transform on either side of the surface will be +1/-1 - i.e. there are
%   no voxels for which the dst should be 0.
%   
%   Runtime: currently the function uses bwdist twice. If there is a quick way to compute the
%   surface, bwdist could be used only once.
%
% Contact: Adrian Dalca, adalca@mit.edu, http://adalca.mit.edu


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
    
    % get the positive distances
    posdst = bwdist(bwimg);
    
    % get surface just outside positive elements and get negative distances (within bwimg)
    outerSurface = posdst == 1;
    negdst = bwdist(outerSurface);
    
    % compute the final signed distance transform
    dst = posdst.*(~bwimg) - negdst.*(bwimg);
end
