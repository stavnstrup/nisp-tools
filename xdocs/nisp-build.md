% nisp-build
% Jens Stavnstrup \<stavnstrup@mil.dk\>
% January 17, 2012


Name
====

nisp-build - Using the nisp tools to build the NISP documents


Synopsis
========

    build [OPTIONS] [TARGET [TARGET2 [TARGET3] ...]] 


By default this command uses build.xml as its default build file.


Options
=======

Since the `build` script is just a wrapper around [Ant], it takes the
same options, but only the options below are relevant.

-buildfile, -file, -f <file>
:   use the given buildfile instead of the default build.xml file. This is the ant equivalent of Makefile

-help, -h
:   print help on the command line options

-projecthelp, -p
:   print project help information

-version
:    print the version information of ant

-diagnostics
:   print information that might be helpful to diagnose or report problems

-quiet, -q
:   be extra quiet

-verbose, -v
:   be extra verbose

-debug, -d
:   print debugging information

-logfile <file>
:   use the given file to output log to


Description
===========

The NISP tools uses the make-like tool [Ant](http://ant.apache.org/) to
build HTML and PDF versions of the NISP. NISP wraps ant in a shell file
**build.bat** for use in Windows and **build.sh** for use in Linux/Unix.

Running the command

~~~
    build
~~~

will build all HTML and PDF files


Build targets
-------------

The syntax for using the build script is

~~~
    build [-f buildfile] [target*]
~~~

The XML based buildfile consist of a project definition defining one
or more targets. A target is a set of tasks which should be
executed. When the buildfile is not specified Ant will by default use
the file `build.xml`, and if a target is not defined, Ant will build
the default target as specified in the project element.

A target *A* may depend on other targets *B* and *C*, which have to be build
before target *A* can be build. The build process therefore identifies the
dependency between targets and build only the necessary targets
depending on if anything have changed since the last build was executed.

NISP Targets
------------

The NISP build file contain more than 100 different targets. Some
targets exists only for technical reasons and will not be described
here. The rest of the target can shown by issuing the command

~~~
    build -projecthelp
~~~

The targets can be separated into dynamic and static targets.


### Dynamic Targets

The dynamic targets are located in the file *build.target*, which is
automatically imported by the file *build.xml* and the targets made
availible to the user.

Historically, NISP have changed a lot, we have added and removed
multiple volumes, and every time the dynamic target had to be
recreated, which is quite complicated. As a consequence the creation
of dynamic is done semiautomatic. Whenever the *src/documents* used to
specify the volumes in NISP are changed, the build process will refuse
to run until a new *build.targets* have been created. This is done by
executing the command

~~~
    build -f newbuild.xml
~~~

The dynamic targets are targets created for each volume of the NISP.
E.g. for volume 1 the following targets exists.

vol1
:   Create Volume 1 in HTML5 and PDF
vol1.resolve
:   Resolve volume 1
vol1.html
:   Create Volume 1 in HTML5
vol1.pdf
:   Create Volume 1 in PDF
vol1.rtf
:   Create Volume 1 in RTF (Word exchange format)
vol1.zip
:   Create source archive of Volume 1

Similar instructions exists for the other volumes.

Additionaly the targets *html*, *pdf*, *rtf* and *all* are created
used to specify that *HTML5*, *PDF*, *RTF* and *all* (HTML5 and PDF)
versions of all the volumes should be created.

html
:   Create all HTML files destined for the web
pdf:
    Create a PDF version of NISP
rtf
:   Create all RTF files


htmlhelp
:   Create HTMLHelp version of the NISP


### Static targets

The static targets are used to create the directory
structure, creating archives of the sources and the tools, debugging
etc.

#### Additional pages for the HTML5 version

master
:   Create the NISP master documents as HTML5 pages
acronyms
:   Create the acronyms as chunked HTML5 pages

#### Cleaning targets

Clean-up targets

clean
:   Clean all (only build and distribution directories)
clean-build
:   Clean the build directories
clean-dist
:   Clean the distribution directories
clean-zip
:   Clean the distribution zip directories

#### Debugging targets

These target are usefull to debug aspects of NISP especially to catch
semanticl errors in the standards database.

debug
:   Create misc. debugging reports
deb-overview
:   Create DB Overview
deb-dates
:   Create DB Dated list
deb-family
:   Create DB parent/child relationship list
deb-info
:   Show infomation about all documents
deb-figures
:   Show all figures
deb-upcoming
:   Create list of upcoming/fading standards/profiles


#### Documentation target

doc
:   Create documentation pages

    Note, The documentation pages are written in [Markdown] and requires
    the tool [Pandoc], which is not included in the tools package.


#### Archieving targets

These two targets are used to create ofline versions of the NISP

web
:   Create the website containing the NISP
pdf-only
:   Create a zip containing only PDF files

Additional archiving targets are

source
:   Create a new source distribution
tool
:   Create a new tool distribution
zip
:   Create source, tool, xsl, web and pdf archives
resolve.zip
:   Create a resolved version of the XML sources


Additional build files
----------------------

NISP are released according to the IP CaT Standard Operation
Procedures (SOP). The NISP tools implements these procedures in three
different build files.


build.xml
:   Version developed by the IP CaT (this version containes all the targets described above)
build-final.xml
:   Final draft distributed among IP CaT only.
build-release.xml
:   This is the version distributed to the NC3 Board.

Note that there is actually an addional stage in the publication
process, but since the board normaly send out NISP to Nato and nations
under silence procedure, which skips this step, otherwise NISP will be
published with a draft label.



See Also
========

[home]


[Ant]: (http://ant.apache.org/)

[Markdown]: (http://daringfireball.net/projects/markdown/)

[Pandoc]: (http://johnmacfarlane.net/pandoc/)

[home]: (index.html)
