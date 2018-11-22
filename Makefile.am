#
# NautyTracesInterface: An interface to nauty
#
# This file is part of the build system of a GAP kernel extension.
# Requires automake.
#
ACLOCAL_AMFLAGS = -I m4

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(abs_top_srcdir)/$(BINARCHDIR)/NautyTracesInterface.so

lib_LTLIBRARIES = NautyTracesInterface.la

NautyTracesInterface_la_SOURCES = src/NautyTracesInterface.c
NautyTracesInterface_la_CPPFLAGS = $(GAP_CPPFLAGS) $(NAUTY_CPPFLAGS)
NautyTracesInterface_la_CPLAGS = $(GAP_CFLAGS)
NautyTracesInterface_la_LDFLAGS = $(GAP_LDFLAGS)
NautyTracesInterface_la_LDFLAGS += $(NAUTY_PATH)/nauty.o
NautyTracesInterface_la_LDFLAGS += $(NAUTY_PATH)/nautil.o
NautyTracesInterface_la_LDFLAGS += $(NAUTY_PATH)/naugraph.o
NautyTracesInterface_la_LDFLAGS += $(NAUTY_PATH)/schreier.o
NautyTracesInterface_la_LDFLAGS += $(NAUTY_PATH)/naurng.o
NautyTracesInterface_la_LDFLAGS += $(NAUTY_PATH)/naugroup.o
NautyTracesInterface_la_LDFLAGS += $(NAUTY_PATH)/nautinv.o
NautyTracesInterface_la_LDFLAGS += -module -avoid-version
if SYS_IS_CYGWIN
NautyTracesInterface_la_LDFLAGS += -no-undefined -version-info 0:0:0 -Wl,$(GAPROOT)/bin/$(GAPARCH)/gap.dll
endif

all-local: NautyTracesInterface.la
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
if SYS_IS_CYGWIN
	cp .libs/NautyTracesInterface.dll $(GAPINSTALLLIB)
else
	cp .libs/NautyTracesInterface.so $(GAPINSTALLLIB)
endif
	@echo "SUCCESS!"

distclean-local:
	rm -rf bin/*
	(cd doc ; ./clean)

doc: doc/manual.six

doc/manual.six: doc/*.xml PackageInfo.g
	($(GAPROOT)/bin/gap.sh -A makedoc.g)
