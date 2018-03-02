#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017, Sebastian Gutsche, Universität Siegen
##                  Alice Niemeyer,    RWTH Aachen
##                  Pascal Schweitzer, RWTH Aachen
##
#############################################################################

DeclareCategory( "IsNautyGraphWithNodeLabels",
                 IsNautyGraph );

DeclareAttribute( "NodeLabeling", IsNautyGraphWithNodeLabels );
DeclareAttribute( "UnderlyingNautyGraph", IsNautyGraphWithNodeLabels );


## Constructors
#! @BeginGroup
#! @Description
#! Construct a nauty (di)graph with optional vertex coloring.
#!
#! Arguments:
#! * labeling: dense list of positive integers (positions are the nodes
#!      of the underlying nauty graph, entries are node labels)
#! * edges: dense list of edges, encoded as pairs of node labels
#! * coloring (optional): dense list of colors (positive integers), 
#!      indexed by the nodes of the underlying nauty graph
#! 
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
