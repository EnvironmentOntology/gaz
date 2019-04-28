SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
.SECONDARY:

TODAY = $(shell date +%Y-%m-%d)
OBO = http://purl.obolibrary.org/obo/

COUNTRIES = $(shell find subsets/countries -name \*.owl -print)

gaz: gaz.owl
gaz.owl: $(COUNTRIES)
	$(eval INPUTS := $(foreach I,$(COUNTRIES), --input $(I)))
	robot merge --input gaz-min.owl $(INPUTS) \
	annotate --ontology-iri $(OBO)$@ --version-iri $(OBO)gaz/$(TODAY)/$@ --output $@

imports: imports/*.owl

imports/ro_import.owl: imports/ro_terms.txt
	robot extract --input-iri http://purl.obolibrary.org/obo/ro.owl\
	 --method MIREOT --lower-terms $< --intermediates minimal \
	annotate --ontology-iri $(OBO)$@ --output $@

imports/envo_import.owl: imports/envo_terms.txt
	robot merge --input-iri http://purl.obolibrary.org/obo/envo.owl \
	extract --method MIREOT --lower-terms $< --intermediates minimal \
	remove --term BFO:0000004 \
	annotate --ontology-iri $(OBO)$@ --output $@
