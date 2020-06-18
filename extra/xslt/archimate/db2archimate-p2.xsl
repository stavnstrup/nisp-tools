<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                xmlns:uuid="java:java.util.UUID"
                version='2.0'
                exclude-result-prefixes="uuid">

<!-- ==========================================================

     Create Archimate export of all standards and profiles

     1. Remove all deleted elements
     2. Prefix all uuid's with 'id-', which is required by the Archimate Exchange Format schema
     3. Create a lookup table in order to create a propertyDefinitions list
     4. Create a relation between referencegroups and standards
     5. Add a helper tree of profile heirachy
     6. Add a helper list with a mapping from organisations to all standards and coverstandards


     ========================================================== -->

<xsl:output indent="yes" saxon:next-in-chain="db2archimate-p3.xsl"/>
<!--
<xsl:output indent="yes"/>
-->

<!-- Prefix all uuid's with 'id-'. Id's in XML MUST start with
     a letter, and we therefore go with the same solution as Archi.

     See also https://github.com/archimatetool/archi/issues/625
-->

<xsl:template match="uuid">
  <uuid>
    <xsl:text>id-</xsl:text>
    <xsl:value-of select="."/>
  </uuid>
</xsl:template>

<!-- Create a lookup table in order to create a propertyDefinitions list -->

<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select="@*"/>
    <allattributes>
      <def position="1" attribute="organisation"/>
      <def position="2" attribute="pubnum"/>
      <def position="3" attribute="title"/>
      <def position="4" attribute="date"/>
      <def position="5" attribute="version"/>
      <def position="6" attribute="responsibleparty"/>
      <def position="7" attribute="uri"/>
      <def position="8" attribute="nisp_element"/>
    </allattributes>
    <profiletrees>
      <xsl:apply-templates select="/standards//profile[@toplevel='yes']" mode="makeprofiletree"/>
    </profiletrees>
    <orglist>
      <xsl:apply-templates select="/standards/organisations/orgkey" mode="orglist"/>
    </orglist>
    <xsl:apply-templates/>
  </standards>
</xsl:template>

<!--
  Create a relation between referencegroup and standards
-->

<xsl:template match="refstandard">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="uuid">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="uuid:randomUUID()"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>


<!--
  Add a helper tree of profile heirachy
-->


<xsl:template match="profile[@toplevel='yes']" mode="makeprofiletree">
  <capabilityprofile id="{@id}" uuid="id-{./uuid}">
    <xsl:apply-templates select="subprofiles" mode="makeprofiletree"/>
  </capabilityprofile>
</xsl:template>


<xsl:template match="profile[not(@toplevel='yes')]" mode="makeprofiletree">
  <!-- We are only interested in the relationship between capabilityprofiles, serviceprofiles and
       standards - so do not list profiles in the heirachy, -->
  <xsl:apply-templates select="subprofiles" mode="makeprofiletree"/>
</xsl:template>


<xsl:template match="serviceprofile" mode="makeprofiletree">
  <serviceprofile id="{@id}">
    <xsl:apply-templates select="reftaxonomy" mode="makeprofiletree"/>
    <xsl:apply-templates select="refgroup" mode="makeprofiletree"/>
  </serviceprofile>
</xsl:template>


<xsl:template match="reftaxonomy" mode="makeprofiletree">
  <reftaxonomy refid="{@refid}"/>
</xsl:template>


<xsl:template match="subprofiles" mode="makeprofiletree">
  <xsl:apply-templates select="refprofile" mode="makeprofiletree"/>
</xsl:template>


<xsl:template match="refstandard" mode="makeprofiletree">
  <refstandard>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="uuid">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="uuid:randomUUID()"/>
    </xsl:attribute>
  </refstandard>
</xsl:template>

<xsl:template match="refprofile" mode="makeprofiletree">
  <xsl:variable name="myid" select="@refid"/>
  <xsl:apply-templates select="/standards//*[@id=$myid]" mode="makeprofiletree"/>
</xsl:template>


<xsl:template match="refgroup" mode="makeprofiletree">
  <refgroup>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="refstandard" mode="makeprofiletree"/>
  </refgroup>
</xsl:template>

<!--
  Add a helper list with a mapping from organisations to all standards and coverstandards
-->

<xsl:template match="orgkey" mode="orglist">
  <xsl:variable name="myorg" select="@key"/>
  <xsl:if test="count(/standards//document[@orgid=$myorg])  > 0">
    <org id="{$myorg}">
     <xsl:attribute name="uuid">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="uuid:randomUUID()"/>
    </xsl:attribute>
      <xsl:apply-templates select="/standards//standard[document/@orgid=$myorg]|/standards//coverdoc[document/@orgid=$myorg]" mode="orglist"/>
    </org>
  </xsl:if>
</xsl:template>


<xsl:template match="standard|coverdoc" mode="orglist">
  <reference refid="{@id}">
    <xsl:attribute name="uuid">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="uuid:randomUUID()"/>
    </xsl:attribute>
  </reference>
</xsl:template>


<!-- ========================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
