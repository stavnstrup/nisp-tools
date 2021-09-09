<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is intended for
renaming profiles with the attribute  toplevel="yes" to capabilityprofile. This will ensure
the old resolve-nodes.xsl stylesheet will continue to work and display mandatory and candidate
standards in NISP volume 2 and 3.

Copyright (c) 2019, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="saxon">

<xsl:output saxon:next-in-chain="db-resolve-p3.xsl"/>

<xsl:strip-space elements="*"/>

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
  Add servicearea and docinfo information from capabilityprofile.list to the toplevel profile in the standards database. -->
  
<xsl:template match="profile[@toplevel='yes']">
  <xsl:variable name="cpbprf.cur" select="$capabilityprofile.list/capabilityprofile[id=current()/@id]"/>
    <xsl:choose>
      <xsl:when test="$cpbprf.cur">
        <capabilityprofile toplevel="yes" id="{@id}" short="{@short}" title="{$cpbprf.cur/title}"
          servicearea="{$cpbprf.cur/servicearea}" docinfo="{$cpbprf.cur/docinfo}">
          <xsl:apply-templates/>
        </capabilityprofile>  
      </xsl:when>
      <xsl:otherwise>
        <capabilityprofile>
					<xsl:apply-templates match="@*"/>
          <xsl:apply-templates/>
        </capabilityprofile>  
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  Replace the URI of the PDF file to the user defined location. -->
  
<xsl:template match="profile[@toplevel='yes']/status/uri">
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
  
<xsl:template match="profile[@toplevel='yes']/description">
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

  <xsl:template match="standard/status/uri | coverdoc/status/uri">
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
