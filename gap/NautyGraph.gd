#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017-2018, Sebastian Gutsche, Universität Siegen
##
#############################################################################

DeclareCategory( "IsNautyGraph",
                 IsObject );

DeclareProperty( "IsDirected", IsNautyGraph );
DeclareProperty( "IsColored", IsNautyGraph );

#! TODO: document this
DeclareAttribute( "AutomorphismGroup", IsNautyGraph );

#! TODO: document this
DeclareAttribute( "AutomorphismGroupGenerators", IsNautyGraph );

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

#! TODO: document this
DeclareOperation( "NautyGraph", [ IsList ] );
DeclareOperation( "NautyGraph", [ IsList, IsInt ] );

#! TODO: document this
DeclareOperation( "NautyDiGraph", [ IsList ] );
DeclareOperation( "NautyDiGraph", [ IsList, IsInt ] );

#! TODO: document this
DeclareOperation( "NautyColoredGraph", [ IsList, IsList ] );
DeclareOperation( "NautyColoredDiGraph", [ IsList, IsList ] );

#! TODO: document this
DeclareOperation( "NautyEdgeColoredGraph", [ IsList ] );
DeclareOperation( "NautyEdgeColoredGraph", [ IsList, IsInt ] );

DeclareGlobalFunction( "CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES" );
DeclareGlobalFunction( "CALL_NAUTY_ON_EDGE_COLORED_GRAPH" );
