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

DeclareAttribute( "AutomorphismGroup", IsNautyGraph );
DeclareAttribute( "AutomorphismGroupGenerators", IsNautyGraph );
DeclareAttribute( "CanonicalLabeling", IsNautyGraph );
DeclareAttribute( "CanonicalLabelingInverse", IsNautyGraph );
DeclareAttribute( "CanonicalForm", IsNautyGraph );

DeclareOperation( "IsomorphismGraphs", [ IsNautyGraph, IsNautyGraph ] );
DeclareOperation( "IsomorphicGraphs", [ IsNautyGraph, IsNautyGraph ] );


## Constructors
DeclareGlobalFunction( "CREATE_NAUTY_GRAPH_OBJECT" );
DeclareGlobalFunction( "CREATE_NAUTY_EDGE_COLORED_GRAPH" );
DeclareOperation( "NautyGraph", [ IsList ] );
DeclareOperation( "NautyGraph", [ IsList, IsInt ] );
DeclareOperation( "NautyDiGraph", [ IsList ] );
DeclareOperation( "NautyDiGraph", [ IsList, IsInt ] );
DeclareOperation( "NautyColoredGraph", [ IsList, IsList ] );
DeclareOperation( "NautyColoredDiGraph", [ IsList, IsList ] );

DeclareOperation( "NautyEdgeColoredGraph", [ IsList ] );
DeclareOperation( "NautyEdgeColoredGraph", [ IsList, IsInt ] );

DeclareGlobalFunction( "CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES" );
DeclareGlobalFunction( "CALL_NAUTY_ON_EDGE_COLORED_GRAPH" );
