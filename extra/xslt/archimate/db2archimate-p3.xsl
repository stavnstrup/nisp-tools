<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:uuid="java:java.util.UUID"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="uuid"
                version='2.0'>

<xsl:output indent="yes" saxon:next-in-chain="db2archimate-p4.xsl"/>

<xsl:strip-space elements="*"/>

<xsl:output indent="yes"/>

<xsl:variable name="draft" select="'(Sample) '"/>

<xsl:variable name="nispVersion" select="'13.0'"/>
<xsl:variable name="dateCreated" select="current-dateTime()"/>
<xsl:variable name="dateAccepted" select="'2020-06-19'"/>
<xsl:variable name="acceptedDocIF" select="''"/>
<xsl:variable name="creator" select="'Interoperability Profiles Capability Team (IP CaT)'"/>
<xsl:variable name="publisher" select="'Consultation, Command and Control Board (C3B)'"/>

<!-- Version 3.0 of the C3 Taxonomy -->
<xsl:variable name="c3t-statement" select="'Generated from the ACT Enterprise Mapping Wiki on 26 Aug 2019'"/>
<xsl:variable name="c3t-date" select="'26 Aug 2019'"/>

<xsl:template match="standards">
  <model xmlns="http://www.opengroup.org/xsd/archimate/3.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengroup.org/xsd/archimate/3.0/ http://www.opengroup.org/xsd/archimate/3.1/archimate3_Diagram.xsd" identifier="id-93c48180-9e5b-4220-a666-ee020c07d53a">
    <name xml:lang="en">NISP</name>
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='creator']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="$creator"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='publisher']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="$publisher"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='dateCompleted']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="$dateAccepted"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='defaultConfidentialityMarking']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">Public</value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='abstract']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">The NISP prescribes the necessary technical standards and profiles to achieve
interoperability of Communications and Information Systems in support of NATO's missions
and operations.</value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='version']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">v13.0.1-3-gf76e5a1</value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='identifier']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">AC/322-N(2020)0024-REV1-FINAL</value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='status']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">active</value>
      </property>
      <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispVersion']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="$nispVersion"/></value>
      </property><property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='dateCreated']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="$dateCreated"/></value>
      </property>
      <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='dateAccepted']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="$dateAccepted"/></value>
      </property>
    </properties>
    <!-- Define meta-data attributes -->
    <elements xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
      <xsl:apply-templates select="records"/>
      <xsl:apply-templates select="taxonomy/node" mode="element"/>
      <xsl:apply-templates select="profiletrees//serviceprofile" mode="constraint"/>
      <xsl:apply-templates select="orglist/org" mode="element"/>
      <xsl:apply-templates select="plateaus/plateau" mode="element"/>
    </elements>
    <relationships xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
      <!-- Traverse the profiletrees -->
      <xsl:apply-templates select="/standards/profiletrees/profile" mode="listProfileRelation"/>

      <!-- List all relations between serviceprofile,constraint & taxonomy elements -->
      <xsl:apply-templates select="profiletrees//serviceprofile" mode="listConstraintRelation"/>

      <!-- Create relation from organisations to standards and coverdocs -->
      <xsl:apply-templates select="/standards/orglist/org" mode="listOrgRelation"/>

      <!-- List relations betwwen a coverdoc and the covered standards -->
      <xsl:apply-templates select="/standards/records/coverdoc" mode="listCoverStandardRelation"/>

     <!-- List relations between a plateau and standardgroups -->
     <xsl:apply-templates select="plateaus/plateau" mode="listPlateauStandardGroupRelation"/>

    </relationships>
    <!-- Organize elemets and relations -->
    <organizations xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
      <item>
        <label xml:lang="en">Business</label>
        <item>
          <label xml:lang="en">
            <xsl:text>NISP </xsl:text>
            <xsl:value-of select="$nispVersion"/>
          </label>
          <item>
            <label xml:lang="en">Organization</label>
            <xsl:apply-templates select="orglist/org" mode="organization"/>
          </item>
          <item>
            <label xml:lang="en">Agreement</label>
            <xsl:apply-templates select="records/coverdoc" mode="organization"/>
          </item>
          <item>
            <label xml:lang="en">Standard</label>
            <xsl:apply-templates select="/standards/organisations/orgkey" mode="organization"/>
          </item>
          <item>
            <label xml:lang="en">Profile</label>
            <xsl:apply-templates select="records/profile" mode="organization"/>
          </item>
          <item>
            <label xml:lang="en">Service Profile</label>
            <xsl:apply-templates select="records/serviceprofile" mode="organization"/>
          </item>
        </item>
      </item>
      <item>
        <label xml:lang="en">Technology &amp; Physical</label>
        <item>
          <label xml:lang="en">C3T</label>
          <xsl:apply-templates select="taxonomy/node" mode="organization"/>
        </item>
      </item>
      <item>
        <label xml:lang="en">Implementation &amp; Migration</label>
        <item>
          <label xml:lang="en">
            <xsl:text>NISP </xsl:text>
            <xsl:value-of select="$nispVersion"/>
          </label>
          <xsl:apply-templates select="plateaus/plateau" mode="organization"/>
        </item>
      </item>
      <item>
        <label xml:lang="en">Motivation</label>
        <item>
          <label xml:lang="en">
            <xsl:text>NISP </xsl:text>
            <xsl:value-of select="$nispVersion"/>
          </label>
          <xsl:apply-templates select="profiletrees//serviceprofile" mode="constraintOrganization"/>
        </item>
      </item>
      <item>
        <label xml:lang="en">Other</label>
        <item>
          <label xml:lang="en">
            <xsl:text>NISP </xsl:text>
            <xsl:value-of select="$nispVersion"/>
          </label>
          <item>
            <label xml:lang="en">Profile Containers</label>
            <xsl:apply-templates select="records/profilecontainer" mode="organization"/>
          </item>
          <item>
            <label xml:lang="en">Standard Groups</label>
            <xsl:apply-templates select="records/serviceprofile/refgroup" mode="organization"/>
          </item>
        </item>
      </item>
      <item>
        <label xml:lang="en">Relations</label>
        <item>
          <label xml:lang="en">
            <xsl:text>NISP </xsl:text>
            <xsl:value-of select="$nispVersion"/>
          </label>
        </item>
      </item>
      <item>
        <label xml:lang="en">Views</label>
      </item>
    </organizations>
    <propertyDefinitions xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
      <xsl:apply-templates select="/standards/allattributes/*"/>
    </propertyDefinitions>
  </model>
</xsl:template>


<xsl:template match="records">
  <!-- List all elements -->
  <xsl:apply-templates select="standard|coverdoc|profile|profilecontainer|serviceprofile|serviceprofile/refgroup" mode="element"/>
</xsl:template>



<!-- ============================================================== -->
<!--                            Elements                            -->
<!-- ============================================================== -->


<xsl:template match="standard|coverdoc" mode="element">
  <xsl:variable name="myorgid" select="document/@orgid"/>
  <xsl:variable name="rp" select="responsibleparty/@rpref"/>
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="BusinessObject">
    <name xml:lang="en"><xsl:value-of select="$draft"/>
      <xsl:if test="document/@pubnum">
        <xsl:value-of select="document/@pubnum"/>
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="document/@title"/>
    </name>
    <!--
    <documentation xml:lang="en"><xsl:apply-templates select="applicability"/></documentation>
    -->
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='identifier']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@pubnum"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='title']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@title"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='dateIssued']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@date"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='version']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@version"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispResponsibleParty']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="/standards/organisations/orgkey[@key=$rp]/@short"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='URL']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="status/uri"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="uuid"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">
          <xsl:choose>
            <xsl:when test="local-name(.)='coverdoc'">Agreement</xsl:when>
            <xsl:otherwise>Standard</xsl:otherwise>
          </xsl:choose>
        </value>
      </property>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </element>
</xsl:template>


<xsl:template match="applicability">
  <xsl:apply-templates xmlns="http://www.opengroup.org/xsd/archimate/3.0/"/>
</xsl:template>


<xsl:template match="profile"  mode="element">
  <xsl:variable name="pid" select="refprofilespec/@refid"/>
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="BusinessObject">
    <name xml:lang="en"><xsl:value-of select="$draft"/><xsl:value-of select="@title"/></name>
    <properties>
      <xsl:apply-templates select="//profilespec[@id=$pid]" mode="AddProfileSpecProperties"/>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="uuid"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">Profile</value>
      </property>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </element>
</xsl:template>


<xsl:template match="profilecontainer"  mode="element">
  <xsl:variable name="pid" select="refprofilespec/@refid"/>
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="Grouping">
    <name xml:lang="en"><xsl:value-of select="@title"/></name>
    <properties>
      <xsl:apply-templates select="//profilespec[@id=$pid]" mode="AddProfileSpecProperties"/>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="uuid"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">Profile Container</value>
      </property>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </element>
</xsl:template>

<xsl:template match="serviceprofile"  mode="element">
  <xsl:variable name="pid" select="refprofilespec/@refid"/>
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="BusinessObject">
    <name xml:lang="en"><xsl:value-of select="$draft"/><xsl:value-of select="@title"/></name>
    <documentation xml:lang="en"><xsl:value-of select="description"/></documentation>
    <properties>
      <xsl:apply-templates select="//profilespec[@id=$pid]" mode="AddProfileSpecProperties"/>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='guide']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="guide"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="uuid"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">Service Profile</value>
      </property>
      <xsl:call-template name="AddCommonProperties"/>
     </properties>
   </element>
</xsl:template>


<xsl:template match="refgroup"  mode="element">
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="Grouping">
    <name xml:lang="en">
      <xsl:value-of select="../@title"/>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@obligation"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@lifecycle"/>
      <xsl:text>)</xsl:text>
    </name>
    <documentation xml:lang="en"><xsl:value-of select="description"/></documentation>
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispObligation']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="@obligation"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispLifecycle']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="@lifecycle"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">Standard Group</value>
      </property>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </element>
</xsl:template>


<xsl:template match="node" mode="element">
  <xsl:if test="./@usenode='yes'">
    <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{@emUUID}">
      <xsl:attribute name="xsi:type">
        <xsl:choose>
          <xsl:when test="ancestor::node()[@title='Policy and Guidance']">Driver</xsl:when>
          <xsl:when test="ancestor::node()[@title='Mission Types and Tasks']">Goal</xsl:when>
          <xsl:when test="ancestor::node()[@title='Capability Hierachy']">Capability</xsl:when>
          <xsl:when test="ancestor::node()[@title='Business Processes']">BusinessProcess</xsl:when>
          <xsl:when test="ancestor::node()[@title='Information Products']">BusinessObject</xsl:when>
          <xsl:when test="ancestor::node()[@title='User Applications']">ApplicationService</xsl:when>
          <xsl:otherwise>TechnologyService</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <name xml:lang="en"><xsl:value-of select="@title"/></name>
      <!--
      <documentation xml:lang="en"><xsl:value-of select="@description"/></documentation>
      -->
      <properties>
        <property>
          <xsl:attribute name="propertyDefinitionRef">
            <xsl:text>propid-</xsl:text>
            <xsl:value-of select="/standards/allattributes/def[@attribute='creator']/@position"/>
          </xsl:attribute>
          <value>ACT</value>
        </property>
        <property>
          <xsl:attribute name="propertyDefinitionRef">
            <xsl:text>propid-</xsl:text>
            <xsl:value-of select="/standards/allattributes/def[@attribute='publisher']/@position"/>
          </xsl:attribute>
          <value>ACT</value>
        </property>
        <property>
          <xsl:attribute name="propertyDefinitionRef">
            <xsl:text>propid-</xsl:text>
            <xsl:value-of select="/standards/allattributes/def[@attribute='policyIdentifier']/@position"/>
          </xsl:attribute>
          <value>Public</value>
        </property>
        <property>
          <xsl:attribute name="propertyDefinitionRef">
            <xsl:text>propid-</xsl:text>
            <xsl:value-of select="/standards/allattributes/def[@attribute='publisher']/@position"/>
          </xsl:attribute>
          <value>Unmarked</value>
        </property>
        <property>
          <xsl:attribute name="propertyDefinitionRef">
            <xsl:text>propid-</xsl:text>
            <xsl:value-of select="/standards/allattributes/def[@attribute='C3T UUID']/@position"/>
          </xsl:attribute>
          <value><xsl:value-of select="@emUUID"/></value>
        </property>
        <property>
          <xsl:attribute name="propertyDefinitionRef">
            <xsl:text>propid-</xsl:text>
            <xsl:value-of select="/standards/allattributes/def[@attribute='C3T URL']/@position"/>
          </xsl:attribute>
          <value>
            <xsl:text>https://tide.act.nato.int/em/index.php/</xsl:text>
            <xsl:value-of select="translate(@title,' ', '_')"/>
          </value>
        </property>
        <property>
          <xsl:attribute name="propertyDefinitionRef">
            <xsl:text>propid-</xsl:text>
            <xsl:value-of select="/standards/allattributes/def[@attribute='C3T Version']/@position"/>
          </xsl:attribute>
          <value><xsl:value-of select="$c3t-statement"/></value>
        </property>
        <property>
          <xsl:attribute name="propertyDefinitionRef">
            <xsl:text>propid-</xsl:text>
            <xsl:value-of select="/standards/allattributes/def[@attribute='C3T Date']/@position"/>
          </xsl:attribute>
          <value><xsl:value-of select="$c3t-date"/></value>
        </property>
      </properties>
    </element>
  </xsl:if>
  <xsl:apply-templates mode="element"/>
</xsl:template>

<xsl:template match="serviceprofile" mode="constraint">
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{@constraintUUID}" xsi:type="Constraint">
    <name xml:lang="en"><xsl:value-of select="$draft"/><xsl:text>Conform with </xsl:text><xsl:value-of select="@title"/></name>
    <documentation xml:lang="en">
      <xsl:text>The technical service SHALL fulfil the requirements and criteria that are specified in the &apos;</xsl:text>
      <xsl:value-of select="@title"/>
      <xsl:text>&apos; either as part of the conformance clause or in the body of the specification.</xsl:text>
    </documentation>
    <properties>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </element>
</xsl:template>

<xsl:template match="org" mode="element">
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{@uuid}" xsi:type="BusinessActor">
    <name xml:lang="en"><xsl:value-of select="$draft"/><xsl:value-of select="@short"/></name>
    <documentation xml:lang="en"><xsl:value-of select="@long"/></documentation>
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='URL']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="@uri"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
        </xsl:attribute>
        <value><xsl:value-of select="@uuid"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">Organization</value>
      </property>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </element>
</xsl:template>


<xsl:template match="plateau" mode="element">
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{@uuid}" xsi:type="Plateau">
    <name xml:lang="en">
      <xsl:value-of select="$draft"/>
      <xsl:choose>
        <xsl:when test="@lifecycle='current'">Mandatory</xsl:when>
        <xsl:otherwise>Candidate</xsl:otherwise>
      </xsl:choose>
      <xsl:text> NISP </xsl:text>
      <xsl:value-of select="$nispVersion"/>
    </name>
    <properties>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </element>
</xsl:template>



<!-- ============================================================== -->
<!--                          Relationships                         -->
<!-- ============================================================== -->


<xsl:template match="profile" mode="listProfileRelation">
  <xsl:apply-templates mode="listProfileRelation"/>
</xsl:template>

<xsl:template match="profilecontainer|serviceprofile|refgroup" mode="listProfileRelation">
  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                source="id-{parent::node()/@uuid}"
                target="id-{@uuid}"
                xsi:type="Composition">
    <xsl:attribute name="identifier">
      <xsl:if test="function-available('uuid:randomUUID')">
        <xsl:text>id-</xsl:text>
        <xsl:value-of select="uuid:randomUUID()"/>
      </xsl:if>
    </xsl:attribute>
    <properties>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </relationship>
  <xsl:apply-templates mode="listProfileRelation"/>
</xsl:template>


<xsl:template match="refstandard" mode="listProfileRelation">
  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                source="id-{parent::node()/@uuid}"
                target="id-{@uuid}"
                xsi:type="Aggregation">
    <xsl:attribute name="identifier">
      <xsl:text>id-</xsl:text>
      <xsl:if test="function-available('uuid:randomUUID')">
        <xsl:value-of select="uuid:randomUUID()"/>
      </xsl:if>
    </xsl:attribute>
    <properties>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </relationship>
</xsl:template>


<xsl:template match="serviceprofile" mode="listConstraintRelation">
  <xsl:variable name="constraintId">
    <xsl:text>id-</xsl:text>
    <xsl:value-of select="@constraintUUID"/>
  </xsl:variable>

  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                source="id-{@uuid}"
                target="id-{@constraintUUID}"
                xsi:type="Association">
    <xsl:attribute name="identifier">
      <xsl:text>id-</xsl:text>
      <xsl:if test="function-available('uuid:randomUUID')">
        <xsl:value-of select="uuid:randomUUID()"/>
      </xsl:if>
    </xsl:attribute>
    <properties>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </relationship>
  <xsl:apply-templates select="reftaxonomy" mode="listConstraintRelation">
    <xsl:with-param name="constraint" select="$constraintId"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="reftaxonomy" mode="listConstraintRelation">
  <xsl:param name="constraint"/>

  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                source="id-{@uuid}"
                target="{$constraint}"
                xsi:type="Realization">
    <xsl:attribute name="identifier">
      <xsl:text>id-</xsl:text>
      <xsl:if test="function-available('uuid:randomUUID')">
        <xsl:value-of select="uuid:randomUUID()"/>
      </xsl:if>
    </xsl:attribute>
    <properties>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </relationship>
</xsl:template>

<!-- Create relation between organisations and standards and aggrements -->

<xsl:template match="org" mode="listOrgRelation">
  <xsl:apply-templates select="creatorOfStandard/reference" mode="listOrgRelation">
    <xsl:with-param name="relation" select="'is published by'"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="responsibleForStandard/reference" mode="listOrgRelation">
    <xsl:with-param name="relation" select="'is responsible for'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="reference" mode="listOrgRelation">
  <xsl:param name="relation"/>

  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                source="id-{../../@uuid}"
                target="id-{@uuid}"
                xsi:type="Association">
    <xsl:attribute name="identifier">
      <xsl:text>id-</xsl:text>
      <xsl:if test="function-available('uuid:randomUUID')">
        <xsl:value-of select="uuid:randomUUID()"/>
      </xsl:if>
    </xsl:attribute>
    <name xml:lang="en"><xsl:value-of select="$relation"/></name>
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="$relation"/></value>
      </property>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </relationship>
</xsl:template>

<!-- List relations betwwen a coverdoc and the covered standards -->

<xsl:template match="coverdoc" mode="listCoverStandardRelation">
  <xsl:apply-templates select="coverstandards/refstandard" mode="listCoverStandardRelation">
    <xsl:with-param name="coverUUID" select="uuid"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="refstandard" mode="listCoverStandardRelation">
  <xsl:param name="coverUUID"/>

  <xsl:variable name="rid" select="@refid"/>
  <xsl:variable name="stdUUID" select="/standards//standard[@id=$rid]/uuid"/>

  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                source="id-{$coverUUID}"
                target="id-{$stdUUID}"
                xsi:type="Association">
    <xsl:attribute name="identifier">
      <xsl:text>id-</xsl:text>
      <xsl:if test="function-available('uuid:randomUUID')">
        <xsl:value-of select="uuid:randomUUID()"/>
      </xsl:if>
    </xsl:attribute>
    <name xml:lang="en">is governing implementation</name>
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">is governing implementation</value>
      </property>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </relationship>
</xsl:template>

<!-- List relations between a plateau and standardgroups -->

<xsl:template match="plateau" mode="listPlateauStandardGroupRelation">
  <xsl:variable name="plateauLifeCycle" select="@lifecycle"/>
  <xsl:apply-templates select="/standards/records//refgroup[(@obligation='mandatory') and
                            (@lifecycle=$plateauLifeCycle)]" mode="listPlateauStandardGroupRelation">
    <xsl:with-param name="plateauUUID" select="@uuid"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="refgroup" mode="listPlateauStandardGroupRelation">
  <xsl:param name="plateauUUID"/>

  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                source="id-{$plateauUUID}"
                target="id-{uuid}"
                xsi:type="Association">
    <xsl:attribute name="identifier">
      <xsl:text>id-</xsl:text>
      <xsl:if test="function-available('uuid:randomUUID')">
        <xsl:value-of select="uuid:randomUUID()"/>
      </xsl:if>
    </xsl:attribute>
    <properties>
      <xsl:call-template name="AddCommonProperties"/>
    </properties>
  </relationship>
</xsl:template>

<!--
This template generates properties from the referenced profilespec element and are used to embed them
in the profile, profilecontainer and serviceprofile elements.
-->

<xsl:template match="profilespec" mode="AddProfileSpecProperties">
  <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="propertyDefinitionRef">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="/standards/allattributes/def[@attribute='title']/@position"/>
    </xsl:attribute>
    <value xml:lang="en"><xsl:value-of select="@title"/></value>
  </property>
  <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="propertyDefinitionRef">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="/standards/allattributes/def[@attribute='identifier']/@position"/>
    </xsl:attribute>
    <value xml:lang="en"><xsl:value-of select="@pubnum"/></value>
  </property>
  <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="propertyDefinitionRef">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="/standards/allattributes/def[@attribute='dateIssued']/@position"/>
    </xsl:attribute>
    <value xml:lang="en"><xsl:value-of select="@date"/></value>
  </property>
  <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="propertyDefinitionRef">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="/standards/allattributes/def[@attribute='version']/@position"/>
    </xsl:attribute>
    <value xml:lang="en"><xsl:value-of select="@version"/></value>
   </property>
</xsl:template>



<!-- ============================================================== -->
<!--                          Organization                          -->
<!-- ============================================================== -->


<xsl:template match="orgkey" mode="organization">
  <xsl:variable name="myorg" select="@key"/>
  <xsl:if test="count(/standards//document[@orgid=$myorg])  > 0">
    <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
      <label xml:lang="en"><xsl:value-of select="@short"/></label>
      <xsl:apply-templates select="/standards//standard[document/@orgid=$myorg]" mode="organization"/>
    </item>
  </xsl:if>
</xsl:template>

<xsl:template match="standard|coverdoc|profile|profilecontainer|serviceprofile|serviceprofile/refgroup" mode="organization">
  <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifierRef">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="uuid"/>
    </xsl:attribute>
  </item>
</xsl:template>

<xsl:template match="refstandard|org|plateau" mode="organization">
  <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifierRef">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="@uuid"/>
    </xsl:attribute>
  </item>
</xsl:template>

<xsl:template match="serviceprofile" mode="constraintOrganization">
  <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifierRef">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="@constraintUUID"/>
    </xsl:attribute>
  </item>
</xsl:template>

<xsl:template match="node" mode="organization">
  <xsl:if test="./@usenode='yes'">
    <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
      <xsl:attribute name="identifierRef">
        <xsl:text>id-</xsl:text>
        <xsl:value-of select="@emUUID"/>
      </xsl:attribute>
    </item>
  </xsl:if>
  <xsl:apply-templates mode="organization"/>
</xsl:template>


<!-- ============================================================== -->
<!--                      Propertydefinition                        -->
<!-- ============================================================== -->

<xsl:template match="def">
  <propertyDefinition xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifier">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="@position"/>
    </xsl:attribute>
    <xsl:attribute name="type" select="'string'"/>
    <name><xsl:value-of select="@attribute"/></name>
  </propertyDefinition>
</xsl:template>


<!-- ============================================================== -->

<xsl:template name="AddCommonProperties">
  <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="propertyDefinitionRef">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="/standards/allattributes/def[@attribute='nispVersion']/@position"/>
    </xsl:attribute>
    <value xml:lang="en"><xsl:value-of select="$nispVersion"/></value>
  </property>
  <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="propertyDefinitionRef">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="/standards/allattributes/def[@attribute='dateCreated']/@position"/>
    </xsl:attribute>
    <value xml:lang="en"><xsl:value-of select="$dateCreated"/></value>
  </property>
  <property xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="propertyDefinitionRef">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="/standards/allattributes/def[@attribute='dateAccepted']/@position"/>
    </xsl:attribute>
    <value xml:lang="en"><xsl:value-of select="$dateAccepted"/></value>
  </property>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
