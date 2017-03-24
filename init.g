#
# NautyInterface: An interface to nauty
#
# Reading the declaration part of the package.
#
_PATH_SO:=Filename(DirectoriesPackagePrograms("NautyInterface"), "NautyInterface.so");
if _PATH_SO <> fail then
    LoadDynamicModule(_PATH_SO);
fi;
Unbind(_PATH_SO);

ReadPackage( "NautyInterface", "gap/NautyInterface.gd");
