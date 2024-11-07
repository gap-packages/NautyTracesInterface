#
# NautyTracesInterface: An interface to nauty
#
# Reading the declaration part of the package.
#
ReadPackage( "NautyTracesInterface", "gap/NautyTracesInterface.gd");

if not LoadKernelExtension("NautyTracesInterface") then
  Error("failed to load the NautyTracesInterface package kernel extension");
fi;

ReadPackage( "NautyTracesInterface", "gap/NautyGraph.gd");

ReadPackage( "NautyTracesInterface", "gap/NautyGraphWithNodeLabels.gd" );
