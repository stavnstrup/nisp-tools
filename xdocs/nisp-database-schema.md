% nisp-database-schema
% Jens Stavnstrup \<stavnstrup@mil.dk\>
% Nov 25, 2014



Name
====

nisp-database-schema - The schema of database used to describe standards and profiles in NISP

Description
===========

The current NISP standards database is implemented as a XML
document. The original design of the database reflected the structure
of the list of standard and profiles described in the NC3 Technical
Architecture version 1. In order to enable consistency across the
different volumes, the database have been extended to be able to
describe the selection of mandatory-, emerging- and fading standards
and profiles. This selection of standards and profiles are justified
in the rationale statements, which are also part of the
database. Recently the database have been reorganised to reflect
additional requirements, but also to prepare the database for
inclusion in the NATO Architecture Repository (NAR)

In order to enable validation of the database, a schema in form
of a DTD have been defined. This DTD is located in the source distribution at
`schema/dtd/stddb41.dtd`.

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

The standard database DTD is logically separated into four
different parts:

* service taxonomy on the C3 taxonomy baseline 1 - dated june 15, 2012
* standard selection
* standard and profile description
* community of interest profiles
* mapping between organisation abbreviations and full names
* mapping between responsible parties abbreviation and full names

The root element of the DTD is the element `<standards>` 
and is described by:

~~~{.dtd}
<!ELEMENT standards (revhistory?, taxonomy, lists, records, 
                     organisations, responsibleparties)>
~~~

The `<revhistory>` element describes the historic changes to the database.

The `<organisations>` element contains a mapping between
keywords and organisation names and is used to ensure, that only
registered organisation are used and therefore prevents the same
organisation name to be spelled in multiple ways.

The `<responsibleparties>` element contains a mapping between keywords
and responsible parties element. The construct is similar to the
approach taken for the `<organisation>` element.

Service taxonomy
----------------

The services taxonomy describes how the standards and profiles are
organised and is a subset of the C3 taxonomy.

The service taxonomy is a hierarchical structure, consisting of
`<node>` elements as described below. All the `<node>` elements must
have an `id`, `title`, `level` and `emUUID` attribute. The `id`
attribute is used to identify the relationship between selected
standards and the service taxonomy. The `level` attribute described on
what level in the taxonomy the node is located and the `emUUID`
attribute is the UUID assigned in the TIDE EM-Wiki.

~~~{.dtd}
<!ELEMENT taxonomy (node)>

<!ELEMENT node (node*)>

<!ATTLIST node
          id ID #REQUIRED
          title CDATA #REQUIRED
          level CDATA #REQUIRED
          emUUID CDATA #REQUIRED>

~~~



Standard and profile definition
-------------------------------

Both de-jure and de-facto standards from many different standard
'organizations' are labeled differently. Some standards have multiple
parts each having a standard number, where for other standards only
the cover standard have a number. Some standards are registered by
multiple standard bodies. Some standards are updated, but the actual
update are released as a separate document instead of releasing a new
version of the standard. The same is true for profiles. So the
following rules tries to accommodate all the different conventions
used, when describing a standard or profile.

All standards and profiles are contained in the `<records>` 
element.

~~~{.dtd}
<!ELEMENT records ((standard | interoperabilityprofile | serviceprofile | capabilityprofile)*)>
~~~

### Standards


All standards are implemented using a
single `<standard>` element describing both the
standard and historical aspect about the standard.  A standard
consists of:

* document - describes the actual standard
* applicability - when and where should the standard be used
* status - contains historical data
* uuid - an automatically generated UUID. Note, that although the UUID
  is mandatory, it is defined as optional in the schema, so that the
  database will comply with the schema before the UUID is
  automatically generated.

~~~{.dtd}
<!ELEMENT standard (document, applicability, status, uuid?)>

<!ATTLIST standard
          tag CDATA #REQUIRED
          id ID #REQUIRED>
~~~

The standard exposes the attributes `tag`
and `id`.  The `tag` attribute was previously
used the volume 3 of the NC3TA, and a is short title identifying the
standard. A few future use could be to provide a title when selecting
standards.

#### Document


The `<document>` element exposes the publishing organisation,
publication number, publishing date, title and version through the
attributes `orgid`, `pubnum`, `date`, `title` and `version`. The
`orgid` refers to an organisation is embedded in the `organisations`
element. The rule of using organisation identifiers instead of the
actual name of the organisation is mandated to prevent, that the same
organisation exists in multiple incarnations in the database.

~~~{.dtd}
<!ELEMENT document (substandards?, correction*, alsoknown?, comment?)>

<!ATTLIST document
          orgid   CDATA #REQUIRED
          pubnum  CDATA #REQUIRED
          date    CDATA #REQUIRED
          title   CDATA #REQUIRED
          version CDATA #IMPLIED>
~~~

If a standard is a cover standard (e.g ISO-8859), it may implement the
`<substandards>` element, which contains a list of
`<refstandard>` element. Each `<refstandard>` element will
trough the attribute `refid` contain a reference to the substandard.

The DTD allows a `<standard>` element using
`<substandard>` elements to refer to other standards ('the
substandards'), and in principle these substandards could refer to
other `<standard>` elements. However, the later does not make
any sense and is therefore not allowed.

~~~{.dtd}
<!ELEMENT substandards (substandard+)>

<!ELEMENT substandard EMPTY>
<!ATTLIST substandard
          refid IDREF #REQUIRED>
~~~

Some standard organisations publish documents which are correction to 
the standard.

~~~{.dtd}
<!ELEMENT correction (#PCDATA)>

<!ATTLIST correction
          cpubnum  CDATA #REQUIRED
          date     CDATA #REQUIRED>
~~~

Sometimes a standard is republished by another standard organisation. An 
`<alsoknown>` element contains a description which might be
empty. A `<alsoknown>` element must also contain a 
`orgid`, `pubnum` and `date`
attribute. E.g. NATOs stanag 3809 for Digital Terrain Elevation
 Data (DTED) is also know as  ISO/IEC 8211.

~~~{.dtd}
<!ELEMENT alsoknown (#PCDATA)>

<!ATTLIST alsoknown
          orgid   CDATA #REQUIRED
          pubnum  CDATA #REQUIRED
          date    CDATA #REQUIRED>
~~~

A `<comment>` element contain data in the form of text or DocBook
`<ulink>` elements.

~~~{.dtd}
<!ELEMENT comment (#PCDATA | ulink)*>
~~~

#### Applicability

~~~{.dtd}
<!ELEMENT applicability %ho; (%tbl.entry.mdl;)*>
~~~

The `<applicability>` element uses the same content model as the
DocBook `<element>` entry and contains a textual description of
the standard.

#### Responsible Party

~~~{.dtd}
<!ELEMENT responsibleparty (reevaluation?)>
<!ATTLIST responsibleparty
	  rpref   CDATA  #REQUIRED
	  comment CDATA  #IMPLIED>
~~~

The `<responsibleparty>` element references the organisational element
in NATO, which takes responsibility for guiding the IP CaT on
standards within a specific technical domain. The `rpref` attribute
contains a reference to a `<rp>` element, which contains information
about the responsible organisation. This construct is similar to the
`<organisations>` element construct and can be used to ensure `rpref`
is selected from a predefined set.

~~~{.dtd}
<!ELEMENT reevaluation EMPTY>
<!ATTLIST reevaluation
	  date    CDATA  #REQUIRED
	  comment CDATA  #IMPLIED>
~~~

The `<revaluation>` element advises on when a standard shoul be revaluated.


#### Status


The `<status>` element can contain in the following order an
`<info>`, `<uri>` and `<history>` element. The
`<history>` element is mandatory, the `<info>` and
`<uri>` elements are not. The `<uri>` element is defined
in the DocBook DTD.

~~~{.dtd}
<!ELEMENT status (info?, uri?, history)>

<!ATTLIST status
          mode   (accepted|rejected) #IMPLIED "accepted"
          stage  CDATA #REQUIRED>
~~~

The `<status>` element contains the attributes `mode`, which is
implied and is used to indicate standards, which were either accepted
or rejected.

~~~{.dtd}
<!ELEMENT info (#PCDATA | ulink)*>
~~~

The `<info>` element contains textual information, which is not
appropriate to put in e.g. the `<applicability>` element. It can also
contain `<ulink>` elements, which e.g. could point to the standard.

~~~{.dtd}
<!ELEMENT history (event)+>

<!ELEMENT event (#PCDATA)>

<!ATTLIST event
          flag    (added|changed|deleted)   #REQUIRED
          date    CDATA   #REQUIRED
          rfcp    CDATA   #IMPLIED
          version CDATA   #REQUIRED>
~~~

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


The `date` attribute must use the Comple Date format YYYY-MM-DD as defined in [ISO 8601].

#### UUID

~~~{.dtd}
<!ELEMENT uuid (#PCDATA)>
~~~

The `<uuid>` element is mandatory in every standard although in the
DTD it is stated the there can be zero or one `<uuid>` element. The
reason for this inconsistency is that we do not want a DTD driven
editor to complain about a missing element and we do not want the user
to manually create an UUID. The UUID must always be automatically created by the
NISP tool and comply with RFC 4122: "A Universally Unique Identifier
(UUID) URN Namespace." The UUID generated is a version 4 type, which
means it is a randomly generated UUID.



### Profiles


The are multiple profile elements, each accomodating different goals.

<ul>
  <li>capabilityprofile - Example: FMN</li>
  <li>serviceprofile - Example: Infrastructure Services</li>
  <li>interoperabilityprofile - Example: FMN XMPP Baisic</li>
</ul>

#### Capability Profile

The `<capabilityprofile>` element is a container element, which list the services necessary to implement a given capability.

A `<capabilityprofile>` consists of a `<profilespec>` element describing
the capability, a number of references to `<serviceprofile>` elements encapsulated in a
`<services>` element and a `<status>` element.




~~~{.dtd}
<!ELEMENT capabilityprofile (profilespec, (capabilitygroup+ | services), status, uuid?)>
<!ATTLIST capabilityprofile
          tag CDATA #REQUIRED
          id ID #REQUIRED>
~~~

Normally each `<serviceprofile`> is presented in exactly one table,
but if a `<capabilityprofile>` consists of a lot of services - the
combined size of all the tables becomes to big.  SOMETHING MISSING HERE ???

~~~{.dtd}
<!ELEMENT capabilitygroup (services)>
<!ATTLIST capabilitygroup
          id ID #REQUIRED
	  title CDATA #REQUIRED>
~~~

~~~{.dtd}
<!ELEMENT services (refprofile+)>
~~~


#### Service Profile

A `<serviceprofile>` element represents a service, which is required by a specific capability. 

~~~{.dtd}
<!ELEMENT serviceprofile (profilespec, (servicegroup+ |  guidance), status, uuid?)>
<!ATTLIST serviceprofile
          id ID #REQUIRED
          tref IDREF #REQUIRED
          tag CDATA #REQUIRED>
~~~


~~~{.dtd}
<!ELEMENT servicegroup (guidance, parts)>
<!ATTLIST servicegroup
	  title CDATA #REQUIRED>
~~~

#### Interoperability Profile


~~~{.dtd}
<!ELEMENT interoperabilityprofile (profilespec, profilenote?, parts, configuration?,  applicability, status, uuid?)>
<!ATTLIST interoperabilityprofile
          tag CDATA #REQUIRED
          id ID #REQUIRED>
~~~



~~~{.dtd}
<!ELEMENT guidance %ho; (%tbl.entry.mdl;)*>
~~~




~~~{.dtd}
<!ELEMENT parts (refstandard|refprofile)+>
~~~



~~~{.dtd}
<!ELEMENT refstandard EMPTY>
<!ATTLIST refstandard
          refid IDREF #REQUIRED
	  obligation (mandatory|recommended|optional) "mandatory"
	  lcstage (emerging|current|fading|retired) "current"
	  lctime CDATA #IMPLIED
	  condition CDATA #IMPLIED>
~~~


~~~{.dtd}
<!ELEMENT refprofile EMPTY>
<!ATTLIST refprofile
          refid IDREF #REQUIRED
	  obligation (mandatory | recommended | optional) "mandatory"
	  lcstage (emerging | current | fading | retired) "current"
	  lctime CDATA #IMPLIED
	  condition CDATA #IMPLIED>
~~~



A `<profile>` element must contain a `<profilespec>` element and may
contain `<profilenote>`, `<configuration>`, `<parts>`,
`<applicability>` or `<status>` elements.

A `<profile>` element must contain a `tag` and an `id`
attribute. A `type` attribute is implicit defined with one of the
values `base`, `coi-minor` or `coi`. If the attribute has not explicit
been defined, it will by default be initialised with the value `base`.
Most `<profile>` elements will have an `type` attribute with the
value `base`, which describes the a typical profile, i.e. a subset of
a standard or a set of standards, or one of the above with a specific
configuration.

A `<profile>` element which have the type attribute set to
`coi-minor` or `coi`, and typically the responsibility of a NATO
community of interest, such as the Afghanistan Mission Network (AMN)
profile.

~~~~~~~{.dtd}
<!ELEMENT profile (profilespec, profilenote?, parts,
                   configuration?, applicability, 
                   status, uuid?)>
<!ATTLIST profile
          type (base | coi-minor | coi) "base"
          tag CDATA #REQUIRED
          id ID #REQUIRED>
~~~~~~~

The `<profilespec>` element describes the organisation, publication
number, publication data and title. In profiles which not has an
official owner the `orgid` attribute is set to *ipcat*.

~~~{.dtd}
<!ELEMENT profilespec EMPTY>

<!ATTLIST profilespec
          orgid   CDATA #IMPLIED
          pubnum  CDATA #IMPLIED
          date    CDATA #IMPLIED
          title   CDATA #REQUIRED
          version CDATA #IMPLIED>
~~~

The `<configuration>` element describes - how the 
standards and sub-profiles should be configured. For now, it is just a text element,
as we do not have any experience with this element yet.

~~~{.dtd}
<!ELEMENT configuration (#PCDATA)>
~~~

A `<profile>` element consists of one or more references to
standards or other profiles. Contrary to the `<standard>`
element, profiles can in principle use recursion  
indefinitely.

~~~{.dtd}
<!ELEMENT parts (refstandard|refprofile)`>

<!ELEMENT refprofile EMPTY>

<!ATTLIST refprofile
          refid IDREF #REQUIRED>
~~~

The `<profile>` element may contain text describing the profile
in the form of a `<profilenote>` element. This element is
similar to the comment element used by a standard, and those elements
might therefore be combined in the near future.

~~~{.dtd}
<!ELEMENT profilenote (#PCDATA)>
~~~

Standard Selection
------------------

In NISP volume 2, all mandatory and emerging standards are listed. The
selection mechanism of standards is described in the `<list>`
element. The `<list>` element consists of zero or more
`<sp-list>` elements.

~~~{.dtd}
<!ELEMENT lists (sp-list*)>
~~~

The `<sp-list>` consists of one or more `<sp-view>`
elements, which represent a row in a table of selected standards and
profiles.

Each `<sp-list>` have a `tref` attribute, which is a reference
to a position in the taxonomy.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{.dtd}
<!ELEMENT sp-list (sp-view*)>

<!ATTLIST sp-list
          tref IDREF #IMPLIED>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A `<sp-view>` consists of zero or more `<select>` elements
and potentially a `<remark>` and a `<rationale>` element.

Each `<sp-view>` has an `idx`  attribute. The
`idx` attribute is not used by the NISP tools, but is properly useful
for the NISP dbviewer tools.

~~~{.dtd}
<!ELEMENT sp-view (select*, remarks?, rationale?)>

<!ATTLIST sp-view
          idx ID #IMPLIED>
~~~

The `<select>` element describe the standard or profile, which
is selected in NISP. The content of the element is a a text describing
the standards or profile. The mandatory `mode` attribute describes the
status and can be chosen from on of the following self explaining
values: `unknown`, `mandatory`, `emerging`, `midterm`, `farterm` or
`fading`. N.B. the value `unknown` should only be used temporary.

The `id` attribute is also required and is a reference to the actual
standard or profile. This attribute ensures, that we do not selects
standards, which have not been defined in the database. This feature
is used by the build target _debug_  to detect errors in the database.

All `<select>` elements must have an `id` and a `mode`
attribute. The `id` attribute is a reference to an existing identifier
of a `<standard>` or a `<profile>` element.

~~~{.dtd}
<!ELEMENT select (#PCDATA)>

<!ATTLIST select
          id IDREF #REQUIRED
          mode (unknown|mandatory|emerging|midterm|
                farterm|fading) #REQUIRED>
~~~

Remarks are just text eventually embedded in paragraphs. Remarks
describes additional information about the selected standard. There
might be information which is suitable for the index, therefore
inclusion of the `<indexterm>` element.

~~~~~~~~{.dtd}
<!ELEMENT remarks (#PCDATA|para|indexterm)*>
~~~~~~~~

Rationale are just text eventually embedded in paragraphs. Rationale
describes the reason a standards was selected. There might be
information which is suitable for the index, therefore inclusion of
the `<indexterm>` element.

~~~{.dtd}
<!ELEMENT rationale (#PCDATA | para | indexterm)*>
~~~


### Mixed

The `<responsibleparties>` element descries a mapping for rp references, and is created to enable enforcement of a restricted set of responsibleparties. A rpkey element might contain one or more `<pointofcontact>` elements. 

~~~{.dtd}
<!ELEMENT responsibleparties (rpkey*)>

<!ELEMENT rpkey (pointofcontact*)>
<!ATTLIST rpkey
	  key    CDATA #REQUIRED
	  short  CDATA #REQUIRED
	  long   CDATA #REQUIRED>
~~~



~~~{.dtd}
<!ELEMENT pointofcontact EMPTY>
<!ATTLIST pointofcontact
	  name   CDATA   #REQUIRED
	  email  CDATA   #REQUIRED
	  phone  CDATA   #IMPLIED>
~~~






Community of interest profiles (COI)
------------------------------------

The `<community-of-interest>` element contains all the community-of-interest
defined profiles defined by NATO communities.

Each co profile is embedded in a `<community>` element,
which can contain multiple sub profiles represented by
`<profile>`. The `<community>` element have two mandatory
attributes `coi` and `text`. The `coi` attribute is usually an
abbreviation or shorthand form of the description of the community
contained in the `text` attribute.


~~~{.dtd}
<!ELEMENT community-of-interest (community*)>

<!ELEMENT community (profile*)>

<!ATTLIST community
          coi     CDATA      #REQUIRED
          text    CDATA      #REQUIRED>
~~~




[ISO 8601]: http://www.w3.org/TR/NOTE-datetime

<!--


Examples
--------

Here are some examples



Notes
-----


NAF 3 compliance
~~~~~~~~~~~~~~~~

The NISP database is not 100% NAF3 compliant.

The teminology used

-->




