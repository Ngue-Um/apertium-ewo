###############################################################################
## Makefile for apertium-ewo
###############################################################################

LANG1=ewo
BASENAME=apertium-$(LANG1)

TARGETS_COMMON =			\
	$(LANG1).automorf.hfst		\
	$(LANG1).automorf.bin		\
	$(LANG1).automorf.att.gz	\
	$(LANG1).autogen.hfst		\
	$(LANG1).autogen.bin		\
	$(LANG1).autogen.att.gz		\
	$(LANG1).autoseg.hfst		\
	$(LANG1).autoseg.bin		\
	$(LANG1).rlx.bin

##	$(LANG1).autophon.hfst		
##	$(LANG1).prob		

TARGETS_INTERMEDIATE = $(LANG1).mor.hfst $(LANG1).seg.hfst $(LANG1).gen.hfst

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################

ewo.automorf.hfst: ewo.mor.hfst ewo.spellrelax.hfst
	hfst-invert $< |  hfst-compose -F -1 - -2 ewo.spellrelax.hfst  | hfst-invert | hfst-fst2fst -w -o $@

ewo.autogen.hfst: ewo.gen.hfst
	hfst-fst2fst -w $< -o $@

ewo.autoseg.hfst: ewo.seg.hfst 
	hfst-fst2fst -w $< -o $@

ewo.mor.hfst: ewo.gen.hfst ewo.mor.twol.hfst
	hfst-compose-intersect -1 ewo.gen.hfst -2 ewo.mor.twol.hfst | hfst-realign | hfst-invert -o $@

# <impf><o_pl1><s_pl3>tʼis<v><tv>+o<mark>:k>oj>ki>tʼis>o
ewo.gen.hfst: ewo.lexc.hfst ewo.twol.hfst
	hfst-compose-intersect -1 ewo.lexc.hfst -2 ewo.twol.hfst | hfst-realign -o $@

ewo.twol.hfst: apertium-ewo.ewo.twol
	hfst-twolc $< -o $@

# <impf><o_pl1><s_pl3>tʼis<v><tv>+o<mark>:k>{o}j>k{i}>tʼis>o
ewo.lexc.hfst: apertium-ewo.ewo.lexc
	hfst-lexc -A --Werror $< -o $@

ewo.mor.twol.hfst: apertium-ewo.ewo.mor.twol
	hfst-twolc apertium-ewo.ewo.mor.twol -o ewo.mor.twol.hfst

# kojkitʼiso:k>oj>ki>tʼis>o
ewo.seg.hfst: ewo.mor.hfst ewo.gen.hfst
	hfst-compose -F -1 ewo.mor.hfst -2 ewo.gen.hfst -o ewo.seg.hfst 

ewo.phon.hfst: apertium-ewo.ewo.phon
	hfst-regexp2fst -S apertium-ewo.ewo.phon | hfst-repeat -o ewo.phon.hfst

ewo.autophon.hfst: ewo.mor.hfst ewo.phon.hfst
	hfst-fst2fst -w ewo.phon.hfst -o ewo.autophon.hfst
#	hfst-project -p upper ewo.mor.hfst | hfst-compose -1 - -2 ewo.phon.hfst | hfst-fst2fst -w -o ewo.autophon.hfst

ewo.spellrelax.hfst: apertium-ewo.ewo.spellrelax 
	hfst-regexp2fst -S -o $@ < $<

ewo.rlx.bin: apertium-ewo.ewo.rlx
	cg-comp $< $@

$(LANG1).autogen.att.gz: $(LANG1).gen.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).automorf.att.gz: $(LANG1).mor.hfst ewo.spellrelax.hfst
	hfst-invert $< |  hfst-compose -F -1 - -2 ewo.spellrelax.hfst  | hfst-invert | hfst-fst2txt | gzip -9 -c > $@

$(LANG1).autoseg.att.gz: $(LANG1).seg.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).autogen.bin: $(LANG1).autogen.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autogen.att
	lt-comp lr .deps/$(LANG1).autogen.att $@

$(LANG1).automorf.bin: $(LANG1).automorf.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).automorf.att
	lt-comp lr .deps/$(LANG1).automorf.att $@

$(LANG1).autoseg.bin: $(LANG1).autoseg.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autoseg.att
	lt-comp lr .deps/$(LANG1).autoseg.att $@

$(LANG1).prob: $(BASENAME).$(LANG1).tagged
	apertium-tagger -s 0 -u 2 $@ $<

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(LANG1).lexc		\
		$(BASENAME).$(LANG1).twol	\
		$(BASENAME).$(LANG1).spellrelax \
		$(BASENAME).$(LANG1).rlx	\
		modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_ewo_dir: This is where the compiled binaries go
#   apertium_ewo_srcdir: This is where the source files go

apertium_ewodir=$(prefix)/share/apertium/$(BASENAME)/
apertium_ewo_srcdir=$(prefix)/share/apertium/$(BASENAME)/

EXTRA_TARGETS=

if HAVE_HFSTOSPELL
EXTRA_TARGETS += $(LANG1).zhfst
endif # HAVE_HFSTOSPELL

apertium_ewo_DATA=$(TARGETS_COMMON) $(EXTRA_TARGETS) 

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
	$(INSTALL_DATA) $(BASENAME).$(LANG1).lexc $(DESTDIR)$(apertium_ewo_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).twol $(DESTDIR)$(apertium_ewo_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).rlx $(DESTDIR)$(apertium_ewo_srcdir)


###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON) $(TARGETS_INTERMEDIATE)
clean-local:
	-rm -rf .deps modes

###############################################################################
