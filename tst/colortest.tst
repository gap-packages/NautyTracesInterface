gap> edg := [[1,2],[2,3],[1,3]];;
gap> naut := NautyGraphFromEdges( edg );
[ [ 1, 2, 1 ], [ 2, 3, 3 ] ]
gap> NautyDense( naut[1], naut[2], 3, false, [[1,2,3], [0,1,0]] );
[ [ (2,3) ], () ]
gap> g1 := NautyColoredGraph( [ [1,2], [2,3], [3,4], [4,1], [3,2], [1,5], [2,5], [4,5] ], [1,2,1,2,3] );    
<An  undirected vertex-coloured Nauty graph on 5 vertices>
gap> AutomorphismGroup(g1);
Group([ (2,4) ])
gap> g2 := NautyColoredGraph( [ [1,2], [2,3], [3,4], [4,1], [3,2], [1,5], [2,5], [4,5] ], [1,1,1,1,1] );
<An  undirected vertex-coloured Nauty graph on 5 vertices>
gap> AutomorphismGroup(g2);
Group([ (1,5), (2,4) ])
gap> g3 := NautyColoredDiGraph( [ [1,2], [2,3], [3,4], [4,1], [3,2], [1,5], [2,5], [4,5] ], [1,1,1,1,1] );
<A directed vertex-coloured Nauty graph on 5 vertices>
gap> AutomorphismGroup(g3);
Group(())
gap> c := CanonicalForm(g3);
<A directed vertex-coloured Nauty graph on 5 vertices>
gap> EdgesOfNautyGraph(c);
[ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 4, 1 ], [ 3, 2 ], [ 1, 5 ], [ 2, 5 ], [ 4, 5 ] ]
gap> IsomorphismGraphs(c,g3);
()
