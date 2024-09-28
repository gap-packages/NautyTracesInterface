#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017-2018, Sebastian Gutsche, Universität Siegen
##
#############################################################################
#
#! @Chapter Nauty Graphs
#! @ChapterLabel NautyGraphs
#!
#! @Section Working with Nauty Graphs 
#! @SectionLabel Section_NautyGraph

DeclareCategory( "IsNautyGraph",
                 IsObject );

DeclareProperty( "IsDirected", IsNautyGraph );
DeclareProperty( "IsColored", IsNautyGraph );



#!
#! @BeginGroup AutomorphismGroup
#! @Description
#! Given a simple (di)graph <A>graph</A> which is a 
#! <A>nauty graph</A> object (see
#! <Ref Sect="Section_NautyGraph"/>), this function computes the
#! automorphism group of <A>graph</A> as a permutation group on the
#! nodes of <A>graph</A>. As <A>graph</A> is a simple graph, its edges
#! are given as lists <M>[i,j]</M> of length 2 consisting of a pair
#! of nodes in the set <M>N</M>. If an edge is a loop, it is
#! of the form <M>[i,i]</M>. If <M>i,j</M> are different nodes and
#! the graph is undirected,
#! <M>[i,j]</M> and <M>[j,i]</M> refer to the same edge, and 
#! to different edges when  the graph is directed.
#!  A bijection <M>\phi</M> from <M>N</M> to itself
#!  is called an <A>automorphism</A> of the
#! (undirected) graph <A>graph</A> if <M>\phi</M> maps edges of <A>graph</A>
#! to edges of <A>graph</A>, that is  <M>e=[i,j]</M> is an edge of
#! <A>graph</A> if and only if <M>e=[i^\phi,j^\phi]</M> or, in the
#! undirected case, 
#! <M>e=[j^\phi,i^\phi]</M> is an edge of  <A>graph</A>. If
#! The <A>automorphism group</A> of <A>graph</A> is returned as a
#! permutation group acting on the set <M>N</M>.
#!
#! @BeginExampleSession
#! gap> nautygraph := NautyGraph( [ [1,2],[2,3],[3,4], [4,1] ] );
#! <A Nauty graph>
#! gap> AutomorphismGroup(nautygraph);
#! Group([ (2,4), (1,2)(3,4) ])
#! @EndExampleSession
#!
#! @Returns a <K>permutation group</K>
#! @Arguments graph
DeclareAttribute( "AutomorphismGroup", IsNautyGraph );
#! @EndGroup


DeclareAttribute( "AutomorphismGroupGenerators", IsNautyGraph );


#! @BeginGroup EdgesOfNautyGraph
#! @Description
#! Given a  nauty graph <A>graph</A>, this function returns the
#! list of edges of <A>graph</A>, where an edge is a pair of
#! vertices. If the graph is directed, the edge <A>[i,j]</A>
#! is the directed edge from vertex <A>i</A> to vertex <A>j</A>.
#!
#! @BeginExampleSession
#! gap> nautygraph := NautyGraph( [ [1,2],[2,3],[3,4], [4,1] ] );
#! <A Nauty graph with on 4 vertices>
#! gap> EdgesOfNautyGraph(nautygraph);
#! [ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 4, 1 ] ]
#! @EndExampleSession
#!
#! @Returns a list of lists of length 2 of positive integers
#! @Arguments graph
DeclareAttribute( "EdgesOfNautyGraph", IsNautyGraph );
DeclareAttribute( "Edges", IsNautyGraph );
#! @EndGroup

#! @BeginGroup VerticesOfNautyGraph
#! @Description
#! Given a  nauty graph <A>graph</A>, this function returns the
#! list of vertices of <A>graph</A>.
#!
#! @BeginExampleSession
#! gap> nautygraph := NautyGraph( [ [1,2],[2,3],[3,4], [4,1] ] );
#! <A Nauty graph with on 4 vertices>
#! gap> VerticesOfNautyGraph(nautygraph);
#! [ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 4, 1 ] ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments graph
DeclareAttribute( "VerticesOfNautyGraph", IsNautyGraph );
#! @EndGroup

DeclareOperation( "Vertices", [IsNautyGraph] );

#! @BeginGroup VertexColoursOfNautyGraph
#! @Description
#! Given a  coloured nauty graph <A>graph</A>, this function returns a
#! list giving the colours of the  vertices of <A>graph</A>.
#!
#! @BeginExampleSession
#! gap> ng := NautyColoredGraph( [ [1,2], [2,3], [3,4], [4,1], [3,2] ], [1,2,1,2] );
#! <A Nauty graph with on 4 vertices>
#! gap> VertexColoursOfNautyGraph(ng);
#! [ 1, 2, 1, 2 ]
#! @EndExampleSession
#!
#! @Returns a list of positive integers
#! @Arguments graph
DeclareAttribute( "VertexColoursOfNautyGraph", IsNautyGraph);
#! @EndGroup

#! TODO: document this
DeclareAttribute( "CanonicalLabeling", IsNautyGraph );

#! TODO: document this
DeclareAttribute( "CanonicalLabelingInverse", IsNautyGraph );

#! TODO: document this
DeclareAttribute( "CanonicalForm", IsNautyGraph );

#! @BeginGroup Isomorphism
#! @Description
#! Given two nauty (di)graphs <A>graph1</A> and <A>graph2</A> we say that
#! <A>graph1</A> and <A>graph2</A> are isomorphic, if there is a bijection
#! <M>\pi</M> from the vertices of  <A>graph1</A> and to the vertices
#! of <A>graph2</A> such that,  <M>e=[i,j]</M> is an edge of
#! of <A>graph1</A> if and only if <M>e^\pi=[i^\pi,j^\pi]</M> is an edge of
#! of <A>graph2</A>. Such a bijection <M>\pi</M> is called a
#! <A>graph isomorhism</A>. This function tests whether such a bijection 
#! <M>\pi</M> exists. If so, it returns the permutation <M>\pi</M> and otherwise
#! <K>fail</K>. If in addition the nauty (di)graphs <A>graph1</A> and
#! <A>graph2</A> are both vertex coloured, then a bijection <M>\pi</M>
#! is additionally required to respect the partition of the node colours,
#! that is, two nodes <M>i, j</M> have the same colour in <A>graph1</A>
#! if and only if they have the same colour in 
#!  <A>graph2</A>. 
#!
#!
#! @BeginExampleSession
#! gap> ng :=  NautyGraph([[1,2],[1,3],[1,4],[1,5],[2,3],[2,4],[5,6],[6,7]]); 
#! <An undirected Nauty graph with on 7 vertices>
#! gap> ng2 :=  NautyGraph([[1,2],[1,3],[1,4],[1,6],[2,3],[2,4],[5,6],[5,7]]);
#! <An undirected Nauty graph with on 7 vertices>
#! gap> IsomorphismGraphs(ng,ng2);
#! (5,6)
#! @EndExampleSession
#!
#! @Returns a <K>Permutation</K>
#! @Arguments  graph, graph
DeclareOperation( "IsomorphismGraphs", [ IsNautyGraph, IsNautyGraph ] );
#! @EndGroup


#! @BeginGroup Isomorphism
#! @Description
#! Given two nauty (di)graphs <A>graph1</A> and <A>graph2</A> we say that
#! <A>graph1</A> and <A>graph2</A> are isomorphic, if there is a bijection
#! <M>\pi</M> from the vertices of  <A>graph1</A> and to the vertices
#! of <A>graph2</A> such that,  <M>e=[i,j]</M> is an edge of
#! of <A>graph1</A> if and only if <M>e^\pi=[i^\pi,j^\pi]</M> is an edge of
#! of <A>graph2</A>. Such a bijection <M>\pi</M> is called a
#! <B>graph isomorhism</B>.This function tests whether such a bijection 
#! <M>\pi</M> exists. If so, it returns <K>true</K> and otherwise
#! <K>false</K>. If in addition the nauty (di)graphs <A>graph1</A> and
#! <A>graph2</A> are both vertex coloured, then a bijection <M>\pi</M>
#! is additionally required to respect the partition of the node colours,
#! that is, two nodes <M>i, j</M> have the same colour in <A>graph1</A>
#! if and only if they have the same colour in 
#!  <A>graph2</A>. 

#!
#! @BeginExampleSession
#! gap> ng :=  NautyGraph([[1,2],[1,3],[1,4],[1,5],[2,3],[2,4],[5,6],[6,7]]); 
#! <An undirected Nauty graph with on 7 vertices>
#! gap> ng2 :=  NautyGraph([[1,2],[1,3],[1,4],[1,6],[2,3],[2,4],[5,6],[5,7]]);
#! <An undirected Nauty graph with on 7 vertices>
#! gap> IsomorphicGraphs(ng,ng2);
#! true
#! @EndExampleSession
#! @Returns a <K>true</K> or <K>false</K>
#! @Arguments  graph, graph
DeclareOperation( "IsomorphicGraphs", [ IsNautyGraph, IsNautyGraph ] );
#! @EndGroup

## Constructors
DeclareGlobalFunction( "CREATE_NAUTY_GRAPH_OBJECT" );
DeclareGlobalFunction( "CREATE_NAUTY_EDGE_COLORED_GRAPH" );


#! @BeginGroup NautyGraph
#! @Description
#! This function creates a nauty graph object for an undirected graph without
#! multiple edges, but possibly with loops,
#! whose edges are given by the list <A>edges</A>. The list
#! <A>edges</A> is  a list whose entries are lists of length 2, consisting of
#! the two (possibly equal) vertices of the edges. If two edges are either
#! equal or one is the reversed of the other, the graph created will still
#! only have a single undirected edge. The graph created is on
#! the vertices  <A>1, .., nr, </A> where <A>nr</A> is the maximal entry
#! occurring in one of the edges. If the function is called with a second
#! argument <A>nr</A> then <A>nr</A> must be a positive integer which is at
#! least equal to the maximal entry occurring in one of the edges. 
#!
#!
#! @BeginExampleSession
#! gap> ng := NautyGraph( [ [1,2], [2,3], [3,4], [4,1], [3,2] ] );
#! <A Nauty graph with on 4 vertices>
#! gap> EdgesOfNautyGraph(ng);       
#! [ [ 1, 2 ], [ 1, 4 ], [ 2, 3 ], [ 3, 4 ] ]
#! @EndExampleSession
#!
#! @Returns a <K>NautyGraph</K>
#! @Arguments  list
#! @Arguments  list integer
DeclareOperation( "NautyGraph", [ IsList ] );
DeclareOperation( "NautyGraph", [ IsList, IsInt ] );
#! @EndGroup

#! @BeginGroup NautyDiGraph
#! @Description
#! This function creates a nauty graph object for a directed graph without
#! multiple edges, but possibly with loops, whose edges are given by the
#! list <A>edges</A>. The list
#! <A>edges</A> is  a list whose entries are lists of length 2, consisting of
#! the two (possibly equal) vertices of the edges. If two edges are
#! equal the graph created will still
#! only have a single directed edge. The graph created is on
#! the vertices  <A>1, .., nr, </A> where <A>nr</A> is the maximal entry
#! occurring in one of the edges. If the function is called with a second
#! argument <A>nr</A> then <A>nr</A> must be a positive integer which is at
#! least equal to the maximal entry occurring in one of the edges. 
#!
#!
#! @BeginExampleSession
#! gap> nautygraph := NautyDiGraph( [ [1,2],[2,3],[3,4], [4,1] ] );
#! <A Nauty graph>
#! gap> AutomorphismGroup(nautygraph);
#! Group([ (1,2,3,4) ])
#! @EndExampleSession
#!
#! @Returns a <K>NautyGraph</K>
#! @Arguments  list
#! @Arguments  list integer
DeclareOperation( "NautyDiGraph", [ IsList ] );
DeclareOperation( "NautyDiGraph", [ IsList, IsInt ] );
#! @EndGroup

#! @BeginGroup NautyColoredGraph
#! @Description
#! This function creates a nauty graph object for an undirected
#! vertex coloured graph without
#! multiple edges, but possibly with loops, whose edges are given by the
#! list <A>edges</A>. The list
#! <A>edges</A> is  a list whose entries are lists of length 2, consisting of
#! the two (possibly equal) vertices of the edges. If two edges are
#! equal or reversed to each other the graph created will still
#! only have a single undirected edge. The graph created is on
#! the vertices  <A>1, .., nr, </A> where <A>nr</A> is the maximal entry
#! occurring in one of the edges.  The list <A>colours</A> must be a
#! list of length <A>nr</A> whose entries are positive integers. The
#! vertex <A>i</A> has colour  <A>colours[i]</A>.
#!
#!
#! @BeginExampleSession
#! gap> nautygraph := NautyColoredGraph( [ [1,2],[2,3],[3,4], [4,1] ], [1,2,1,2] );
#! <A Nauty graph with on 4 vertices>
#! gap> AutomorphismGroup(nautygraph);
#! Group([ (2,4), (1,3) ])
#! @EndExampleSession
#!
#! @Returns a <K>NautyGraph</K>
#! @Arguments  list
#! @Arguments  list integer
DeclareOperation( "NautyColoredGraph", [ IsList, IsList ] );
DeclareOperation( "NautyColoredDiGraph", [ IsList, IsList ] );
#! @EndGroup


#! TODO: document this
DeclareOperation( "NautyEdgeColoredGraph", [ IsList ] );
DeclareOperation( "NautyEdgeColoredGraph", [ IsList, IsInt ] );

DeclareGlobalFunction( "CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES" );
DeclareGlobalFunction( "CALL_NAUTY_ON_EDGE_COLORED_GRAPH" );
