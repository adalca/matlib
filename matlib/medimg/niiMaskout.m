function [srcnii, masknii] = niiMaskout(src, mask, out)

    srcnii = loadNii(src);
    masknii = loadNii(mask);
    srcnii.img(masknii.img == 0) = 0;
    
    if nargin == 3
        saveNii(srcnii, out);
    end
end