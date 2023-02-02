

# NATO Interoperability Standards and Profiles (NISP)

[![Linux Build Status](https://github.com/stavnstrup/nisp-tools/actions/workflows/gh-pages-deployment.yml/badge.svg)](https://github.com/stavnstrup/nisp-tools/actions)

This distribution contains the stylesheets, building tools and
documentation necessary to work with XML version of the NATO
Interoperability Standards and Profiles using the DocBook XML DTD.

For installation please see the file INSTALL. Additional information
can be found in the docs/ subdirectory also hosted [here](https://stavnstrup.github.io/nisp-tools/).


```
README               this file
INSTALL              quick installation instructions
VERSION              the version number of the distribution
WhatsNew             Changes since the last release

build.bat            Win32 script file used to build the web-site and distribution
build.sh             Unix script file used to build the web-site and distribution
build.xml            configuration file for draft editions
build-final.xml      configuration file for final draft edition under IP-CaT silence procedure
build-release.xml    configuration file for approved and releasable edition
build.targets        [Generated - DO NOT MODIFY]
newbuild.xml         configuration file used to create build.targets
uuid-build.xml       configuration file used to create new UUID's

catalog.xml          XML catalog of all DTDs used in this distribution

user.properties      contains user defined paramaters, which will affect the build.
                     Do not change the file, instead create the file local.user.properties
                     and modify the parameters as appropiate.

bin/                 misc files used by the build system
docs/                documentation of this distribution
extra/               misc extra stuff
lib/                 tools used to create the different targets
schema/              Misc schemas used by the tools package
src/                 the XML sources for NISP
xdocs/               Markdown sources of the documentation
xsl/                 XSLT stylesheets
```


If you wish to have further information on the NISP Interoperability
Standards and Profiles, feel free to contact:

Mr. Hervé Radiguet
E-Mail: herve.radiguet@act.nato.int


Mr Jens Stavnstrup (for technical matters related to this distribution)
Danish Defence Acquisition and Logistics Organisation
Tel: + 45 - 728 14355
E-Mail: stavnstrup@gmail.com
