#############################################################################
##
##                                NautyTracesInterface package
##
##  Copyright 2017, Sebastian Gutsche, Universität Siegen
##                  Alice Niemeyer,    RWTH Aachen
##                  Pascal Schweitzer, RWTH Aachen
##
#############################################################################

DeclareCategory( "IsNautyInternalGraphObject", IsObject );

NautyInternalFamily := NewFamily( "NautyInternalFamily" );

BindGlobal("TheTypeNautyInternalGraphObject", NewType( NautyInternalFamily, IsNautyInternalGraphObject ));

DeclareGlobalFunction( "NautyGraphFromEdges" );

DeclareGlobalFunction( "NautyColorData" );

DeclareGlobalFunction( "NautyGraphDataForColoredEdges" );

DeclareGlobalFunction( "NautyGraphDataForColoredEdges2" );
