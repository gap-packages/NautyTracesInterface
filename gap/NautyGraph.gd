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
#! Given a simple, undirected graph <A>graph</A> which is a
#! <A>nauty graph</A> object (see
#!  <Ref Sect="Section_NautyGraph"/>), this function computes the
#! automorphism group of <A>graph</A> as a permutation group on the
#! vertices of <A>graph</A>. As <A>graph</A> is a simple, undirected
#! graph, its edges are given as 2-subsets of the vertex set $V$ of
#! <A>graph</A>. A bijection $\phi$ from $V$ to itself
#!  is called an <A>automorphism</A> of the
#! (undirected) graph <A>graph</A> if $\phi$ maps edges of <A>graph</A>
#! to edges of <A>graph</A>.
#! The <A>automorphism group</A> of <A>graph</A> is returned as a
#! permutation group acting on the set $V$.
#!
#! @BeginExampleSession
#! gap> nautygraph := NautyGraph( [ [1,2],[2,3],[3,4], [4,1] ] );
#! <A Nauty graph>
#! gap> AutomorphismGroup(nautygraph);
#! Group([ (2,4), (1,2)(3,4) ])
#! @EndExampleSession
#!
#! @Returns a permutation group
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

#! TODO: document this
DeclareOperation( "IsomorphismGraphs", [ IsNautyGraph, IsNautyGraph ] );

#! TODO: document this
DeclareOperation( "IsomorphicGraphs", [ IsNautyGraph, IsNautyGraph ] );


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
#! @Returns a nauty graph object
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
#! @Returns a nauty graph object
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
#! @Returns a nauty graph object
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
