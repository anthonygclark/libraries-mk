### libraries-mk

Note: this is not limited to libraries or anything really, I use it primarily for build and runtime dependencies languages without a builtin package manager or when I have to create large from-scratch runtimes.

Makefile routines (recipes) for building platform specific external code - without a "package manager". This was created to be able to easily track whole-repo dependencies without the need for submodules or relying on package managers to pull external code.

* Each platform is described via `platforms/*.mk` and will be matched via `uname -m`
* Variables in `platforms/*.mk` will be passed to build scripts.
* Libraries are discovered by the existence of `libraries/srcs/<lib>` and the associated build script is assumed to be `libraries/scripts/<lib>.sh`.
* All build libraries get put into `libraries/install-root-${PLAT}`. 
* Use `libraries/scripts/pkg-config` for package-config supported libraries. This will just look in the install-root before looking at the system.
* TODO cmake environment

#### Manual Usage

```sh
$ make -f libraries.mk libraries
**** Wed Dec  7 02:59:19 EST 2016 ****
[LIB]    template.sh (x86_64)
```

This will build the "template" library as it's the only library included by default in the repo.

To list all libraries,

```sh
$ make -f libraries.mk list-libraries
Libraries:  libraries/srcs/template
```

#### Installation / Integration into a makefile-based project:

Clone this repo into the root of your repo then add:

```makefile
-include libraries-mk/libraries.mk
```

Then, invoke any of the recipes in libraries.mk, shown below for convenience, to your rules.

```
clean-all-libraries
clean-libraries
libraries
libraries-prep
list-libraries
```

#### Recipes

Output of `make -f libraries.mk help`

```
Targets:
libraries-prep ....... Creates output directories
list-libraries ....... Lists the found libs
clean-libraries ...... Calls uninstall, Removes outputs
clean-all-libraries .. Removes outputs forcefully
libraries ............ Triggers build of all libraries

Found libs:  libraries/srcs/template

Debug:
PLATFORM - x86_64
LIBS_S - libraries/scripts/template.sh
LIBS_T - libraries/template.token-x86_64
LIBS_INSTALL_ROOT - libraries/install-root-x86_64
PKGCONFIG - libraries/scripts/pkg-config
```

#### License

BSD