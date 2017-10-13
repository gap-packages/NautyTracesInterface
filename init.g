#
# NautyTracesInterface: An interface to nauty
#
# Reading the declaration part of the package.
#
_PATH_SO:=Filename(DirectoriesPackagePrograms("NautyTracesInterface"), "NautyTracesInterface.so");
if _PATH_SO <> fail then
    LoadDynamicModule(_PATH_SO);
fi;
Unbind(_PATH_SO);

ReadPackage( "NautyTracesInterface", "gap/NautyTracesInterface.gd");

ReadPackage( "NautyTracesInterface", "gap/NautyGraph.gd");

ReadPackage( "NautyTracesInterface", "gap/NautyGraphWithNodeLabels.gd" );
