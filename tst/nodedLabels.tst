gap> ng :=  NautyDiGraphWithNodeLabels( [[1,8],[1,12],[7,1],[1,5], [5,5] , [8,7]], [7,12,5,1,8]);
<A directed Nauty graph on 5 vertices>
gap> Display(ng);                         
Nauty Graph (directed)
Vertices (5): [ 1, 5, 7, 8, 12 ]
Vertex labels :[ 7, 12, 5, 1, 8 ]
Edges (6): [ [ 1, 8 ], [ 1, 12 ], [ 7, 1 ], [ 1, 5 ], [ 5, 5 ], [ 8, 7 ] ]
gap> CanonicalLabeling(ng);
(1,7,12,5,8)
gap> ng :=  NautyGraphWithNodeLabels( [[1,8],[1,12],[7,1],[1,5], [5,5] , [8,7]], [7,12,5,1,8]);  
<An undirected Nauty graph with on 5 vertices>
gap> Display(ng);
Nauty Graph (undirected)
Vertices (5): [ 1, 5, 7, 8, 12 ]
Vertex labels :[ 7, 12, 5, 1, 8 ]
Edges (6): [ [ 1, 8 ], [ 1, 12 ], [ 7, 1 ], [ 1, 5 ], [ 5, 5 ], [ 8, 7 ] ]
gap> CanonicalLabeling(ng);
(1,5,8)(7,12)
gap> ng :=  NautyColoredDiGraphWithNodeLabels( [[1,8],[1,12],[7,1],[1,5], [5,5] , [8,7]],  [0,0,1,1,1], [7,12,5,1,8]); 
<A directed vertex-coloured Nauty graph on 5 vertices>
gap> Display(ng);
Nauty Graph (directed vertex-coloured)
Vertices (5) by colours: 
 (0):  [ 1,5]
 (1):  [ 7,8,12]
Vertex labels :[ 7, 12, 5, 1, 8 ]
Edges (6): [ [ 1, 8 ], [ 1, 12 ], [ 7, 1 ], [ 1, 5 ], [ 5, 5 ], [ 8, 7 ] ]
gap> CanonicalLabeling(ng);
(1,8)(7,12)
gap> cn := CanonicalForm(ng);
<A directed vertex-coloured Nauty graph on 5 vertices>
gap> Display(cn);
Nauty Graph (directed vertex-coloured)
Vertices (5) by colours: 
 (0):  [ 1,2]
 (1):  [ 3,4,5]
Edges (6): [ [ 2, 5 ], [ 3, 3 ], [ 4, 2 ], [ 5, 1 ], [ 5, 3 ], [ 5, 4 ] ]
gap> ng :=  NautyColoredGraphWithNodeLabels( [[1,8],[1,12],[7,1],[1,5], [5,5] , [8,7]],  [0,0,1,1,1], [7,12,5,1,8]);  
<An  undirected vertex-coloured Nauty graph on 5 vertices>
gap> Display(ng);
Nauty Graph (undirected vertex-coloured)
Vertices (5) by colours: 
 (0):  [ 1,5]
 (1):  [ 7,8,12]
Vertex labels :[ 7, 12, 5, 1, 8 ]
Edges (6): [ [ 1, 8 ], [ 1, 12 ], [ 7, 1 ], [ 1, 5 ], [ 5, 5 ], [ 8, 7 ] ]
gap> cn := CanonicalForm(ng);
<An  undirected vertex-coloured Nauty graph on 5 vertices>
gap> Display(cn);
Nauty Graph (undirected vertex-coloured)
Vertices (5) by colours: 
 (0):  [ 1,2]
 (1):  [ 3,4,5]
Edges (6): [ [ 1, 4 ], [ 1, 5 ], [ 2, 5 ], [ 3, 3 ], [ 3, 5 ], [ 4, 5 ] ]
gap> CanonicalLabeling(ng);
(1,8)

