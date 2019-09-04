gap> edg := [[1,2],[2,3],[1,3]];;
gap> naut := NautyGraphFromEdges( edg );
[ [ 1, 2, 1 ], [ 2, 3, 3 ] ]
gap> NautyDense( naut[1], naut[2], 3, false, [[1,2,3], [0,1,0]] );
[ [ (2,3) ], () ]
