#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017-2018, Sebastian Gutsche, Universität Siegen
##
#############################################################################

DeclareRepresentation( "IsNautyGraphWithNodeLabelsRep",
                       IsNautyGraphWithNodeLabels and IsAttributeStoringRep, [ ] );

BindGlobal( "TheTypeOfNautyGraphsWithNodeLabels",
        NewType( TheFamilyOfNautyGraphs,
                IsNautyGraphWithNodeLabelsRep ) );

BindGlobal( "NAUTYTRACESINTERFACE_Translate_Edge_List",
  function( node_labels, edges )
    local new_edges, nodePos, i, edge;

    # the node_labels have to be positive integers
    nodePos := [];
    for i in [ 1 .. Length( node_labels ) ] do
        nodePos[ node_labels[ i ] ] := i;
    od;
    new_edges := [];
    for edge in edges do
        Add( new_edges, [ nodePos[ edge[ 1 ] ], nodePos[ edge[ 2 ] ] ] );
    od;
    
    return new_edges;
    
end );

InstallMethod( NautyGraphWithNodeLabels,
               [ IsList, IsList ],
               
  function( edges, labeling )
    local new_edges, nr_nodes, labeled_graph, underlying_graph;
    
    new_edges := NAUTYTRACESINTERFACE_Translate_Edge_List( labeling, edges );
    
    underlying_graph := NautyGraph( new_edges, Length( labeling ) );
    
    labeled_graph := rec( );
    
    ObjectifyWithAttributes( labeled_graph, TheTypeOfNautyGraphsWithNodeLabels,
                             NodeLabeling, labeling,
                             UnderlyingNautyGraph, underlying_graph );
    
    return labeled_graph;
    
end );

InstallMethod( NautyDiGraphWithNodeLabels,
               [ IsList, IsList ],
               
  function( edges, labeling )
    local new_edges, nr_nodes, labeled_graph, underlying_graph;
    
    new_edges := NAUTYTRACESINTERFACE_Translate_Edge_List( labeling, edges );
    
    underlying_graph := NautyDiGraph( new_edges, Length( labeling ) );
    
    labeled_graph := rec( );
    
    ObjectifyWithAttributes( labeled_graph, TheTypeOfNautyGraphsWithNodeLabels,
                             NodeLabeling, labeling,
                             UnderlyingNautyGraph, underlying_graph );
    
    return labeled_graph;
    
end );

InstallMethod( NautyColoredGraphWithNodeLabels,
               [ IsList, IsList, IsList ],
               
  function( edges, colors, labeling )
    local new_edges, nr_nodes, labeled_graph, underlying_graph;
    
    new_edges := NAUTYTRACESINTERFACE_Translate_Edge_List( labeling, edges );
    
    underlying_graph := NautyColoredGraph( new_edges, colors );
    
    labeled_graph := rec( );
    
    ObjectifyWithAttributes( labeled_graph, TheTypeOfNautyGraphsWithNodeLabels,
                             NodeLabeling, labeling,
                             UnderlyingNautyGraph, underlying_graph );
    
    return labeled_graph;
    
end );

InstallMethod( NautyColoredDiGraphWithNodeLabels,
               [ IsList, IsList, IsList ],
               
  function( edges, colors, labeling )
    local new_edges, nr_nodes, labeled_graph, underlying_graph;
    
    new_edges := NAUTYTRACESINTERFACE_Translate_Edge_List( labeling, edges );
    
    underlying_graph := NautyColoredDiGraph( new_edges, colors );
    
    labeled_graph := rec( );
    
    ObjectifyWithAttributes( labeled_graph, TheTypeOfNautyGraphsWithNodeLabels,
                             NodeLabeling, labeling,
                             UnderlyingNautyGraph, underlying_graph );
    
    return labeled_graph;
    
end );

BindGlobal( "NAUTYTRACESINTERFACE_Translate_Permutation",
  function( node_labels, permutation )
    local range_labels;
    
    range_labels := List( [ 1 .. Length( node_labels ) ], i -> node_labels[ OnPoints( i, permutation ) ] );
    
    return MappingPermListList( node_labels, range_labels );
    
end );

InstallMethod( CanonicalLabeling,
               [ IsNautyGraphWithNodeLabels ],
               
  function( graph )
    local underlying_graph, underlying_labeling, translated_labeling;
    
    underlying_graph := UnderlyingNautyGraph( graph );
    
    underlying_labeling := CanonicalLabeling( underlying_graph );
    
    translated_labeling := NAUTYTRACESINTERFACE_Translate_Permutation( NodeLabeling( graph ), underlying_labeling );
    
    return translated_labeling;
    
end );

InstallMethod( AutomorphismGroupGenerators,
               [ IsNautyGraphWithNodeLabels ],
               
  function( graph )
    local underlying_graph, underlying_generators, translated_generators;
    
    underlying_graph := UnderlyingNautyGraph( graph );
    
    underlying_generators := AutomorphismGroupGenerators( underlying_graph );
    
    translated_generators := List( underlying_generators, i -> NAUTYTRACESINTERFACE_Translate_Permutation( NodeLabeling( graph ), i ) );
    
    return translated_generators;
    
end );

InstallMethod( AutomorphismGroup,
               [ IsNautyGraphWithNodeLabels ],
               
  function( graph )
    local generators;
    
    generators := AutomorphismGroupGenerators( graph );
    
    if generators = [ ] then
        return Group( () );
    fi;
    
    return Group( AutomorphismGroupGenerators( graph ) );
    
end );
