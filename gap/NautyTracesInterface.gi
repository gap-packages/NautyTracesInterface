#############################################################################
##
##                                NautyTracesInterface package
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
    local color_list, node_list, list_pos, current_color, current_entry, colors;
    
    colors := SortedList( DuplicateFreeList( list ) );
    
    color_list := [];
    node_list := [];
    list_pos := 0;
    
    for current_color in colors do
        
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

BindGlobal( "NAUTYINTERFACE_POSINT_TO_BIT_LIST",
  function( integer )
    local bitlist, current_bit;
    
    bitlist := [ ];
    
    while integer > 0 do
        current_bit := integer mod 2;
        Add( bitlist, current_bit );
        if current_bit = 0 then
            integer := integer / 2;
        else
            integer := ( integer - 1 ) / 2;
        fi;
    od;
    
    return bitlist;
    
end );

InstallGlobalFunction( NautyGraphDataForColoredEdges2,
  
  function( edges, nr_nodes, coloring )
    local nr_edge_colors, nr_node_layers, new_edges, color_list, current_edge_color,
          bitlist, current_layer, edge, range_layer, current_node;
    
    nr_edge_colors := Length( edges );
    
    nr_node_layers := Log2Int( nr_edge_colors ) + 1;
    
    new_edges := [ ];
    
    color_list := Flat( List( [ 1 .. nr_node_layers ], i -> List( [ 1 .. nr_nodes ], j -> i ) ) );
    
    ## Colored edges
    for current_edge_color in [ 1 .. nr_edge_colors ] do
        
        bitlist := NAUTYINTERFACE_POSINT_TO_BIT_LIST( current_edge_color );
        
        for current_layer in [ 1 .. Length( bitlist ) ] do
            
            if bitlist[ current_layer ] = 0 then
                continue;
            fi;
            
            for edge in edges[ current_edge_color ] do
                
                Add( new_edges, edge + ( (current_layer-1) * nr_nodes ) );
                
            od;
            
        od;
        
    od;
    
    ## Vertical edges
    for current_layer in [ 1 .. nr_node_layers ] do
        for range_layer in [ 1 .. nr_node_layers ] do
            if range_layer = current_layer then
                continue;
            fi;
            for current_node in [ 1 .. nr_nodes ] do
                Add( new_edges, [ nr_nodes * (current_layer - 1) + current_node, nr_nodes * (range_layer - 1) + current_node ] );
            od;
        od;
    od;
    
    return [ new_edges, color_list ];
    
end );

InstallMethod( ViewString,
               [ IsNautyInternalGraphObject ],
               
  function( obj )
    return "<internal nauty graph>";
end );

InstallMethod( DisplayString,
               [ IsNautyInternalGraphObject ],
               
  function( obj )
    return "internal nauty graph\n";
end );
