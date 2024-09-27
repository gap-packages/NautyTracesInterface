#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017-2018, Sebastian Gutsche, Universität Siegen
##
#############################################################################

#! @Section Working with Nauty Graphs with labels
#! @SectionLabel Nauty_Graphs_Labels

The package NautyTracesInterface allows also to work with graphs whose nodes
are labelled. This feature is useful when working with graphs whose set of
nodes is not equal to a set <M>\{1,\ldots, n\}</M> for some positive
integer <M>n</M>. For example, consider the graph on the nodes
<M>N=\{2,4,6\}</M>  with edges <M>[ [2,4], [4,6], [2,6] ]</M>. To work with
this graph in nauty and traces, it is converted to a graph with nodes
<M>\{1, \ldots, 6\}</M>. However, we can also rename the nodes by introducing
labels and record in a list <A>labels</A>  the map that maps the new names
to the given names, i.e. <M>labels = [ 2, 4, 6]</M>. The function
<A>NautyGraphWithNodeLabels</A> called with the edges
<M>[ [2,4], [4,6], [2,6] ]</M> and the list of labels
<M>[ 2, 4, 6]</M> then returns a graph on 3 nodes.

DeclareCategory( "IsNautyGraphWithNodeLabels",
                 IsNautyGraph );

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
#! If <M>i</M> is a node in the underlying nauty graph, then
#! <A>labels[i] = j</A>  means that the  <M>i</M>-th node has label  <M>j</M>. 
#!  Suppose <A>graph</A> was constructed with
#!  <K>NautyDiGraphWithNodeLabels(edges, labels)</K>. Let <M>\pi</M> be
#! the permutation of the nodes  <A>[1..nr]</A> given by <A>labels</A> and
#! <M>\psi=\pi^{-1}</M>. If <M>[j_1,j_2]</M> is
#!  an edge in the list <A>edges</A>, then the underlying nauty graph
#!  contains the edge  <M>[j_1^\psi, j_2^\psi ]</M>.

#! @BeginExampleSession
#! gap> labels := [4,3,5,2,1];;
#! gap> ng := NautyDiGraphWithNodeLabels([[1,2],[1,3],[1,4],[1,5]], labels);
#! <An undirected Nauty graph with on 5 vertices>
#! gap> NodeLabeling(ng);
#! [ 4, 3, 5, 2, 1 ]
#! EdgesOfNautyGraph(UnderlyingNautyGraph(ng));
#! [ [ 5, 1 ], [ 5, 2 ], [ 5, 3 ], [ 5, 4 ] ]
#! @EndExampleSession
#! @Returns a <K>list</K>
#! @Arguments graph
DeclareAttribute( "UnderlyingNautyGraph", IsNautyGraphWithNodeLabels );
#! @EndGroup



## Constructors
#! @BeginGroup
#! @Description
#! Construct a nauty (di)graph with node labels and optional vertex coloring.
#! This object has an underlying nauty graph. Suppose we have a graph on
#! <A>nr</A> nodes given by a list <A>edges</A> of edges and we want to
#! reorder the nodes such that the <A>i</A>th node becomes node <A>j</A>.
#! This function constructs a graph on nodes with the new names and
#! the corresponding edges.
#! 
#!
#! Arguments:
#! * labels: dense list of positive integers which is a permutation <M>\pi</M> of
#!   <A>[1..nr]</A>, where nr is the number of nodes. If <A>i</A> is a node
#!   in the underlying nauty graph, then <A>labels[i] = j</A>  means that the
#!    <A>i</A>-th node has label  <A>j</A>.  Let <M>\psi=\pi^{-1}</M>.
#!  * edges: dense list of edges, encoded as pairs of positive integers,
#!   each interpreted as a node label. In particular, if <M>[j_1,j_2]</M> is
#!   an edge in the list <A>edges</A>, then the underlying nauty graph
#!   contains the edge  <M>[j_1^\psi, j_2^\psi ]</M>.
#! * coloring (optional): dense list of colors (positive integers), 
#!      indexed by the nodes of the underlying nauty graph
#! 
#! This function is useful, for example, if we are given graphs on a set
#! of nodes <M>N</M> which is a subset of a possibly much larger set
#! <M>\{1, \ldots, nr\}</M> and we would like to translate the nodes and
#! edges of the graph to the node set <M>\{1, \ldots, |N|\}</M> to obtain
#! a compacted graph. The permutation 
#! <M>\psi</M> maps the given nodes to <M>\{1, \ldots, |N|\}</M> and
#! maps the edges accordingly. The permutation <M>\pi</M> allows us to
#! recover the original graph from the underlying (compacted) nautygraph.
#!
#! @BeginExampleSession
#! gap> labels :=  ListPerm((1,4,2,3,5));;
#! gap> ng :=  NautyDiGraphWithNodeLabels( [[1,2],[1,3],[1,4] [1,5]], labels);
#! <An undirected Nauty graph with on 5 vertices>
#! gap> EdgesOfNautyGraph(ng);
#! [ [ 5, 1 ], [ 5, 2 ], [ 5, 3 ], [ 5, 4 ] ]
#! gap> psi := (1,4,2,3,5)^(-1);;
#! gap> 1^psi;
#! 5
#! @EndExampleSession
#! @Returns a <K>NautyGraph</K>
#! @Arguments edges, labeling
DeclareOperation( "NautyGraphWithNodeLabels", [ IsList, IsList ] );
#! @Arguments edges, labeling
DeclareOperation( "NautyDiGraphWithNodeLabels", [ IsList, IsList ] );
#! @Arguments edges, colors, labeling
DeclareOperation( "NautyColoredGraphWithNodeLabels", [ IsList, IsList, IsList ] );
#! @Arguments edges, colors labeling
DeclareOperation( "NautyColoredDiGraphWithNodeLabels", [ IsList, IsList, IsList ] );
#! @EndGroup
