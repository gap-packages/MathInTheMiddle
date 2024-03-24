#
# MathInTheMiddle: Math-in-the-Middle functionality for GAP
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "MathInTheMiddle",
Subtitle := "Math-in-the-Middle functionality for GAP",
Version := "0.2",
Date := "05/10/2018", # dd/mm/yyyy format
License := "BSD-3-Clause",

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Markus",
    LastName := "Pfeiffer",
    WWWHome := "https://markusp.morphism.de/",
    Email := "markus.pfeiffer@st-andrews.ac.uk",
    PostalAddress := Concatenation(
               "School of Computer Science\n",
               "University of St Andrews\n",
               "Jack Cole Building, North Haugh\n",
               "St Andrews, Fife, KY16 9SX\n",
               "United Kingdom" ),
    Place := "St Andrews",
    Institution := "University of St Andrews",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Michael",
    LastName := "Torpey",
    WWWHome := "http://www-groups.mcs.st-andrews.ac.uk/~mct25/",
    Email := "mct25@st-andrews.ac.uk",
    PostalAddress := Concatenation(
               "School of Computer Science\n",
               "University of St Andrews\n",
               "Jack Cole Building, North Haugh\n",
               "St Andrews, Fife, KY16 9SX\n",
               "United Kingdom" ),
    Place := "St Andrews",
    Institution := "University of St Andrews",
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/gap-packages/", ~.PackageName ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
#SupportEmail   := "TODO",
PackageWWWHome  := "https://gap-packages.github.io/MathInTheMiddle/",
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),

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
  BookName  := "MathInTheMiddle",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Math-in-the-Middle functionality for GAP",
),

Dependencies := rec(
  GAP := ">= 4.10",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ]
                         , [ "json", ">= 1.1.0"]
                         , [ "io", ">= 4.5.0" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


