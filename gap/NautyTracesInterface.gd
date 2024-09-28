#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017-2018, Sebastian Gutsche, Universität Siegen
##
#############################################################################

#! @Chapter Nauty Traces Interface
#! @Section  Data Structures
#! @SectionLabel Nauty_Interface

DeclareCategory( "IsNautyInternalGraphObject", IsObject );

NautyInternalFamily := NewFamily( "NautyInternalFamily" );

BindGlobal("TheTypeNautyInternalGraphObject", NewType( NautyInternalFamily, IsNautyInternalGraphObject ));

#! @BeginGroup NautyGraphFromEdges
#! @Description
#! This function takes as input a list
#! <A>edges</A>  whose entries are lists of length 2, consisting of
#! the two (possibly equal) vertices of the edges. It returns
#! two lists, the first is a list of vertices (source vertices)
#! where an edge originates and the second a list of corresponding vertices
#! (range vertices) where an edge terminates.
#! Note that when the grap is undirected, the source vertex will always
#! be less than or equal to the range.
#!
#! @BeginExampleSession
#! gap> ng := NautyGraph( [ [1,2], [2,3], [3,4], [4,1], [3,2] ]);    
#! <A Nauty graph with on 4 vertices>
#! gap> NautyGraphFromEdges( EdgesOfNautyGraph(ng));
#! [ [ 1, 1, 2, 3 ], [ 2, 4, 3, 4 ] ]
#! gap> ng := NautyDiGraph( [ [1,2], [2,3], [3,4], [4,1], [3,2] ]);
#! <A directed Nauty graph on 4 vertices>
#! gap> NautyGraphFromEdges( EdgesOfNautyGraph(ng));               
#! [ [ 1, 2, 3, 3, 4 ], [ 2, 3, 2, 4, 1 ] ]
#! @EndExampleSession
#!
#! @Returns a nauty graph object
#! @Arguments  list
#! @Arguments  list integer
DeclareGlobalFunction( "NautyGraphFromEdges" );
#! @EndGroup


#! @BeginGroup NautyColorData
#! @Description
#! This function takes as input a list of colours, which are non-negative
#! integers. The list is interpreted as a map from the nodes of a graph
#! to the colour of the node. This function returns two lists, called
#! <A>node_list</A> and <A>color_list</A>. The list
#! <A>node_list</A> is a permutation of the nodes sorted by the colour
#! of the node as specified in the input. The second list
#! <A>color_list</A> contains only <M>0,1</M>. The two lists together encode
#! the colour partition of the nodes, namely the list  <A>color_list</A>
#! contains a <M>0</M> in position <M>i</M>,  if 
#! <A>node_list</A><M>[i]</M> and <A>node_list</A><M>[i+1]</M> have
#! different colours. Thus, if the first entry  <M>0</M> in
#! <A>color_list</A> occurs in position <M>j</M>, then the nodes stored
#! in <A>node_list</A><M>[k]</M> for <M>1 \le k \le j</M> all have colour
#! <A>list</A><M>[1]</M>.
#! @Returns two lists
#! @Arguments  list
DeclareGlobalFunction( "NautyColorData" );
#! @EndGroup

DeclareGlobalFunction( "NautyGraphDataForColoredEdges" );

DeclareGlobalFunction( "NautyGraphDataForColoredEdges2" );
