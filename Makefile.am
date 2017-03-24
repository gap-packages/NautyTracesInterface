#
# NautyInterface: An interface to nauty
#
# This file is part of the build system of a GAP kernel extension.
# Requires automake.
#
ACLOCAL_AMFLAGS = -I m4

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(abs_top_srcdir)/$(BINARCHDIR)/NautyInterface.so

lib_LTLIBRARIES = NautyInterface.la

NautyInterface_la_SOURCES = src/NautyInterface.c
NautyInterface_la_CPPFLAGS = $(GAP_CPPFLAGS) -DCONFIG_H
# Note that the latter is only for GAP 4.4.12
NautyInterface_la_LDFLAGS = nauty26r7/nauty.o nauty26r7/nautil.o nauty26r7/naugraph.o nauty26r7/schreier.o nauty26r7/naurng.o nauty26r7/naugroup.o -module -avoid-version
if SYS_IS_CYGWIN
NautyInterface_la_LDFLAGS += -no-undefined -version-info 0:0:0 -Wl,$(GAPROOT)/bin/$(GAPARCH)/gap.dll
endif

all-local: NautyInterface.la
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
if SYS_IS_CYGWIN
	cp .libs/NautyInterface.dll $(GAPINSTALLLIB)
else
	cp .libs/NautyInterface.so $(GAPINSTALLLIB)
endif
	@echo "SUCCESS!"

distclean-local:
	rm -rf bin/*
	(cd doc ; ./clean)

doc: doc/manual.six

doc/manual.six: doc/*.xml PackageInfo.g
	($(GAPROOT)/bin/gap.sh -A makedoc.g)
