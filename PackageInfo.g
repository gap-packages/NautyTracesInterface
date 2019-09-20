#
# NautyTracesInterface: An interface to nauty
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "NautyTracesInterface",
Subtitle := "An interface to nauty",
Version := "0.2",
Date := "01/03/2018", # dd/mm/yyyy format

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Sebastian",
    LastName := "Gutsche",
    WWWHome := "https://sebasguts.github.io",
    Email := "gutsche@mathematik.uni-siegen.de",
    PostalAddress := "TODO",
    Place := "Siegen",
    Institution := "University of Siegen",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Alice",
    LastName := "Niemeyer",
    WWWHome := "http://www.maths.uwa.edu.au/~alice/",
    Email := "alice@maths.uwa.edu.au",
    PostalAddress := "TODO",
    Place := "Aachen",
    Institution := "RWTH Aachen University",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Pascal",
    LastName := "Schweitzer",
    WWWHome := "https://lii.rwth-aachen.de/~schweitzer",
    Email := "schweitzer@informatik.rwth-aachen.de",
    PostalAddress := Concatenation( [
                      "Pascal Schweitzer\n",
                      "RWTH Aachen\n",
                      "Lehrstuhl für Informatik 7\n",
                      "52056 Aachen" ] ),
    Place := "Aachen",
    Institution := "RWTH Aachen University",
  ),
],

PackageWWWHome := "http://TODO/",

ArchiveURL     := Concatenation( ~.PackageWWWHome, "NautyTracesInterface-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "NautyTracesInterface",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "An interface to nauty",
),

Dependencies := rec(
  GAP := ">= 4.9",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
      local so_file;
      so_file := Filename(DirectoriesPackagePrograms("NautyTracesInterface"),
                              "NautyTracesInterface.so");
      if (not "NautyTracesInterface" in SHOW_STAT()) and so_file = fail then
         LogPackageLoadingMessage(PACKAGE_WARNING,
                                  ["the kernel module is not compiled, ", 
                                   "the package cannot be loaded."] );
         return fail;
      fi;
      return true;
    end,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


