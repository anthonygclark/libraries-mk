#!/usr/bin/make -f

-include $(CURDIR)/platforms/$(PLATFORM).mk

# Defaults
CC        ?= clang
CXX       ?= clang++
CFLAGS    ?= -Wall -pedantic -std=c11
CXXFLAGS  ?= -std=c++14
PKGCONFIG ?= scripts/pkg-config
PLATFORM  ?= $(shell uname -n)
LIBRARIES ?= libraries/srcs/*/

define uniq =
  $(eval seen :=)
  $(foreach _,$1,$(if $(filter $_,${seen}),,$(eval seen += $_)))
  ${seen}
endef

LIBS    := $(sort $(dir $(wildcard $(LIBRARIES))))
LIBS    := $(patsubst %/, %, $(LIBS))
# Library scripts
LIBS_S  := $(patsubst libraries/srcs/%,libraries/scripts/%.sh,$(LIBS))
# Library tokens
LIBS_T  := $(patsubst libraries/srcs/%,libraries/%.token-$(PLATFORM),$(LIBS))

CFLAGS  += -I libraries/install-root-$(PLATFORM)/include
LDFLAGS += -L libraries/install-root-$(PLATFORM)/lib 

libraries-prep:
	@mkdir -p libraries/install-root-$(PLATFORM)

libraries: $(LIBS_T) ;
	
libraries/%.token-$(PLATFORM) : libraries/scripts/%.sh
	@bash $< install $(PLATFORM)
	@touch $@

list-libraries:
	@echo "Libraries: $(LIBS)"

clean-libraries:
	@for l in $(LIBS_S); do         \
		bash $$l clean $(PLATFORM); \
	done
	@$(RM) libraries/*.token-$(PLATFORM)
	@$(RM) -r libraries/logs/*-$(PLATFORM)
	@$(RM) -r libraries/install-root-$(PLATFORM)

clean:
	@echo "[CLN]    obj/ bin/"
	@$(RM) -r obj bin

clean-all: clean clean-libraries

