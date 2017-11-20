#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017, Sebastian Gutsche, Universität Siegen
##                  Alice Niemeyer,    RWTH Aachen
##                  Pascal Schweitzer, RWTH Aachen
##
#############################################################################

BindGlobal( "__NAUTYTRACESINTERFACE_GLOBAL_AUTOMORPHISM_GROUP_LIST", true );
MakeReadWriteGlobal( "__NAUTYTRACESINTERFACE_GLOBAL_AUTOMORPHISM_GROUP_LIST" );

DeclareGlobalFunction( "NautyGraphFromEdges" );

DeclareGlobalFunction( "NautyColorData" );

DeclareGlobalFunction( "NautyGraphDataForColoredEdges" );

DeclareGlobalFunction( "NautyGraphDataForColoredEdges2" );
