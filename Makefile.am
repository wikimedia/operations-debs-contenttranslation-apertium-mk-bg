VERSION=0.2.0
LANG1=mk
LANG2=bg
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = $(PREFIX1).autopgen.bin $(PREFIX2).autopgen.bin \
	$(PREFIX1).automorf.bin $(PREFIX1).autobil.bin $(PREFIX1).autogen.bin \
	$(PREFIX2).automorf.bin $(PREFIX2).autobil.bin $(PREFIX2).autogen.bin \
	$(PREFIX1).t1x.bin $(PREFIX1).rlx.bin $(PREFIX2).rlx.bin \
	$(PREFIX2).t1x.bin $(PREFIX1).mode modes 

$(PREFIX2).autogen.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	lt-comp rl $(BASENAME).$(LANG1).dix $@

$(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp rl $(BASENAME).$(LANG2).dix $@

$(PREFIX1).automorf.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	lt-comp lr $(BASENAME).$(LANG1).dix $@ $(BASENAME).$(LANG1).acx

$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp lr $(BASENAME).$(LANG2).dix $@ $(BASENAME).$(LANG2).acx

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp lr $(BASENAME).$(PREFIX1).dix $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp rl $(BASENAME).$(PREFIX1).dix $@

$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG1).dix
	lt-comp lr $(BASENAME).post-$(LANG1).dix $@

$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG2).dix
	lt-comp lr $(BASENAME).post-$(LANG2).dix $@

$(PREFIX1).rlx.bin: $(BASENAME).$(PREFIX1).rlx
	cg-comp $(BASENAME).$(PREFIX1).rlx $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx
	cg-comp $(BASENAME).$(PREFIX2).rlx $@


$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

EXTRA_DIST=$(BASENAME).$(LANG1).dix $(BASENAME).$(PREFIX1).dix \
           $(BASENAME).$(LANG2).dix \
           $(PREFIX1).prob $(PREFIX2).prob \
           $(BASENAME).$(PREFIX1).t1x \
           $(BASENAME).$(PREFIX2).t1x \
           modes.xml

$(PREFIX1).mode: modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

$(PREFIX2).mode: modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

clean-dicts:
	touch $(BASENAME).$(LANG1).dix $(BASENAME).$(LANG2).dix $(BASENAME).$(PREFIX1).dix
	rm $(BASENAME).$(LANG1).dix

apertium_mk_bgmodesdir=$(prefix)/share/apertium/modes/
apertium_mk_bgdir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_mk_bg_DATA=$(PREFIX1).automorf.bin $(PREFIX2).automorf.bin \
                    $(PREFIX1).autobil.bin $(PREFIX2).autobil.bin \
                    $(PREFIX1).autogen.bin \
                    $(PREFIX2).autogen.bin \
                    $(PREFIX1).prob $(PREFIX2).prob \
		    $(PREFIX1).t1x.bin  \
		    $(PREFIX1).rlx.bin  \
		    $(PREFIX2).rlx.bin  \
		    $(PREFIX2).t1x.bin  \
		    $(BASENAME).$(PREFIX1).t1x \
		    $(BASENAME).$(PREFIX2).t1x \
		    $(PREFIX2).autopgen.bin \
		    $(PREFIX1).autopgen.bin \
		    $(PREFIX1).mode \
		    $(PREFIX2).mode

install-data-local:
	$(prefix)/bin/apertium-gen-modes modes.xml apertium-$(PREFIX1)
	test -d $(DESTDIR)$(apertium_mk_bgmodesdir) || mkdir $(DESTDIR)$(apertium_mk_bgmodesdir)
	$(INSTALL_DATA) $(PREFIX1).mode $(DESTDIR)$(apertium_mk_bgmodesdir)
	$(INSTALL_DATA) $(PREFIX2).mode $(DESTDIR)$(apertium_mk_bgmodesdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(BASENAME).$(PREFIX2).t1x $(DESTDIR)$(apertium_mk_bgdir)

CLEANFILES = -r $(TARGETS_COMMON) 
