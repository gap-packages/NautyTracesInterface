LoadPackage( "NautyInterface" );
LoadPackage( "Grape" );
LoadPackage( "Digraph" );
Petersen := Graph( SymmetricGroup(5), [[1,2]], OnSets,
                   function(x,y) return Intersection(x,y)=[]; end );
Petersen := Digraph( Petersen );
edg := DigraphEdges( Petersen );
pet_source := List( edg, i -> i[1] );
pet_range := List( edg, i -> i[2] );
NautyDense( pet_source, pet_range, 10 );
