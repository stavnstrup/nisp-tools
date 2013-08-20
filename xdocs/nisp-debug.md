% nisp-debug
% Jens Stavnstrupk \<stavnstrup@mil.dk\>
% August 30, 2007

Name
====

nisp-debug - Debugging targets for NISP



Synopsis
========

    build [DEBUGTARGET [DEBUGTARGET2 ...]]


Description
===========

Since both the NISP database and the DocBook sources are ordinary XML
files, it is relatively easy to make mistakes. Although syntax errors
are identified, when using a syntax driven editor, an number of other
semantic errors might go unoticed. A number of build targets for
debugging purposes have therefore been defined.

The debugging targets will query the database and the documents and
create views designed to identify certain typical errors.


Options
=======


Global debug targets 
--------------------

`debug`
:   Create all debugging reports

Debugging the database
----------------------

`deb-overview` 
:   Create a table listing all standards and profiles in
    the NISP database. The purpose solves a nummer of issues. 1) Gives
    a complete overview of all standards and profiles. 2) All rows
    marked with a red background are deleted standards/profiles and 3)
    all cells with a yellow background illustrates information misinng
    in the database.

    The generated file is named **build/debug/overview.html**

`deb-dates`
:   List all event elements belonging to a standard or profile sorted in
    decending order. When the list of the sorted event are generated,
    a row spanning all columns with a blue background color is
    inserted before each event element, if the previous event element
    do have a different version number. This have the effect, that if
    there are two blue rows with the same version number, then there
    is a bug in one or more event record before or after the blue
    line.

    The generated file is named **build/debug/dates.html**

`deb-family`
:   Create DB parent/child relationship list. The main purpose is to
    identify any failure in the parent/child relationsship between
    standards and parents. What we specifically are looking for is if
    a parent standard/profile links to a child standard/profile, that
    have been deleted from the database.

    The generated file is named **build/debug/family.html**

`deb-upcoming`
:   Create list of upcoming/fading standards/profiles
 
    The generated file is named **build/debug/upcoming.html**

Document debug targets
----------------------

`deb-info`
:   Show all meta data in all volumes and and the similar information
    the the document.xml file. The document also list a rasterized
    version of all figures in each document.in each documentinfomation
    about all documents
   
    The generated file is named **build/debug/info.html**


`deb-figures`
:   Show all figures in NISP in a PDF document. Since the
    PDF document can map the SVG element into similar PDF constructs,
    we are able to see how each figure scale.

    The generated file is named **build/debug/figures.pdf**



See also
========

[nisp-build], [nisp-standard] and [nisp-standard-schema].


[nisp-build]: (nisp-build.html "nisp-build")
[nisp-standard]: (nisp-standard.html "nisp-standard")
[nisp-standard-schema]: (nisp-standard-schema.html "nisp-standard-schema") 
