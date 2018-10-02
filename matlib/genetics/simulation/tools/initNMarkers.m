function nMarkers= initNMarkers(varargin)
%             nMarkers.NONEXPR_DIRCAUSAL                
%             nMarkers.NONEXPR_NONDIRCAUSAL             
%             nMarkers.EXPR_DIRCAUSAL_VOXCAUSAL             
%             nMarkers.EXPR_DIRCAUSAL_NONVOXCAUSAL
%             nMarkers.EXPR_NONDIRCAUSAL_VOXCAUSAL
%             nMarkers.EXPR_NONDIRCAUSAL_NONVOXCAUSAL 

    assert(nargin == 6);

    nMarkers = initType(geneticType, [varargin{:}]);