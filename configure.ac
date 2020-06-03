#
# NautyTracesInterface: An interface to nauty
#
# This file is part of the build system of a GAP kernel extension.
# Requires GNU autoconf, GNU automake and GNU libtool.
#

dnl ##
dnl ## Setup autoconf
dnl ##
AC_PREREQ([2.68])
AC_INIT([NautyTracesInterface], [package])
AC_CONFIG_SRCDIR([src/NautyTracesInterface.c])
AC_CONFIG_MACRO_DIR([m4])
m4_include([m4/find_gap.m4])

dnl ##
dnl ## Set the language
dnl ##
AC_PROG_CC
AC_PROG_CC_STDC
AC_LANG([C])

dnl ##
dnl ## Locate the GAP root dir
dnl ##
FIND_GAP

AC_ARG_WITH([nauty],
    [AS_HELP_STRING([--with-nauty=<path>], [specify root of nauty directory])],
    [NAUTY="$with_nauty"],
    [NAUTY="$PWD/nauty27r1"]
)
NAUTY_CPPFLAGS="-I$NAUTY"
NAUTY_PATH="$NAUTY"
AC_SUBST(NAUTY_CPPFLAGS)
AC_SUBST(NAUTY_PATH)

dnl ##
dnl ## Output everything
dnl ##
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
