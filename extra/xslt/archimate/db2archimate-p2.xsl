<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                xmlns:uuid="java:java.util.UUID"
                version='2.0'
                exclude-result-prefixes="uuid">

<!-- ==========================================================

     Create Archimate export of all standards and profiles

     1. Prefix all uuid's with 'id-', which is required by the Archimate Exchange Format schema
     2. Create a lookup table in order to create a propertyDefinitions list
     3. Create a relation between referencegroups and standards
     4. Add a helper tree of profile heirachy
     5. Add a helper list with a mapping from organisations to all standards and coverstandards


     ========================================================== -->

<xsl:output indent="yes" saxon:next-in-chain="db2archimate-p3.xsl"/>
<!--
-->

<xsl:output indent="yes"/>


<!-- Create a lookup table in order to create a propertyDefinitions list -->

<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select="@*"/>
    <allattributes>
      <def position="1" attribute="publisher"/>             <!-- orgid -->
      <def position="2" attribute="identifier"/>            <!-- pubnum -->
      <def position="3" attribute="title"/>                 <!-- title -->
      <def position="4" attribute="dateAccepted"/>
      <def position="5" attribute="version"/>               <!-- version -->
      <def position="6" attribute="nispResponsibleParty"/>  <!-- responsibleparty -->
      <def position="7" attribute="externalIdentifier"/>    <!-- uri -->
      <def position="8" attribute="stereotype"/>            <!-- N/A -->
      <def position="9" attribute="nispUUID"/>              <!-- uuid -->
      <def position="10" attribute="nispObligation"/>       <!-- obligation -->
      <def position="11" attribute="nispLifecycle"/>        <!-- lifecycle -->
      <def position="12" attribute="creator"/>
      <def position="13" attribute="policyIdentifier"/>
      <def position="14" attribute="classification"/>
      <def position="15" attribute="C3T UUID"/>
      <def position="16" attribute="C3T URL"/>
      <def position="17" attribute="C3T Version"/>
      <def position="18" attribute="C3T Date"/>
      <def position="19" attribute="guide"/>
      <def position="20" attribute="dateCompleted"/>
      <def position="21" attribute="abstract"/>
      <def position="22" attribute="status"/>
      <def position="25" attribute="nispVersion"/>
      <def position="26" attribute="URL"/>
      <def position="27" attribute="dateCreated"/>
      <def position="28" attribute="dateIssued"/>            <!-- date -->
      <def position="29" attribute="defaultConfidentialityMarking"/>
    </allattributes>
    <profiletrees>
      <xsl:apply-templates select="/standards//profile[@toplevel='yes']" mode="makeprofiletree"/>
    </profiletrees>
    <orglist>
      <xsl:apply-templates select="/standards/organisations/orgkey" mode="orglist"/>
    </orglist>
    <plateaus>
      <plateau lifecycle="current" uuid="{uuid:randomUUID()}"/>
      <plateau lifecycle="candidate" uuid="{uuid:randomUUID()}"/>
    </plateaus>
    <xsl:apply-templates/>
  </standards>
</xsl:template>


<!--
  Create a profile tree for each profile. This temporary datastructure speeds up
  quering about relations between nodes in a profile.
-->


<xsl:template match="profile[@toplevel='yes']" mode="makeprofiletree">
  <profile id="{@id}" uuid="{uuid}" spec="{refprofilespec/@refid}">
    <xsl:apply-templates select="subprofiles" mode="makeprofiletree"/>
  </profile>
</xsl:template>


<xsl:template match="profile[not(@toplevel='yes')]" mode="makeprofiletree">
  <profilecontainer id="{@id}" uuid="{uuid}" spec="{refprofilespec/@refid}">
    <xsl:apply-templates select="subprofiles" mode="makeprofiletree"/>
  </profilecontainer>
</xsl:template>


<xsl:template match="serviceprofile" mode="makeprofiletree">
  <serviceprofile id="{@id}" title="{@title}" uuid="{uuid}" spec="{refprofilespec/@refid}">
    <xsl:attribute name="constraintUUID">
      <xsl:value-of select="uuid:randomUUID()"/>
    </xsl:attribute>
    <xsl:apply-templates select="reftaxonomy" mode="makeprofiletree"/>
    <xsl:apply-templates select="refgroup" mode="makeprofiletree"/>
  </serviceprofile>
</xsl:template>


<xsl:template match="reftaxonomy" mode="makeprofiletree">
  <xsl:variable name="myid" select="@refid"/>
  <reftaxonomy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="uuid">
      <xsl:value-of select="/standards/taxonomy//node[@id=$myid]/@emUUID"/>
    </xsl:attribute>
  </reftaxonomy>
</xsl:template>


<xsl:template match="subprofiles" mode="makeprofiletree">
  <xsl:apply-templates select="refprofile" mode="makeprofiletree"/>
</xsl:template>


<xsl:template match="refstandard" mode="makeprofiletree">
  <xsl:variable name="myid" select="@refid"/>
  <refstandard>
    <xsl:attribute name="uuid">
      <xsl:value-of select="/standards/records/*[@id=$myid]/uuid"/>
    </xsl:attribute>
  </refstandard>
</xsl:template>


<xsl:template match="refprofile" mode="makeprofiletree">
  <xsl:variable name="myid" select="@refid"/>
  <xsl:apply-templates select="/standards//*[@id=$myid]" mode="makeprofiletree"/>
</xsl:template>

<xsl:template match="refgroup" mode="makeprofiletree">
  <refgroup uuid="{uuid}">
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="refstandard" mode="makeprofiletree"/>
  </refgroup>
</xsl:template>


<!--
  Add a helper list with a mapping from organisations to all standards and coverstandards
-->


<xsl:template match="orgkey" mode="orglist">
  <xsl:variable name="myorg" select="@key"/>
  <xsl:if test="count(/standards//document[@orgid=$myorg]) +
                count(/standards//responsibleparty[@rpref=$myorg])> 0">
    <org>
      <xsl:apply-templates select="@*"/>
      <creatorOfStandard>
        <xsl:apply-templates select="/standards//*[document/@orgid=$myorg]" mode="orglist"/>
      </creatorOfStandard>
      <responsibleForStandard>
        <xsl:apply-templates select="/standards//*[responsibleparty/@rpref=$myorg]" mode="orglist"/>
      </responsibleForStandard>
    </org>
  </xsl:if>
</xsl:template>

<xsl:template match="standard|coverdoc" mode="orglist">
  <xsl:variable name="myid" select="@id"/>
  <reference>
    <xsl:attribute name="uuid">
      <xsl:value-of select="/standards/records/*[@id=$myid]/uuid"/>
    </xsl:attribute>
  </reference>
</xsl:template>



<!-- Rename profiles, which are not top-level profiles to profilecontainer -->

<xsl:template match="profile[@toplevel='no']">
  <profilecontainer>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </profilecontainer>
</xsl:template>

<!-- ========================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
