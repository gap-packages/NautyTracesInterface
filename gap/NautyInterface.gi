#############################################################################
##
##                                NautyInterface package
##
##  Copyright 2017, Sebastian Gutsche, Universität Siegen
##                  Alice Niemeyer,    RWTH Aachen
##                  Pascal Schweitzer, RWTH Aachen
##
#############################################################################

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

InstallGlobalFunction( NautyGraphDataForColoredEdges,
  
  function( edges, nr_nodes, color_list )
    local new_edges, current_edge_list, current_color, current_edge, node_count, nr_colors;
    
    if color_list = false then
        color_list := List( [ 1 .. nr_nodes ], i -> 1 );
        nr_colors := 1;
    else
        nr_colors := MaximumList( color_list );
    fi;
    
    node_count := nr_nodes + 1;
    
    new_edges := [ ];
    
    for current_color in [ nr_colors + 1 .. Length( edges ) + nr_colors ] do
        
        current_edge_list := edges[ current_color - nr_colors ];
        
        for current_edge in current_edge_list do
            
            Append( new_edges, [ [ current_edge[ 1 ], node_count ], [ node_count, current_edge[ 2 ] ] ] );
            
            color_list[ node_count ] := current_color;
            
            node_count := node_count + 1;
            
        od;
        
    od;
    
    return [ new_edges, color_list ];
    
end );
