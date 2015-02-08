function x = modBase(X, Y, base)
% MODBASE mod with respect to a specific base numbering system 
%	x = modBase(X, Y) behaves similar to mod(), but is in base 1, meaning the 
%	numbering system starts at 1. This means that modBase(3, 3) will give you 3.
%
% Contact {adalca,klbouman}@csail.mit.edu

    if nargin == 2
        base = 1;
    end
    
    x = base + mod(X - base, Y);
end