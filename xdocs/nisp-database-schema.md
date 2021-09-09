% nisp-database-schema
% Jens Stavnstrup \<stavnstrup@mil.dk\>
% September 21, 2020

# Name

nisp-database-schema - The schema of database used to describe standards and profiles in NISP

# Description

The current NISP standards database is implemented as a XML
document. The original design of the database reflected the structure
of the list of standard and profiles described in the NC3 Technical
Architecture version 1. In order to enable consistency across the
different volumes, the database have been extended to be able to
describe the selection of mandatory- and candidate standards
and profiles. This selection of standards and profiles are justified
in the rationale statements, which are also part of the
database.

In order to enable validation of the database, a schema in form
of a DTD have been defined. This DTD is located in the source distribution at
`schema/dtd/stddb47.dtd`.

Since some of the element in the schema represent textual information
in the form of DocBook fragments such as paragraphs, unnumbered lists
etc., the standard database DTD have been implemented as an extension
to the DocBook DTD. Ideally we should use multiple name space in order
to avoid naming conflicts, but that is very complicated when using a
simple schema language such as DTD. A better approach would be to
implement the standard database schema in a modern schema language
such as Relax NG.

In the rest of this document, the syntax of the database is described
in detail and when appropriate, examples of the actual implementation
is included.

The standard database DTD is logically separated into three
different parts:

- service taxonomy on the C3 taxonomy baseline 3.1 - dated July 4, 2019
- standard and profile descriptions
- mapping between organisation abbreviations and full names

The root element of the DTD is the element `<standards>`
and is described by:

```{.dtd}
<!ELEMENT standards (revhistory?, taxonomy, records,
                     organisations)>
```

The `<revhistory>` element describes the historic changes to the database.

The `<organisations>` element contains a mapping between
keywords and organisation names and is used to ensure, that only
registered organisation are used and therefore prevents the same
organisation name to be spelled in multiple ways. The organisation element
lists organisation which create/owns a standard but also organisations,
which are responsible for a standard. Being responsible mean that an
organisation is subject matter expert and recommend to use a given standard.

```{.dtd}
<!ELEMENT organisations (orgkey*)>

<!ELEMENT orgkey EMPTY>
<!ATTLIST orgkey
          key    ID   #REQUIRED
          short  CDATA   #REQUIRED
          long   CDATA   #REQUIRED
          uri    CDATA   #IMPLIED>
```

## Service taxonomy

The services taxonomy describes how the standards and profiles are
organised and is a subset of the C3 taxonomy.

The service taxonomy is a hierarchical structure, consisting of
`<node>` elements as described below. All the `<node>` elements must
have an `id`, `title`, `level`, `description` and `emUUID` attribute. The `id`
attribute is used to identify the relationship between selected
standards and the service taxonomy. The `level` attribute described on
what level in the taxonomy the node is located, the `description` attribute
contains a description of the node in the form of raw mediawiki markup, the `descriptionMD` attribute
contains a description of the node in the form of raw markdown and the `emUUID`
attribute is the UUID assigned in the TIDE EM-Wiki.

```{.dtd}
<!ELEMENT taxonomy (node+)>

<!ELEMENT node (node*)>

<!ATTLIST node
          id ID #REQUIRED
          title CDATA #REQUIRED
          level CDATA #REQUIRED
          description CDATA #IMPLIED
          descriptionMD CDATA #IMPLIED
          emUUID CDATA #REQUIRED>
```

## Base Standards Profile

In NISP volume 2 and 3 all mandatory and candidate standards are listed in what we call the _Base Standards Profile_ (BSP). Since NISP 12, the BSP and COI profiles (represented by `<profile>` and `<serviceprofile>` elements) has been consolidated. The BSP is now represented using a `<profile>` with the `id` value _bsp_.

## Standards

Both de-jure and de-facto standards from many different standard
organizations are labeled differently. Some standards have multiple
parts each having a standard number, where for other standards only
the cover standard have a number. Some standards are registered by
multiple standard bodies. Some standards are updated, but the actual
update are released as a separate document instead of releasing a new
version of the standard. So the following rules tries to accommodate
all the different conventions used, when describing a standard or profile.

All standards and profiles types are contained in the `<records>`
element.

```{.dtd}
<!ELEMENT records ((standard | coverdoc | serviceprofile | profile | profilespec)*)>
```

All standards are implemented using a
single `<standard>` element describing both the
standard and historical aspect about the standard. A standard
consists of the following elements:

- document - describes the actual standard
- applicability - when and where should the standard be used
- responsibleparty - Who is responsible for the standard
- status - contains historical data
- uuid - an automatically generated UUID. Note, that although the UUID
  is mandatory, it is defined as optional in the schema, so that the
  database will comply with the schema before the UUID is
  automatically generated.

```{.dtd}
<!ELEMENT standard (document, applicability, responsibleparty, status, uuid?)>

<!ATTLIST standard
          tag CDATA #REQUIRED
          id ID #REQUIRED>
```

The standard exposes the attributes `tag`
and `id`. The `tag` attribute was previously
used the volume 3 of the NC3TA, and a is short title identifying the
standard. A few future use could be to provide a title when selecting
standards.

## Covering Document

A `coverdoc` element is a standard like construct which is realized by the NATO standardization documents STANAG and STANREC, which represents an agreement of member nations to implement a standard, in whole or in part, with or without reservation, in order to meet an interoperability requirement. A coverdoc will refer to one or more standards described by the `coverstandards` element.

```{.dtd}
<!ELEMENT coverdoc (document, coverstandards, responsibleparty, status, uuid?)>
<!ATTLIST coverdoc
          tag CDATA #REQUIRED
          id ID #REQUIRED>

<!ELEMENT coverstandards (refstandard+)>
```

### Document

The `<document>` element exposes the publishing organisation,
publication number, publishing date, title and version through the
attributes `orgid`, `pubnum`, `date`, `title`, `version` and `note`. The
`orgid` refers to an organisation is embedded in the `<organisations>`
element. The rule of using organisation identifiers instead of the
actual name of the organisation is mandated to prevent, that the same
organisation exists in multiple incarnations in the database.

```{.dtd}
<!ELEMENT document (substandards?, correction*, alsoknown?, comment?)>

<!ATTLIST document
          orgid   CDATA #REQUIRED
          pubnum  CDATA #REQUIRED
          date    CDATA #REQUIRED
          title   CDATA #REQUIRED
          version CDATA #IMPLIED
          note    CDATA #IMPLIED>
```

If a standard is a cover standard (e.g ISO-8859), it may implement the
`<substandards>` element, which contains a list of
`<substandard>` element. Each `<substandard>` element will
trough the attribute `refid` contain a reference to the substandard.

The DTD allows a `<standard>` element using
`<substandard>` elements to refer to other standards ('the
substandards'), and in principle these substandards could refer to
other `<standard>` elements. However, the later does not make
any sense and is therefore not allowed.

```{.dtd}
<!ELEMENT substandards (substandard+)>

<!ELEMENT substandard EMPTY>
<!ATTLIST substandard
          refid IDREF #REQUIRED>
```

Some standard organisations publish documents which are correction to
the standard.

```{.dtd}
<!ELEMENT correction (#PCDATA)>

<!ATTLIST correction
          cpubnum  CDATA #REQUIRED
          date     CDATA #REQUIRED>
```

Sometimes a standard is republished by another standard organisation. An
`<alsoknown>` element contains a description which might be
empty. A `<alsoknown>` element must also contain a
`orgid`, `pubnum` and `date`
attribute. E.g. NATOs stanag 3809 for Digital Terrain Elevation
Data (DTED) is also know as ISO/IEC 8211.

```{.dtd}
<!ELEMENT alsoknown (#PCDATA)>

<!ATTLIST alsoknown
          orgid   CDATA #REQUIRED
          pubnum  CDATA #REQUIRED
          date    CDATA #REQUIRED>
```

A `<comment>` element contain data in the form of text or DocBook
`<ulink>` elements.

```{.dtd}
<!ELEMENT comment (#PCDATA | ulink)*>
```

### Applicability

The `<applicability>` element uses the same content model as the
DocBook `<entry>` element and contains a textual description of
the standard.

```{.dtd}
<!ELEMENT applicability %ho; (%tbl.entry.mdl;)*>
```

### Responsible Party

The `<responsibleparty>` element references the organisational element
in NATO, which takes responsibility for guiding the IP CaT on
standards within a specific technical domain. The `rpref` attribute
contains a reference to a `<rp>` element, which contains information
about the responsible organisation. This construct is similar to the
`<organisations>` element construct and can be used to ensure `rpref`
is selected from a predefined set.

```{.dtd}
<!ELEMENT responsibleparty EMPTY>
<!ATTLIST responsibleparty
          rpref   CDATA  #REQUIRED>
```

### Status

The `<status>` element can contain in the following order an
`<info>`, `<uri>` and `<history>` element. The
`<history>` element is mandatory, the `<info>` and
`<uri>` elements are not. The `<uri>` element is defined
in the DocBook DTD.

The `<status>` element contains the attributes `mode`, which is
implied and is used to indicate standards, which were either
accepted, rejected or deleted.

```{.dtd}
<!ELEMENT status (info?, uri?, history)>
<!ATTLIST status
          mode   (accepted|deleted|rejected) #IMPLIED "accepted">
```

The `<info>` element contains textual information, which is not
appropriate to put in e.g. the `<applicability>` element. It can also
contain `<ulink>` elements, which e.g. could point to the standard.

```{.dtd}
<!ELEMENT info (#PCDATA | ulink)*>
```

The `<history>` element contains historical information about a
standard. When was it added, changed or deleted and through which
RFCP. The `<history>` element contains of one or more event
elements.

The `<event>` element may contain a `rfcp` attribute and must
contain the attributes `flag`, `date` and `version`.

The `version` attribute designates the major version where the RFCP
is included. This means, that if e.g we receive a RFCP with the
number 7-1, which means a change proposal for NISP version 7.0, then
we should set the `version` attribute to the value `8.0`, since this
is the first version, this RFCP takes effect.

The `date` attribute must use the Complete Date format YYYY-MM-DD as defined in [ISO 8601].

```{.dtd}
<!ELEMENT history (event)+>

<!ELEMENT event (#PCDATA)>

<!ATTLIST event
          flag    (added|changed|deleted)   #REQUIRED
          date    CDATA   #REQUIRED
          rfcp    CDATA   #IMPLIED
          version CDATA   #REQUIRED>
```

### UUID

```{.dtd}
<!ELEMENT uuid (#PCDATA)>
```

The `<uuid>` element is mandatory in every standard although in the
DTD it is stated the there can be zero or one `<uuid>` element. The
reason for this inconsistency is that we do not want a DTD driven
editor to complain about a missing element and we do not want the user
to manually create an UUID. The UUID must always be automatically created by the
NISP tool and comply with RFC 4122: "A Universally Unique Identifier
(UUID) URN Namespace." The UUID generated is a version 4 type, which
means it is a randomly generated UUID.

## Community of Interest Profiles

Where the _Base Standards Profile_ represent the IP CaT proposal for mandatory and candidate standards for a selected set of taxonomy nodes. Community of Interest Profiles uses two different profile elements, which are _profile_ and _serviceprofile_ organized in a tree structure.

The leaves of the tree consists of `servicprofile` elements which references selected standards. All other nodes in the tree are represented by the represented by `profile` elements. The `profile` element is basically a kind of container element. All profile elements are described in detail below. The root of a profile tree is also called a _capabilityprofile_, but is no longer represented by its own element.

### Profile

A `<profile>` consists of a `<refprofilespec>` element describing
the capability, a number of references to `<profile>` or `<serviceprofile>` elements encapsulated in a `<subprofiles>` element and a `<status>` element. A `toplevel` attribute is set to `yes`, if the `profile` node is the root of the profile tree. This node was previously called a capability node.

```{.dtd}
<!ELEMENT profile (refprofilespec, description?, subprofiles?, status, uuid?)*>
<!ATTLIST profile
          id ID #REQUIRED
          short CDATA #IMPLIED
          title CDATA #REQUIRED
          toplevel (yes|no) "no">
```

### Service Profile

A `<serviceprofile>` element represents a service, which is required by a specific capability and it consists of a `<refprofilespec>` ( referencing `<profilespec>` a describing the capability), a number of one or more references in form of `<reftaxonomy>` elements to the taxonomy. The `<serviceprofile>` serves two distinct roles, it represents a leave of the basic standards profiles which lists mandatory and emerging standardards for NATO common funded systems and second it represent the leaves of a community of interest profile like the Federated Mission Networking (FMN) profile. The role of the serviceprofile is controlles by the attributes of the `<refgroup>` element(s).

```{.dtd}
<!ELEMENT serviceprofile (refprofilespec, description?, reftaxonomy+, refgroup+, guide*,  status, uuid?)>
<!ATTLIST serviceprofile
          id ID #REQUIRED
          title CDATA #REQUIRED>
```

### Profilespec Element

A `<profilespec>` element exposes the publishing organisation, publication number, publishing date, title and version through the attributes orgid, pubnum, date, title, version and note. The orgid refers to an organisation is embedded in the `<organisations>` element. The rule of using organisation identifiers instead of the actual name of the organisation is mandated to prevent, that the same organisation exists in multiple incarnations in the database.

```{.dtd}
<!ELEMENT profilespec EMPTY>
<!ATTLIST profilespec
          orgid   IDREF #REQUIRED
          pubnum  CDATA #REQUIRED
          date    CDATA #REQUIRED
          title   CDATA #REQUIRED
          version CDATA #IMPLIED
          note    CDATA #IMPLIED>
```

```{.dtd}
<!ELEMENT refprofilespec EMPTY>
<!ATTLIST refprofilespec
          refid IDREF #REQUIRED>
```

### Child elements of profile and servicprofile

A `<subprofile>` element references child profiles. This element is used by the `<profile>` element and must only reference `<profile>` or `<serviceprofile>` elements.

```{.dtd}
<!ELEMENT subprofiles (refprofile+)>
```

The `<description>` element uses the same content model as the
DocBook `<entry>` element and contains a textual description of
the profile.

```{.dtd}
<!ELEMENT description  %ho; (%tbl.entry.mdl;)*>
```

The `<reftaxonomy>` element refences a taxonomy node, which this a given `<serviceprofile>` element supports.

```{.dtd}
<!ELEMENT reftaxonomy EMPTY>
<!ATTLIST reftaxonomy
          refid IDREF #REQUIRED>
```

The `<refgroup>` references standards and profiles with a specific obligation. The `<refgroup>` element is child of a `<serviceprofile>`element.

TBD: DESCRIBE obligation and lifecycle ATTRIBUTES AND HOW THEY CONTROL THE DUAL ROLES OF A SERVICE PROFILE

```{.dtd}
<!ELEMENT refgroup (description?, refstandard*, refprofile*, uuid?)>
<!ATTLIST refgroup
          obligation (none|mandatory|recommended|optional|conditional) "none"
          lifecycle (current|candidate) "current">
```

```{.dtd}
<!ELEMENT refstandard EMPTY>
<!ATTLIST refstandard
          refid IDREF #REQUIRED>
```

```{.dtd}
<!ELEMENT refprofile EMPTY>
<!ATTLIST refprofile
          refid IDREF #REQUIRED>
```

The `<guidance>` element provides guidance on how a set of standard should be implemented.

```{.dtd}
<!ELEMENT guide %ho; (%tbl.entry.mdl;)*>
```

[iso 8601]: http://www.w3.org/TR/NOTE-datetime
