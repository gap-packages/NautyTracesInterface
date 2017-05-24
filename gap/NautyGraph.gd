#############################################################################
##
##                                NautyInterface package
##
##  Copyright 2017, Sebastian Gutsche, Universität Siegen
##                  Alice Niemeyer,    RWTH Aachen
##                  Pascal Schweitzer, RWTH Aachen
##
#############################################################################

DeclareCategory( "IsNautyGraph",
                 IsObject );

DeclareProperty( "IsDirected", IsNautyGraph );
DeclareProperty( "IsColored", IsNautyGraph );

DeclareAttribute( "AutomorphismGroup", IsNautyGraph );
DeclareAttribute( "AutomorphismGroupGenerators", IsNautyGraph );
DeclareAttribute( "CanonicalLabeling", IsNautyGraph );

## Constructors
DeclareGlobalFunction( "CREATE_NAUTY_GRAPH_OBJECT" );
DeclareOperation( "NautyGraph", [ IsList ] );
DeclareOperation( "NautyGraph", [ IsList, IsInt ] );
DeclareOperation( "NautyDiGraph", [ IsList ] );
DeclareOperation( "NautyDiGraph", [ IsList, IsInt ] );
DeclareOperation( "NautyColoredGraph", [ IsList, IsList ] );
DeclareOperation( "NautyColoredDiGraph", [ IsList, IsList ] );

DeclareGlobalFunction( "CALL_NAUTY_ON_GRAPH_AND_SET_PROPERTIES" );
