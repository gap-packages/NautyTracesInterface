#
# NautyInterface: An interface to nauty
#
# Implementations
#
InstallGlobalFunction( NautyGraphFromEdges,
  
  function( edges )
    local source_list, range_list;
    
    source_list := List( edges, i -> i[ 1 ] );
    range_list := List( edges, i -> i[ 2 ] );
    
    return [ source_list, range_list ];
    
end );
