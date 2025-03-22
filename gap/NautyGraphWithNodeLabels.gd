#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017-2018, Sebastian Gutsche, Universität Siegen
##
#############################################################################

#! @Chapter Nauty Graphs with labels
#! @Section Working with Nauty Graphs with labels
#! @SectionLabel Nauty_Graphs_Labels


#DeclareCategory( "IsNautyGraphWithNodeLabels",
#                 IsNautyGraph );

#! The package NautyTracesInterface allows working with graphs whose nodes
#! are labelled. This feature is useful when working with graphs whose set of
#! nodes is not equal to a set <M>\{1,\ldots, n\}</M> for some positive
#! integer <M>n</M>. For example, consider the (di) graph on the nodes
#! <M>N=\{2,4,6\}</M>  with edges <M>[ [2,4], [4,6], [2,6] ]</M>. To work with
#! this graph in nauty and traces directly, it is considerted to be a graph
#! with nodes <M>\{1, \ldots, 6\}</M>. However, using <A>node labels</A> we
#! can view this as a graph on three nodes, namely <M>1,2,3</M> and attach
#! a label to each of these nodes. The labels are recorded in a list
#! <A>labels</A>  which defines a map from the default nodes
#! <M>\{1,\ldots, |N|\}</M> to the set of nodes on which the edges are
#! defined. In this example,
#! <M>labels = [ 2, 4, 6]</M>. The function  <A>NautyGraphWithNodeLabels</A>
#! called with the edges
#! <M>[ [2,4], [4,6], [2,6] ]</M> and  labels
#! <M>[ 2, 4, 6]</M> then returns a graph on 3 nodes. The graph on the
#! default node set is called the <A>underlying nauty graph</A>.



#! @BeginGroup
#! @Description
#! Given a nauty (di)graph <A>graph</A> with node labels this function returns
#! a dense list of positive integers, which are the node labels of <A>graph</A>.
#! If <M>i</M> is a node in the underlying nauty graph, then
#! <A>labels[i] = j</A>  means that the  <M>i</M>-th node has label  <M>j</M>. 
#!
#! @BeginExampleSession
#! gap> labels := [4,3,5,2,1];;
#! gap> ng := NautyDiGraphWithNodeLabels([[1,2],[1,3],[1,4],[1,5]], labels);
#! <An undirected Nauty graph with on 5 vertices>
#! gap> NodeLabeling(ng);
#! [ 4, 3, 5, 2, 1 ]
#! @EndExampleSession
#! @Returns a <K>list</K>
#! @Arguments graph
DeclareAttribute( "NodeLabeling", IsNautyGraphWithNodeLabels );
#! @EndGroup


#! @BeginGroup
#! @Description
#! A nauty (di)graph <A>graph</A> with node labels <A>labels</A> is
#! a nauty graph object containing an <A>underlying nauty graph</A>.
#! The graph has a set <M>N</M> of nodes and edges between these nodes.
#! The underlying nauty graph has nodes <M> \{1, \ldots, |N| \}</M>.
#! If <M>i</M> is a node in the underlying nauty graph, then
#! <A>labels[i] = j</A>  means that the  <M>i</M>-th node has label  <M>j</M>,
#! where <M>j\in N.</M> Thus <A>labels</A>  is a bijection from
#! <M> \{1, \ldots, |N| \}</M> to <M>N</M>.
#!  Suppose <A>graph</A> has benn constructed with
#!  <K>NautyDiGraphWithNodeLabels(edges, labels)</K>. 
#! The underlying nauty graph <M>\Gamma</M> on  the nodes
#! <M>\{1,\ldots, nr\}</M>, is defined such
#! that <M>e=[i,j]</M> is an edge of <M>\Gamma</M> if and only if
#! <M>[label[i[,label[j]]</M> is in the input list <A>edges</A>.
#!
#! @BeginExampleSession
#! gap> labels := [4,3,5,2,1];;
#! gap> ng := NautyDiGraphWithNodeLabels([[1,2],[1,3],[1,4],[1,5]], labels);
#! <An undirected Nauty graph with on 5 vertices>
#! gap> NodeLabeling(ng);
#! [ 4, 3, 5, 2, 1 ]
#! EdgesOfNautyGraph(UnderlyingNautyGraph(ng));
#! [ [ 5, 4 ], [ 5, 2 ], [ 5, 1 ], [ 5, 3 ] ]
#! gap> labels := [10,11,12,13,9];;
#! gap> ng := NautyDiGraphWithNodeLabels([[10,11],[10,12],[10,13],[10,9]], labels);
#! <A directed Nauty graph on 5 vertices>
#! gap> EdgesOfNautyGraph(ng);
#! [ [ 10, 11 ], [ 10, 12 ], [ 10, 13 ], [ 10, 9 ] ]
#! gap> EdgesOfNautyGraph(UnderlyingNautyGraph(ng));
#! [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 1, 5 ] ]
#! gap> VerticesOfNautyGraph(ng);
#! [ 9, 10, 11, 12, 13 ]
#! gap> VerticesOfNautyGraph(UnderlyingNautyGraph(ng));
#! [ 1 .. 5 ]
#! @EndExampleSession
#! @Returns a <K>list</K>
#! @Arguments graph
DeclareAttribute( "UnderlyingNautyGraph", IsNautyGraphWithNodeLabels );
#! @EndGroup



## Constructors
#! @BeginGroup
#! @Description
#! Construct a nauty (di)graph with node labels and optional vertex colouring,
#! which is an  object that has an underlying nauty graph.
#! Suppose we have
#! a graph given by a list <A>edges</A> of edges, where each edge is a list
#! of two positive integers.
#!
#! Arguments:
#!  * <A>edges</A>: dense list of edges, encoded as pairs of positive integers.
#!    Let <M>N</M> denote the set of all (not necessarily consecutive) positive
#!     integers occuring in the
#!    entries of <A>edges</A>. 
#! * <A>labels</A>: dense list of positive integers which is a map
#!   <M>label</M> from  <M>[1\ldots |N|]</M> to <M>M</M>.
#! * <A>colouring</A> (optional): dense list of colours (positive integers),
#!      indexed by the nodes of the underlying nauty graph, that is
#!   <A>colouring</A> is a map from <M>[1\ldots |N|]</M> to a set of node
#!  colours.
#! 
#! This function constructs
#! a nauty graph <M>\Gamma</M> on  the nodes <M>\{1,\ldots, |N|\}</M>, such
#! that <M>e=[i,j]</M> is an edge of <M>\Gamma</M> if and only if
#! <M>[label[i],label[j]]</M> is in the input list <A>edges</A>.
#! 
#! This function is useful, for example, if we are given a graph on a set
#! of nodes <M>N</M>  which is not equal to the set
#! <M>\{1, \ldots, |N|\}</M> and we would like to translate the nodes and
#! edges of the graph to the node set <M>\{1, \ldots, |N|\}</M> to obtain
#! a more compact description of the  graph.
#!
#! @BeginExampleSession
#! gap> ng :=  NautyDiGraphWithNodeLabels( [[1,8],[1,12],[1,7],[1,5]],
#!              [7,12,5,1,8]);
#! <A directed Nauty graph on 5 vertices>
#! gap> EdgesOfNautyGraph(ng);
#! [ [ 1, 8 ], [ 1, 12 ], [ 1, 7 ], [ 1, 5 ] ]
#! gap> ung := UnderlyingNautyGraph(ng);
#! <A directed Nauty graph on 5 vertices>
#! gap> EdgesOfNautyGraph(ung);
#! [ [ 4, 5 ], [ 4, 2 ], [ 4, 1 ], [ 4, 3 ] ]
#! @EndExampleSession
#! @Returns a <K>NautyGraph</K>
#! @Arguments edges, labeling
DeclareOperation( "NautyGraphWithNodeLabels", [ IsList, IsList ] );
#! @Arguments edges, labeling
DeclareOperation( "NautyDiGraphWithNodeLabels", [ IsList, IsList ] );
#! @Arguments edges, colours, labeling
DeclareOperation( "NautyColoredGraphWithNodeLabels", [ IsList, IsList, IsList ] );
#! @Arguments edges, colours labeling
DeclareOperation( "NautyColoredDiGraphWithNodeLabels", [ IsList, IsList, IsList ] );
#! DeclareSynonym("NautyColouredGraphWithNodeLabels",NautyColouredGraphWithNodeLabels);
#! DeclareSynonym("NautyColouredDiGraphWithNodeLabels",NautyColouredDiGraphWithNodeLabels);
#! @EndGroup


#! @BeginGroup
#! @Description
#! Returns the list of node labels for a  nauty (di)graph with node labels or fail else.
#! 
#! Nauty graphs with node labels are useful, for example, if we are given a graph on a set
#! of nodes <M>N</M>  which is not equal to the set
#! <M>\{1, \ldots, |N|\}</M> and we would like to translate the nodes and
#! edges of the graph to the node set <M>\{1, \ldots, |N|\}</M> to obtain
#! a more compact description of the  graph.
#!
#! @BeginExampleSession
#! gap> ng :=  NautyDiGraphWithNodeLabels( [[1,8],[1,12],[1,7],[1,5]],
#!              [7,12,5,1,8]);
#! <A directed Nauty graph on 5 vertices>
#! gap> EdgesOfNautyGraph(ng);
#! [ [ 1, 8 ], [ 1, 12 ], [ 1, 7 ], [ 1, 5 ] ]
#! gap> NautyGraphNodeLabels(ng);
#! [ 7, 12, 5, 1, 8 ]
#! @EndExampleSession
#! @Returns a <K>List</K>
DeclareOperation( "NautyGraphNodeLabels", [ IsNautyGraph ] );
#! @Arguments graph
#! @EndGroup
