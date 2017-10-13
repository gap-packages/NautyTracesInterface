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
DeclareOperation( "NautyGraphWithNodeLabels", [ IsList, IsList ] );
DeclareOperation( "NautyDiGraphWithNodeLabels", [ IsList, IsList ] );
DeclareOperation( "NautyColoredGraphWithNodeLabels", [ IsList, IsList, IsList ] );
DeclareOperation( "NautyColoredDiGraphWithNodeLabels", [ IsList, IsList, IsList ] );
