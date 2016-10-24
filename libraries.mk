#!/usr/bin/make -f

PLATFORM  ?= $(shell uname -m)

# Each of these platform makefiles should at least
# override CC and CXX. If not, the system's default CC and CXX
# will probably be used...
-include $(CURDIR)/platforms/$(PLATFORM).mk

# Defaults
CFLAGS    ?= -Wall -pedantic -std=c11
CXXFLAGS  ?= -std=c++14
PKGCONFIG ?= scripts/pkg-config
LIBRARIES ?= libraries/srcs/*/

export PLATFORM
export CC
export CXX
export CFLAGS
export CXXFLAGS
export PKGCONFIG

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

print-%:
	@echo $* = $($*)

nprint-%:
	@echo $* = $($*) | tr ' ' '\n'

libraries-prep:
	@mkdir -p libraries/install-root-$(PLATFORM)
	@mkdir -p libraries/srcs
	@mkdir -p libraries/scripts
	@mkdir -p libraries/logs

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

clean-all-libraries:
	@$(RM) libraries/*.token*
	@$(RM) -r libraries/logs/*
	@$(RM) -r libraries/install-root-*
