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

DeclareGlobalFunction( "NautyColorData" );

DeclareGlobalFunction( "NautyGraphDataForColoredEdges" );

DeclareGlobalFunction( "NautyGraphDataForColoredEdges2" );
