#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017-2018, Sebastian Gutsche, Universität Siegen
##
#############################################################################


# DeclareRepresentation( "IsNautyGraphWithNodeLabelsRep",
#                        IsNautyGraphWithNodeLabels and IsAttributeStoringRep, [ ] );

# BindGlobal( "TheTypeOfNautyGraphsWithNodeLabels",
#         NewType( TheFamilyOfNautyGraphs,
#                 IsNautyGraphWithNodeLabelsRep ) );

##############################################################################
##
## This function takes a list node_labels and a list edges, where
## the first is a dense list of positive integers
## and edges are pairs of positive integers.
## The list node_labels has to have the same length as the number
## of nodes of a graph. Suppose the nodes are [1 .. nr].
## node_labels defines a map on the nodes, as for example
## created by a canonical labelling, whereby
## node_label[i] = j means that the i-th node should be known as j.
## This function rewrites the edges as given by the labels in node_label
## into the names of the original nodes. For example, 
## if e = [j1, j2] is an edge, then in the names given by node_labels
## it becomes [i1, i2] = [nodePos[j1], nodePos[j2] ], where
## nodePos[j] = i; In other words, node_labels defines a map
## <M>\pi</M> and for <M> \psi=\pi^{-1}</M> this function returns
## the images of <A>edges</A> under <M>\psi</M>.

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

    if not IsDuplicateFreeList(labeling) then
        ErrorNoReturn("NautyGraphWithNodeLabels: labelling must be duplicate free");
    fi;
    
    new_edges := NAUTYTRACESINTERFACE_Translate_Edge_List( labeling, edges );
    
    underlying_graph := NautyGraph( new_edges, Length( labeling ) );
    
    labeled_graph := rec( );
    
    ObjectifyWithAttributes( labeled_graph, TheTypeOfNautyGraphsWithNodeLabels,
                             NodeLabeling, labeling,
			     IsDirected, false,
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
			     IsDirected, true,
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
			     IsDirected, false,
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
			     IsDirected, true,
                             UnderlyingNautyGraph, underlying_graph );

    return labeled_graph;
    
end );

BindGlobal( "NAUTYTRACESINTERFACE_Translate_Permutation",
  function( node_labels, permutation )
    local range_labels;
    
    range_labels := List( [ 1 .. Length( node_labels ) ], i -> node_labels[ OnPoints( i, permutation ) ] );
    
    return MappingPermListList( node_labels, range_labels );
    
end );

InstallMethod( NautyGraphNodeLabels,
               [ IsNautyGraph ],
    function( graph )
               if IsNautyGraphWithNodeLabels(graph) then
                   return graph!.NodeLabeling;
               else return fail;
               fi;
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

InstallMethod( CanonicalForm,
               [ IsNautyGraphWithNodeLabelsRep ],
               
  function( graph )

    return CanonicalForm(UnderlyingNautyGraph(graph));
    
end );


InstallMethod( IsomorphismGraphs,
               [ IsNautyGraphWithNodeLabelsRep, IsNautyGraphWithNodeLabelsRep ],
               
  function( graph1, graph2 )
      local labels1, labels2, iso, p, i;

      iso := IsomorphismGraphs(
          UnderlyingNautyGraph(graph1),UnderlyingNautyGraph(graph2));

      if iso = fail then return fail; fi;

      # now translate the isomorphism
      labels1:= NodeLabeling(graph1);
      labels2:= NodeLabeling(graph2);
      # if graph1 and graph2 are on the same notes as their underlying
      # graph, just return the permutation defining the isomorphism
      if labels1 = [1..Length(labels1)] and labels2 = [1..Length(labels2)] then
          return iso;
      fi;
      # otherwise, we return a partial permutation
      return LeftQuotient(PartialPerm([1..Length(labels1)],labels1),iso)
             * PartialPerm([1..Length(labels1)],labels2) ;

end );

InstallMethod( IsomorphismGraphs,
               [ IsNautyGraphWithNodeLabelsRep, IsNautyGraphRep ],
               
  function( graph1, graph2 )
      local labels1, labels2, iso;

      iso := IsomorphismGraphs(
          UnderlyingNautyGraph(graph1),graph2);
      if iso = fail then return fail; fi;
      if labels1 = [1..Length(labels1)] then
          return iso;
      fi;
      labels1:= NodeLabeling(graph1);
      return LeftQuotient(PartialPerm([1..Length(labels1)],labels1),iso);
end );


InstallMethod( IsomorphismGraphs,
               [ IsNautyGraphRep, IsNautyGraphWithNodeLabelsRep ],
               
  function( graph1, graph2 )
      local labels1, labels2, iso;

      iso := IsomorphismGraphs(
          graph1,UnderlyingNautyGraph(graph2));
    return iso;
end );

## TODO
InstallMethod( IsomorphismGraphs,
               [ IsNautyGraphWithNodeLabelsRep and IsColored,
	          IsNautyGraphWithNodeLabelsRep and IsColored ],
               
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
    [ IsNautyGraphWithNodeLabelsRep and IsColored and HasCanonicalForm, 
        IsNautyGraphWithNodeLabelsRep and IsColored and HasCanonicalForm ],
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
               [ IsNautyGraphWithNodeLabelsRep, IsNautyGraphWithNodeLabelsRep ],
               
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


