% nisp-database
% Jens Stavnstrup \<stavnstrup@mil.dk\>
% October 2, 2013

Name
====

nisp.database - The database used to describe standards and profiles in NISP

Description
===========

The NISP database contains all standards and profiles used in the NISP
and the NC3TA since 1998.

The standard database is logically separated into four
different parts:

* service taxonomy based on the C3 Taxonomy baseline 1
* standard selection
* standard and profile description
* community of interest profiles
* mapping between organisation abbrevations and full names

The structure of the database is described in detail in [nisp-database-schema](nisp-database-schema.html).

The remaining of this document describes specific issues of the database the user should be aware off.


Introduction of UUIDs
---------------------

The introduction of UUIDs in the database put significant restrictions
on how we in the future update standards and profiles. Except for
fixing errors in the description of a standard or profile, the and
standard and profile should never be modified. So when e.g. a standard
is updated from version 2.0 to verion 3.0, we should create a complete
new `<standard>` or `<profile>` element. When creating the new
`<standard>` or `<profile>` element, it would make sence to just copy
the old elemen and then change the appropiate attributes and child
elemnts, then make sure you delete the copied UUID element from the
new `<standard>` or `<profile>` element.


Usage of identifiers in the database
------------------------------------

Each `<standard>` and `<profile>` element have two identifiers, i.e. `id`
in the form of an attribute and ùuid` in form of a child element.
which are used to uniquely identify a specific standard or profile.

The two identifiers serves different purposes:

`id`
:   This identifier is manually created and by convention we use a
    combination of the `orgid`, a hyphen and and the `pubnum` attribute of
    the `<document>` element. This identifier is userfriendly, as it is
    easy to remember and are therefore the id we are using to refere to a
    standard or profile from a `<select>` element. Examples of such identifiers
    are *iso-8859-1* and *rfc-793*.


`uuid`
:   This identifier is *automatically* generated and should under
    no cicumstances be changed. The UUID identifier will be unique for
    a specific version of a `<standard>` or `<profile>` element, so
    e.g. two different version of a given standard will have different
    UUIDs. This will enable us to import the NISP database into a
    architecture repository and whenever the NISP database is updated
    we syncronise with the data in the architecture repository.


Generating UUIDs
----------------

To ensure that new UUID elements are created, whenever new standards
and profiles are added to the database, the build system will refuse
to create HTML and PDF version of the NISP until missing UUID elements
have been added to the database.

The new UUID elemnts are created by running the command

    build -f uuid-build.xml



Usage of organisation abbreaviations
------------------------------------

Each `<standard>` element contains a `<document>` element, which
describes the standard the element represents. Among the attributes is
`orgid`, which should only use values from a pre-defined set of
maps. This set is described in the element `<organisations>` and
should be extended if the relevant standard organisation is not
already defined. An example of such a map, is 

~~~{.dtd}
<orgkey key="opengroup" text="The Open Group" />
~~~


See Also
========

[nisp-database-schema]

The NISP sources and tools are availible in a subversion repository on TIDE at <http://tide.acr.nato.int/svn/nisp/trunk>.

[nisp-database-schema]: (nisp-database-schema.html)
