LoadPackage("NautyTracesInterface");
dirs := DirectoriesPackageLibrary("NautyTracesInterface", "tst");
TestDirectory(dirs, rec(exitGAP := true));
FORCE_QUIT_GAP(1);
