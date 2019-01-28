<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is intended for
transforming the standards database from a relational structure to
clean tree-structure.

Copyright (c) 2009-2018, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                version='1.1'
                exclude-result-prefixes="#default saxon">

<xsl:output indent="yes" />

<!-- ==================================================================== -->

  <!--
  Parameters to enable replacement of location of URI's to capability profiles
  and to update description information. -->
  <xsl:param name="capabilityprofile.list.dir"/>
  <xsl:param name="capabilityprofiles.location.pathname"/>
  <xsl:param name="capabilityprofiles.location.name"/>

  <!--
  Parameters to enable replacement of location of URI's to standard information. -->
  <xsl:param name="nisp.viewer.pathname"/>
  <xsl:param name="replace.standard.uri"/>
  <xsl:param name="use.nisp.viewer.standard.uri"/>
  <xsl:param name="nisp.viewer.standard.detail"/>
  <xsl:param name="nisp.viewer.target.type"/>

  <!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.

  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<!-- Re-create the capability profile hierachy, which is necessary when we want to create
     queries accross multiple concepts -->

<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>

    <profilehierachy>
      <xsl:apply-templates select="records/capabilityprofile[status/@mode='accepted']" mode="copyprofile"/>
    </profilehierachy>
  </standards>
</xsl:template>


<xsl:template match="capabilityprofile" mode="copyprofile">
  <capabilityprofile type="cp" id="{@id}">
    <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
  </capabilityprofile>
</xsl:template>


<xsl:template match="profile" mode="copyprofile">
  <!-- We are only interested in the relationship between capabilityprofiles, serviceprofiles and
       standards - so do not list profiles in the heirachy, -->
  <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
</xsl:template>


<xsl:template match="serviceprofile" mode="copyprofile">
  <serviceprofile id="{@id}">
    <xsl:apply-templates select="reftaxonomy" mode="copyprofile"/>
    <xsl:apply-templates select="refgroup" mode="copyprofile"/>
  </serviceprofile>
</xsl:template>


<xsl:template match="reftaxonomy" mode="copyprofile">
  <reftaxonomy refid="{@refid}"/>
</xsl:template>


<xsl:template match="subprofiles" mode="copyprofile">
  <xsl:apply-templates select="refprofile" mode="copyprofile"/>
</xsl:template>


<xsl:template match="refstandard" mode="copyprofile">
  <refstandard>
    <xsl:apply-templates select="@*"/>
  </refstandard>
</xsl:template>

<xsl:template match="refprofile" mode="copyprofile">
  <xsl:variable name="myid" select="@refid"/>
  <xsl:apply-templates select="/standards//*[@id=$myid]" mode="copyprofile"/>
</xsl:template>


<xsl:template match="refgroup" mode="copyprofile">
  <refgroup>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="refstandard" mode="copyprofile"/>
  </refgroup>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- ==================================================================== -->
  
<xsl:variable name="capabilityprofile.list" select="document(concat($capabilityprofile.list.dir,'capabilityprofiles.xml'))/capabilityprofiles"/>
<!--
  Add servicearea and docinfo information from capabilityprofile.list to the capability profile in the standards database. -->
  
<xsl:template match="capabilityprofile">
  <xsl:variable name="cpbprf.cur" select="$capabilityprofile.list/capabilityprofile[id=current()/@id]"/>
    <xsl:choose>
      <xsl:when test="$cpbprf.cur">
        <capabilityprofile id="{@id}" short="{@short}" title="{$cpbprf.cur/title}"
          servicearea="{$cpbprf.cur/servicearea}" docinfo="{$cpbprf.cur/docinfo}">
          <xsl:apply-templates/>
        </capabilityprofile>  
      </xsl:when>
      <xsl:otherwise>
        <capabilityprofile id="{@id}" short="{@short}" title="{@title}">
          <xsl:apply-templates/>
        </capabilityprofile>  
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  Replace the URI of the PDF file to the user defined location. -->
  
<xsl:template match="capabilityprofile/status/uri">
  <xsl:variable name="cpbprf.cur" select="$capabilityprofile.list/capabilityprofile[id=current()/../../@id]"/>
    <uri>
      <xsl:choose>
      <xsl:when test="$capabilityprofiles.location.pathname != 'none'">
        <xsl:value-of select="concat($capabilityprofiles.location.pathname, $cpbprf.cur/pdf, '.pdf')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$cpbprf.cur/locations/location[@name=$capabilityprofiles.location.name]"/>
      </xsl:otherwise>
    </xsl:choose>
  </uri>
  <pdf>
		<xsl:choose>
			<xsl:when test="$cpbprf.cur/pdf/@title != ''">
				<xsl:value-of select="$cpbprf.cur/pdf/@title"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$cpbprf.cur/pdf"/>
			</xsl:otherwise>
		</xsl:choose>
  </pdf>
</xsl:template>

<!--
  Replace the description information by the user defined description.
  If not specified, keep the current description. -->
  
<xsl:template match="capabilityprofile/description">
  <xsl:variable name="cpbprf.cur" select="$capabilityprofile.list/capabilityprofile[id=current()/../@id]"/>
  <xsl:choose>
    <xsl:when test="$cpbprf.cur/description/para">
      <xsl:copy-of select="$cpbprf.cur/description"/>
    </xsl:when>
    <xsl:otherwise>
      <description>
        <xsl:apply-templates/>
      </description>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
  Replace the URI of the external standard information to a link to the standard information
  available in the NISP viewer. -->

  <xsl:template match="standard/status/uri">
  <uri>
    <xsl:choose>
      <xsl:when test="not ($replace.standard.uri = 'yes')">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nisp.viewer.pathname"/>
        <xsl:choose>
          <xsl:when test="$nisp.viewer.target.type = 'local'">
            <xsl:value-of select="concat($nisp.viewer.standard.detail,'.html?refid=',../../@id)"/>
          </xsl:when>
          <xsl:when test="$nisp.viewer.target.type = 'aspdotnet'">
            <xsl:value-of select="concat($nisp.viewer.standard.detail,'.aspx?refid=',../../@id)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Use default path to NISP viewer -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </uri>
</xsl:template>

</xsl:stylesheet>
