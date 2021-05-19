#
# NautyTracesInterface: An interface to nauty
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", ">= 2019.04.10") then
    Error("AutoDoc 2019.04.10 or newer is required");
fi;

AutoDoc(rec(scaffold := true, autodoc := true));

QUIT;
