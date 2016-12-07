### libraries-mk

Note: this is not limited to libraries or anything really, I use it primarily for build and runtime dependencies for C++.

Makefile routines (recipes) for building platform specific external code - without a "package manager". This was created to be able to easily track whole-repo dependencies without the need for submodules or relying on package managers to pull external code.

* Each platform is described via `platforms/*.mk` and will be matched via `uname -m`
* Variables in `platforms/*.mk` will be passed to build scripts.
* Libraries are discovered by the existence of `libraries/srcs/<lib>` and the associated build script is assumed to be `libraries/scripts/<lib>.sh`.
* All build libraries get put into `libraries/install-root-${PLAT}`. 
* Use `libraries/scripts/pkg-config` for package-config supported libraries. This will just look in the install-root before looking at the system.

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

#### Integrated Into a real Makefile

Clone this repo into your Makefile project. And add:

```makefile
-include libraries-mk/libraries.mk
```

Then, add any of the recipes in libraries.mk, shown below for convenience, to your rules.

```
clean-all-libraries
clean-libraries
libraries
libraries-prep
list-libraries
```

#### Recipes

1. `libraries` Builds all libraries
2. `libraries-prep` sets up the environment for your new sysroot
3. `list-libraries` debugging output to list all discovered libraries
4. `clean-libraries` calls the `clean()` function in the library's script. This is nice for removing a single library when you intend to rebuild it or completely remove it without rebuilding everything.
5. `clean-all-libraries` cleans the entire install-root for the platform. (I might rename this).

#### Contributing

Please submit features or patches!