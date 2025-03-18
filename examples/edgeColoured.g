g1 := NautyEdgeColoredGraph( [[[1,2],[3,10],[11,12],[4,9],[5,6],[7,8]],[[1,12],[2,3],[10,11],[4,5],[6,7],[8,9]],[[3,4],[9,10]]],12);
g2 := NautyEdgeColoredGraph( [[[3,11],[9,10],[4,7],[1,2],[5,12],[6,8]],[[7,11],[4,10],[3,9],[1,5],[2,8],[6,12]],[[5,9],[10,12]]],12);

IsomorphismGraphs(g1,g2);

Assert(0, IsomorphismGraphs(g1,g2) = (1,2)(3,5)(4,9,10,12,8)(6,11), "Edge-coloured isomorphism fails");
