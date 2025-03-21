#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017-2018, Sebastian Gutsche, Universität Siegen
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

DeclareRepresentation( "IsNautyEdgeColoredGraphRep",
                       IsNautyGraph and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "TheTypeOfNautyEdgeColoredGraphs",
        NewType( TheFamilyOfNautyGraphs,
                IsNautyEdgeColoredGraphRep ) );

#new
DeclareRepresentation( "IsNautyGraphWithNodeLabelsRep",
                       IsNautyGraphWithNodeLabels and IsAttributeStoringRep, [ ] );

BindGlobal( "TheTypeOfNautyGraphsWithNodeLabels",
        NewType( TheFamilyOfNautyGraphs,
                IsNautyGraphWithNodeLabelsRep ) );

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

InstallGlobalFunction( CREATE_NAUTY_EDGE_COLORED_GRAPH,
  function( record )
    
    ObjectifyWithAttributes( record, TheTypeOfNautyEdgeColoredGraphs,
                             IsColored, false,
                             IsDirected, record.directed );
    
    return record;
    
end );

InstallMethod( NautyGraph,
               [ IsList ],
	       
               
  function( edges )
               local nr_nodes, fl;

    fl := Flat(edges);
    if not IsHomogeneousList(fl) or not IsInt(fl[1]) then
	    ErrorNoReturn("Edges are lists of lists");
    fi;
    nr_nodes := MaximumList(fl);
    
    return NautyGraph( edges, nr_nodes );
    
end );

InstallMethod( NautyGraph,
               [ IsList, IsInt ],
               
  function( edges, nr_nodes )
    local graph_rec, e;

    
    # check the edges are pairs of positive integers
    for e in edges do
        if not IsList(e) then
	    ErrorNoReturn("Edges are lists of lists");
	fi;
	if Length(e) <> 2 then
	    ErrorNoReturn("Edges are lists of length 2 of positive integers");
	fi;
	if not IsPosInt(e[1]) or not IsPosInt(e[2]) then
	    ErrorNoReturn("Edges are positive integers");
	fi;
    od;
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := false );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

InstallMethod( NautyDiGraph,
               [ IsList ],
               
  function( edges )
    local nr_nodes, e, fl;
    
    fl := Flat(edges);
    if not IsHomogeneousList(fl) or not IsInt(fl[1]) then
	    ErrorNoReturn("Edges are lists of lists");
    fi;
    nr_nodes := MaximumList(fl);
    
    return NautyDiGraph( edges, nr_nodes );
    
end );

InstallMethod( NautyDiGraph,
               [ IsList, IsInt ],
               
  function( edges, nr_nodes )
    local graph_rec, e;
    
    for e in edges do
        if not IsList(e) then
	    ErrorNoReturn("Edges are lists of lists");
	fi;
	if Length(e) <> 2 then
	    ErrorNoReturn("Edges are lists of length 2 of positive integers");
	fi;
	if not IsPosInt(e[1]) or not IsPosInt(e[2]) then
	    ErrorNoReturn("Edges are positive integers");
	fi;
    od;
        
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := true );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );

# a vertex colored graph
InstallMethod( NautyColoredGraph,
               [ IsList, IsList ],
               
  function( edges, colors )
    local graph_rec, nr_nodes, e, fl;

    for e in edges do
        if not IsList(e) then
	    ErrorNoReturn("Edges are lists of lists");
	fi;
	if Length(e) <> 2 then
	    ErrorNoReturn("Edges are lists of length 2 of positive integers");
	fi;
	if not IsPosInt(e[1]) or not IsPosInt(e[2]) then
	    ErrorNoReturn("Edges are positive integers");
	fi;
    od;
    
    nr_nodes := Length( colors );
    fl := Flat(edges);
    if not IsHomogeneousList(fl) or not IsInt(fl[1]) then
	    ErrorNoReturn("Edges are lists of lists");
    fi;
               
    if MaximumList(fl) <>  nr_nodes then
        ErrorNoReturn("The list of colours has to be in bijection to vertices");
    fi;
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := false,
                      colors := colors );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );


# a vertex colored graph
InstallMethod( NautyColoredDiGraph,
               [ IsList, IsList ],
               
  function( edges, colors )
    local graph_rec, nr_nodes, e;

    for e in edges do
        # an edge is a pair of positive integers
        if not IsList(e) then
           ErrorNoReturn("Edges are lists of lists");
        fi;
        if Length(e) <> 2 then
            ErrorNoReturn("Edges are lists of length 2");
        fi;
        if not IsPosInt(e[1]) or not IsPosInt(e[2]) then
            ErrorNoReturn("Edges are positive integers");
        fi;
    od;

    nr_nodes := Length( colors );
    
    graph_rec := rec( nr_nodes := nr_nodes,
                      edges := edges,
                      directed := true,
                      colors := colors );
    
    return CREATE_NAUTY_GRAPH_OBJECT( graph_rec );
    
end );


InstallMethod( NautyEdgeColoredGraph,
               [ IsList ],
               
  function( edgeclasses )
    local nr_nodes, e, edges;
    
    nr_nodes := MaximumList( Flat( edgeclasses ) );
    
    return NautyEdgeColoredGraph( edgeclasses, nr_nodes );
    
end );

InstallMethod( NautyEdgeColoredGraph,
               [ IsList, IsInt ],
               
  function( edgeclasses, nr_nodes )
    local graph_rec, e, edges;
    

    # check the edgeclasses are lists of edges
    for edges in edgeclasses do
        for e in edges do
            # an edge is a pair of positive integers
            if not IsList(e) then
	        ErrorNoReturn("Edges are lists of lists");
	    fi;
	    if Length(e) <> 2 then
	        ErrorNoReturn("Edges are lists of length 2");
	    fi;
            if not IsPosInt(e[1]) or not IsPosInt(e[2]) then
	        ErrorNoReturn("Edges are positive integers");
	    fi;
	od;
    od;

    graph_rec := rec( nr_nodes := nr_nodes,
                      edge_list := edgeclasses,
                      directed := false );
    
    return CREATE_NAUTY_EDGE_COLORED_GRAPH( graph_rec );
    
end );

InstallMethod( NautyEdgeColoredDiGraph,
               [ IsList ],
               
  function( edgeclasses )
    local nr_nodes, e, edges;
    
    nr_nodes := MaximumList( Flat( edgeclasses ) );
    
    return NautyEdgeColoredDiGraph( edgeclasses, nr_nodes );
    
end );


InstallMethod( NautyEdgeColoredDiGraph,
               [ IsList, IsInt ],
               
  function( edgeclasses, nr_nodes )
    local graph_rec, e, edges;
    

    # check the edgeclasses are lists of edges
    for edges in edgeclasses do
        for e in edges do
            # an edge is a pair of positive integers
            if not IsList(e) then
	        ErrorNoReturn("Edges are lists of lists");
	    fi;
	    if Length(e) <> 2 then
	        ErrorNoReturn("Edges are lists of length 2");
	    fi;
            if not IsPosInt(e[1]) or not IsPosInt(e[2]) then
	        ErrorNoReturn("Edges are positive integers");
	    fi;
	od;
    od;


    graph_rec := rec( nr_nodes := nr_nodes,
                      edge_list := edgeclasses,
                      directed := true );
    
    return CREATE_NAUTY_EDGE_COLORED_GRAPH( graph_rec );
    
end );

InstallMethod( ViewObj,
               [ IsNautyGraph and IsDirected ],
               
  function( graph )

    local nr_nodes, g;

    if IsNautyGraphWithNodeLabels(graph) then
        g := UnderlyingNautyGraph(graph);
    else
        g := graph;
    fi;
    if IsColored(g) then
        Print( "<A directed vertex-coloured Nauty graph on ", 
           g!.nr_nodes, " vertices>");
    elif  IsNautyEdgeColoredGraphRep  (g) then
            Print( "<A directed edge-coloured Nauty graph on ", 
             g!.nr_nodes, " vertices and ", Length(g!.edge_list), " edge colours>");    else
            Print( "<A directed Nauty graph on ", 
           g!.nr_nodes, " vertices>");
    fi;
	   
end );

InstallMethod( ViewObj, "for a nauty graph",
               [ IsNautyGraph ],
               
  function( graph )

    local g;
    
    if IsNautyGraphWithNodeLabels(graph) then
        g := UnderlyingNautyGraph(graph);
    else
        g := graph;
    fi;

    if IsColored(g) then
        Print( "<An  undirected vertex-coloured Nauty graph on ", 
           g!.nr_nodes, " vertices>");
    elif  IsNautyEdgeColoredGraphRep  (g) then
            Print( "<An undirected edge-coloured Nauty graph on ", 
           g!.nr_nodes, " vertices and ", Length(g!.edge_list), " edge colours>");
    else
        Print( "<An undirected Nauty graph with on ",
           g!.nr_nodes, " vertices>");
    fi;
    
end );


InstallMethod( Display, "for a nauty graph",
               [ IsNautyGraph ],
    function(graph)


               local g, vert, edg, i, col, c,  j, colcol, cnt, dir, nodel;
    
    if IsNautyGraphWithNodeLabels(graph) then
        g := UnderlyingNautyGraph(graph);
        nodel := NautyGraphNodeLabels(graph);
    else
        g := graph;
        nodel := false;
    fi;

    dir := "undirected";
    if IsDirected(g) then dir := "directed"; fi;           
    if IsColored(g) then
        Print( "Nauty Graph (",dir, " vertex-coloured)\n");
    elif  IsNautyEdgeColoredGraphRep  (g) then
        Print( "Nauty Graph (", dir, " edge-coloured with ", Length(g!.edge_list), " colours )\n ");
    else
        Print( "Nauty Graph (",dir,")\n");

    fi;

    vert := VerticesOfNautyGraph(graph);

    if IsColored(g) then
        col := g!.colors;
        colcol := Collected(col);
        Print("Vertices (", Length(vert), ") by colours: \n");
        for j in [1..Length(colcol)] do
            c := colcol[j][1]; # the colour
            Print(" (", c, "):  [ " );
            cnt := 0;
            for i in [1..Length(vert)] do
               if col[i] = c then
                   Print(vert[i]);
                   cnt := cnt+1;
                   if cnt < colcol[j][2] then
                       Print(",");
                   else Print("]\n");
                   fi;
               fi;

            od;
        od;
        if nodel<>false then Print("Vertex labels :", nodel, "\n"); fi;
        edg := EdgesOfNautyGraph(graph);
        Print("Edges (", Length(edg), "): ", edg, "\n");
    elif IsNautyEdgeColoredGraphRep(g) then
        Print("Vertices (", Length(vert), "): ", vert, "\n");
        if nodel<>false then Print("Vertex labels :", nodel, "\n"); fi;
        edg := g!.edge_list;
        Print("Edges (", Length(EdgesOfNautyGraph(graph)), ") by colour: \n");
        for i in [1..Length(edg)] do
            Print( "(",i,") ", edg[i],"\n");
        od;
    else
        Print("Vertices (", Length(vert), "): ", vert, "\n");
        if nodel<>false then Print("Vertex labels :", nodel, "\n"); fi;
        edg := EdgesOfNautyGraph(graph);
        Print("Edges (", Length(edg), "): ", edg, "\n");
    fi;
    
end );
               


#! TODO: document this
BindGlobal( "NautyDense",
function( source_list, range_list, n, is_directed, color_data )
    local graph;
    graph := NAUTY_GRAPH( source_list, range_list, n, is_directed );
    return NAUTY_DENSE( graph, is_directed, color_data );
end );

#! TODO: document this
BindGlobal( "NautyDenseRepeated",
function( source_list, range_list, n, is_directed, color_data )
    local graph;
    graph := NAUTY_GRAPH( source_list, range_list, n, is_directed );
    return NAUTY_DENSE_REPEATED( graph, is_directed, color_data );
end );

InstallGlobalFunction( CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES,
  
  function( nauty_graph )
    local colors, nauty_data, automorphism_group;
    
    if IsNautyEdgeColoredGraphRep( nauty_graph ) then
        CALL_NAUTY_ON_EDGE_COLORED_GRAPH( nauty_graph );
        return;
    fi;
    
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

InstallGlobalFunction( CALL_NAUTY_ON_EDGE_COLORED_GRAPH,
  
  function( nauty_graph )
    local nr_nodes, nauty_data, edge_data, color_data;
    
    nr_nodes := nauty_graph!.nr_nodes;
    
    nauty_data := NautyGraphDataForColoredEdges( nauty_graph!.edge_list, nr_nodes, false );
    
    edge_data := NautyGraphFromEdges( nauty_data[ 1 ] );
    
    color_data := NautyColorData( nauty_data[ 2 ] );
    
    nauty_data := NautyDense( edge_data[ 1 ], edge_data[ 2 ], Length( nauty_data[ 2 ] ), IsDirected( nauty_graph ), color_data );
    
    nauty_data[ 1 ] := List( nauty_data[ 1 ], i -> Permutation( i, [ 1 .. nr_nodes ] ) );
    nauty_data[ 2 ] := Permutation( nauty_data[ 2 ], [ 1 .. nr_nodes ] );
    
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


InstallMethod( VerticesOfNautyGraph,
               [ IsNautyGraph ],

    function( graph )

        local nr_nodes, g, labels;

        if IsNautyGraphWithNodeLabels(graph) then
	    g := UnderlyingNautyGraph(graph);
   	    labels := NodeLabeling(graph);
	    nr_nodes := g!.nr_nodes; 
	    return Set(List([1..nr_nodes], j->labels[j]));
	else
	    nr_nodes := graph!.nr_nodes;
            return [1..nr_nodes];
	fi;
	
end);

InstallMethod( VertexColoursOfNautyGraph,
               [ IsNautyGraph ],

    function( graph )

       local nr_nodes, g;
       
        if IsNautyGraphWithNodeLabels(graph) then
	    g := UnderlyingNautyGraph(graph);
	else g := graph;
	fi;

        if IsColored(g) then
            return g!.colors;
	else
    	    return fail;
	fi;
	
end);

InstallMethod( EdgesOfNautyGraph,
               [ IsNautyGraph ],

    function( graph )

        local edges, g, labels, i, edg;

        if IsNautyGraphWithNodeLabels(graph) then
	    g := UnderlyingNautyGraph(graph);
	    labels := NodeLabeling(graph);
	    edges := List(g!.edges, e->List(e, j->labels[j]));
        elif IsNautyEdgeColoredGraphRep(graph) then
              edg := graph!.edge_list;
              edges := [];
              for i in [1 .. Length(edg)] do
                  Append(edges, edg[i]);
              od;
	else
	    edges := graph!.edges;
	fi;
        return edges;
	
end);

InstallMethod( Edges,
               [ IsNautyGraph ],

    function( graph )

        return EdgesOfNautyGraph(graph);
	
end);


InstallMethod( CanonicalLabeling,
               [ IsNautyGraph ],
               
  function( graph )
    
    CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES( graph );
    
    return CanonicalLabeling( graph );
    
end );

InstallMethod( CanonicalLabelingInverse, [IsNautyGraph],
  function( graph )

    return CanonicalLabeling( graph )^(-1);

end );

InstallMethod( CanonicalForm,
               [ IsNautyGraphRep ],
               
  function( graph )
    local colors, edges, new_graph, permEdges, i,
        permInv;
    
    permInv := CanonicalLabelingInverse( graph );
    
    edges := graph!.edges;

    permEdges := [];
    # Since this computation should be efficient we do it manually
    if IsDirected( graph ) then
        for i in [ 1 .. Length( edges ) ] do # edges is a dense list
               Add( permEdges, [ edges[ i ][ 1 ]^permInv, edges[ i ][ 2 ]^permInv ] );
        od;
    else
        for i in [ 1 .. Length( edges ) ] do # edges is a dense list
            # Every line of code in this loop costs a lot of time
            Add( permEdges, [ edges[ i ][ 1 ]^permInv, edges[ i ][ 2 ]^permInv ] );
            if permEdges[ i ][ 1 ] > permEdges[ i ][ 2 ] then
                permEdges[ i ] := [ permEdges[ i ][ 2 ], permEdges[ i ][ 1 ] ];
            fi;
        od;
    fi;
    edges := Set( permEdges );
    
    if IsColored( graph ) then
        colors := graph!.colors;
        colors := Permuted( colors, permInv );
    fi;
    
    if IsDirected( graph ) then
        
        if IsColored( graph ) then
            new_graph := NautyColoredDiGraph( edges, colors );
        else
            new_graph := NautyDiGraph( edges, graph!.nr_nodes  );
        fi;
    
    else
        
        if IsColored( graph ) then
            new_graph := NautyColoredGraph( edges, colors );
        else
            new_graph := NautyGraph( edges, graph!.nr_nodes );
        fi;
    fi;
    
    return new_graph;
    
end );


InstallMethod( CanonicalForm,
               [ IsNautyEdgeColoredGraphRep ],
               
  function( graph )
    local colors, edges, new_graph, permEdges, i,
        permInv, edgeClass, newClass, edge;
    
    permInv := CanonicalLabelingInverse( graph );
    
    edges := graph!.edge_list;

    # Since this computation should be efficient we do it manually
    # This is benchmarked in benchmarks/Benchmark_CanonicalForm_EdgeColoured.g
    permEdges := [];
    for edgeClass in edges do
        newClass := [];

        for edge in edgeClass do # edges is a dense list
            Add(newClass, OnSets(edge, permInv));
        od;


        Add(permEdges, Set(newClass) );
    od;
    edges := permEdges;
    
    return NautyEdgeColoredGraph(edges, graph!.nr_nodes);
    
end );


BindGlobal( "NAUTYTRACESINTERFACE_IsomorphismGraphsOnlyEdges",
  function( graph1, graph2 )
    local can1, can2;

    can1 := CanonicalForm( graph1 );
    can2 := CanonicalForm( graph2 );
    if can1!.edges = can2!.edges then 
        return CanonicalLabelingInverse( graph1 ) * CanonicalLabeling( graph2 );
    fi;
    
    return fail;
end );

BindGlobal( "NAUTYTRACESINTERFACE_IsomorphismGraphsOnlyEdges_List",
  function( graph1, graph2 )
    local can1, can2;

    can1 := CanonicalForm( graph1 );
    can2 := CanonicalForm( graph2 );
    if can1!.edge_list = can2!.edge_list then 
        return CanonicalLabelingInverse( graph1 ) * CanonicalLabeling( graph2 );
    fi;
    
    return fail;
end );

# Isomorphism computation for graphs without edge colouring

InstallMethod( IsomorphismGraphs,
               [ IsNautyGraphRep and IsDirected, IsNautyGraphRep and IsDirected ],
               
  function( graph1, graph2 )
    return NAUTYTRACESINTERFACE_IsomorphismGraphsOnlyEdges( graph1, graph2 );
end );

InstallMethod( IsomorphismGraphs,
               [ IsNautyGraphRep, IsNautyGraphRep ],
               
  function( graph1, graph2 )
    return NAUTYTRACESINTERFACE_IsomorphismGraphsOnlyEdges( graph1, graph2 );
end );

InstallMethod( IsomorphismGraphs,
               [ IsNautyGraphRep and IsColored, IsNautyGraphRep and IsColored ],
               
  function( graph1, graph2 )
    local color1, color2, perm1, perm2;
    
    perm1 := CanonicalLabeling( graph1 );
    perm2 := CanonicalLabeling( graph2 );
    
    color1 := Permuted( graph1!.colors, perm1^(-1) );
    color2 := Permuted( graph2!.colors, perm2^(-1) );
    
    if color1 = color2 then
        return NAUTYTRACESINTERFACE_IsomorphismGraphsOnlyEdges( graph1, graph2 );
    fi;
    
    return fail;
    
end );

InstallMethod( IsomorphismGraphs, 
    [ IsNautyGraphRep and IsColored and HasCanonicalForm, 
        IsNautyGraphRep and IsColored and HasCanonicalForm ],
  function( graph1, graph2 )
    local can1, can2;

    can1 := CanonicalForm( graph1 );
    can2 := CanonicalForm( graph2 );
    if can1!.colors = can2!.colors and can1!.edges = can2!.edges then
        return CanonicalLabelingInverse( graph1 ) * CanonicalLabeling( graph2 );
    fi;
    return fail;
end );

InstallMethod( IsomorphicGraphs,
               [ IsNautyGraphRep, IsNautyGraphRep ],
               
  function( graph1, graph2 )
    local isomorphism;
    
    isomorphism := IsomorphismGraphs( graph1, graph2 );
    
    return isomorphism <> fail;
    
end );

# Isomorphisms for node labelled graphs

InstallMethod( IsomorphicGraphs,
               [ IsNautyGraphWithNodeLabelsRep, IsNautyGraphWithNodeLabelsRep ],
               
  function( graph1, graph2 )
    local isomorphism;
    
    isomorphism := IsomorphismGraphs( graph1, graph2 );
    
    return isomorphism <> fail;
    
end );

# Isomorphisms for edge coloured graphs
InstallMethod( IsomorphismGraphs,
               [ IsNautyEdgeColoredGraphRep, IsNautyEdgeColoredGraphRep ],
               
  function( graph1, graph2 )
    return NAUTYTRACESINTERFACE_IsomorphismGraphsOnlyEdges_List( graph1, graph2 );
end );


InstallMethod( IsomorphicGraphs,
               [ IsNautyEdgeColoredGraphRep, IsNautyEdgeColoredGraphRep ],
               
  function( graph1, graph2 )
    local isomorphism;
    
    isomorphism := IsomorphismGraphs( graph1, graph2 );
    
    return isomorphism <> fail;
    
end );
