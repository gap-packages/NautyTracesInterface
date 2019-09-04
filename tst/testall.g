LoadPackage("NautyTracesInterface");
LoadPackage("Grape");
LoadPackage("Digraph");

dirs := DirectoriesPackageLibrary("NautyTracesInterface", "tst");
TestDirectory(dirs, rec(exitGAP := true));
FORCE_QUIT_GAP(1);
