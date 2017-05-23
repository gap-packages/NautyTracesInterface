LoadPackage( "NautyInterface" );

edg := [[1,2],[2,3],[1,3]];

naut := NautyGraphFromEdges( edg );

NautyDense( naut[1], naut[2], 3, false, [[1,2,3], [0,1,0]] );
