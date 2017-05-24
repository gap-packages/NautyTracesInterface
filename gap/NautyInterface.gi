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

InstallGlobalFunction( NautyColorData,
  
  function( list )
    local color_list, node_list, nr_colors, list_pos, current_color, current_entry;
    
    nr_colors := MaximumList( list );
    
    color_list := [];
    node_list := [];
    list_pos := 0;
    
    for current_color in [ 1 .. nr_colors ] do
        
        for current_entry in [ 1 .. Length( list ) ] do
            
            if list[ current_entry ] = current_color then
                
                list_pos := list_pos + 1;
                node_list[ list_pos ] := current_entry;
                color_list[ list_pos ] := 1;
                
            fi;
            
        od;
        
        color_list[ list_pos ] := 0;
        
    od;
    
    return [ node_list, color_list ];
    
end );

