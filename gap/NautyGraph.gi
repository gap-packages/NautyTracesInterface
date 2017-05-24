#############################################################################
##
##                                NautyInterface package
##
##  Copyright 2017, Sebastian Gutsche, Universität Siegen
##                  Alice Niemeyer,    RWTH Aachen
##                  Pascal Schweitzer, RWTH Aachen
##
#############################################################################

DeclareRepresentation( "IsNautyGraphRep",
                       IsNautyGraph and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "TheFamilyOfNautyGraphs",
        NewFamily( "TheFamilyOfNautyGraphs" ) );

BindGlobal( "TheTypeOfNautyGraphs",
        NewType( TheFamilyOfNautyGraphs,
                IsNautyGraphRep ) );

InstallGlobalFunction( CREATE_NAUTY_GRAPH_OBJECT,
  function( record )
    local edges, colors;
    
    edges := record.edges;
    edges := NautyGraphFromEdges( edges );
    record.edges_source := edges[ 1 ];
    record.edges_range := edges[ 2 ];
    
    if IsBound( record.colors ) then
        colors := record.colors;
        colors := NautyColorData( colors );
        record.color_labels := colors[ 1 ];
        record.color_partition := colors[ 2 ];
    fi;
    
    ObjectifyWithAttributes( record, TheTypeOfNautyGraphs,
                             IsDirected, record.directed,
                             IsColored, IsBound( record.colors ) );
    
    return record;
    
end );

InstallMethod( NautyGraph,
               [ IsList ],
               
  function( edges )
    local nr_nodes;
    
    nr_nodes := MaximumList( Flat( edges ) );
    
    return NautyGraph( edges, nr_nodes );
    
end );

InstallMethod( NautyGraph,
               [ IsList, IsInt ],
               
  function( edges, nr_nodes )
    local graph_rec;
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := false );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( NautyDiGraph,
               [ IsList ],
               
  function( edges )
    local nr_nodes;
    
    nr_nodes := MaximumList( Flat( edges ) );
    
    return NautyDiGraph( edges, nr_nodes );
    
end );

InstallMethod( NautyDiGraph,
               [ IsList, IsInt ],
               
  function( edges, nr_nodes )
    local graph_rec;
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := true );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( NautyColoredGraph,
               [ IsList, IsList ],
               
  function( edges, colors )
    local graph_rec, nr_nodes;
    
    nr_nodes := Length( colors );
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := false,
                      colors := colors );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( NautyColoredDiGraph,
               [ IsList, IsList ],
               
  function( edges, colors )
    local graph_rec, nr_nodes;
    
    nr_nodes := Length( colors );
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := false,
                      colors := colors );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( ViewObj,
               [ IsNautyGraph and IsDirected ],
               
  function( graph )
    
    Print( "<A directed Nauty graph>" );
    
end );

InstallMethod( ViewObj,
               [ IsNautyGraph ],
               
  function( graph )
    
    Print( "<A Nauty graph>" );
    
end );

InstallGlobalFunction( CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES,
  
  function( nauty_graph )
    local colors, nauty_data, automorphism_group;
    
    if IsColored( nauty_graph ) then
        colors := [ nauty_graph!.color_labels, nauty_graph!.color_partition ];
    else
        colors := false;
    fi;
    
    nauty_data := NautyDense( nauty_graph!.edges_source, 
                              nauty_graph!.edges_range,
                              nauty_graph!.nr_nodes,
                              IsDirected( nauty_graph ),
                              colors );
    
    if nauty_data[ 1 ] <> [ ] then
        SetAutomorphismGroup( nauty_graph, Group( nauty_data[ 1 ] ) );
    else
        SetAutomorphismGroup( nauty_graph, Group( () ) );
    fi;
    SetAutomorphismGroupGenerators( nauty_graph, nauty_data[ 1 ] );
    SetCanonicalLabeling( nauty_graph, nauty_data[ 2 ] );
    
end );

InstallMethod( AutomorphismGroup,
               [ IsNautyGraph ],
               
  function( graph )
    
    CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES( graph );
    
    return AutomorphismGroup( graph );
    
end );

InstallMethod( AutomorphismGroupGenerators,
               [ IsNautyGraph ],
               
  function( graph )
    
    CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES( graph );
    
    return AutomorphismGroupGenerators( graph );
    
end );

InstallMethod( CanonicalLabeling,
               [ IsNautyGraph ],
               
  function( graph )
    
    CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES( graph );
    
    return CanonicalLabeling( graph );
    
end );
