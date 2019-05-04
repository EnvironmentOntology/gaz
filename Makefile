SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
.SECONDARY:

TODAY = $(shell date +%Y-%m-%d)
OBO = http://purl.obolibrary.org/obo/

# Directories
IMPORTS = src/ontology/imports
SUBSETS = src/ontology/subsets

# ------------------------------ PREREQS ------------------------------

ROBOT = java -jar build/robot.jar

build:
	mkdir -p $@

build/robot.jar: build
	curl -Lk https://github.com/ontodev/robot/releases/download/v1.4.0/robot.jar > $@

# ------------------------------ GAZ ------------------------------

#COUNTRIES = $(shell find $(SUBSETS)/countries -name \*.owl -print)

# Do not use this to create GAZ
# We are still working on how to use modules to build GAZ
#gaz: gaz.owl
#gaz.owl: $(COUNTRIES)
#	$(eval INPUTS := $(foreach I,$(COUNTRIES), --input $(I)))
#	robot merge --input src/ontology/gaz-min.owl $(INPUTS) \
#	annotate --ontology-iri $(OBO)$@ --version-iri $(OBO)gaz/$(TODAY)/$@ --output $@

# ------------------------------ IMPORTS ------------------------------

imports: $(IMPORTS)/ro_import.owl $(IMPORTS)/envo_import.owl

$(IMPORTS)/ro_import.owl: $(IMPORTS)/ro_terms.txt | build/robot.jar
	$(ROBOT) extract --input-iri $(OBO)ro.owl\
	 --method MIREOT --lower-terms $< --intermediates minimal \
	annotate --ontology-iri $(OBO)$@ --output $@

$(IMPORTS)/envo_import.owl: $(IMPORTS)/envo_terms.txt | build/robot.jar
	$(ROBOT) merge --input-iri $(OBO)envo.owl \
	extract --method MIREOT --lower-terms $< --intermediates minimal \
	remove --term BFO:0000004 \
	annotate --ontology-iri $(OBO)$@ --output $@
