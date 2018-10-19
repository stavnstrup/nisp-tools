<?xml version="1.0" encoding="ISO-8859-1"?>
<!--

This stylesheet is created for the NISP, and is intended for
transforming the standards database from a relational structure to
clean tree-structure.


Copyright (c) 2009-2010, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and 
NATO Command, Control and Consultation Organisation (NC3O).


-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                exclude-result-prefixes="#default">

	<xsl:output method="xml" indent="yes" encoding="ISO-8859-1"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="capabilityprofile.list.dir"/>
	<xsl:param name="capabilityprofiles.location.pathname"/>
	<xsl:param name="capabilityprofiles.location.name"/>
	<xsl:variable name="capabilityprofile.list" select="document(concat($capabilityprofile.list.dir,'capabilityprofiles.xml'))/capabilityprofiles"/>

<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>
     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.
     
  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>  

<!-- ==================================================================== -->

<!-- ==================================================================== -->

<!-- Re-create the capability profile hierachy, which is necessary when we want to create
     queries accross multiple concepts -->

<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
    <profilehierachy>
      <capabilityprofile type="bsp">
        <xsl:apply-templates select="/standards//bpserviceprofile" mode="copyprofile"/>
      </capabilityprofile>
      <xsl:apply-templates select="records/capabilityprofile[status/@mode='accepted']" mode="copyprofile"/>
    </profilehierachy>
  </standards>
</xsl:template>


<xsl:template match="bpserviceprofile" mode="copyprofile">
  <serviceprofile>
    <reftaxonomy refid="{@tref}"/>
    <xsl:apply-templates mode="copyprofile"/>
  </serviceprofile>
</xsl:template>

<xsl:template match="bpgroup" mode="copyprofile">
  <obgroup obligation="{@mode}">
    <xsl:apply-templates mode="copyprofile"/>
  </obgroup>
</xsl:template>

<xsl:template match="bprefstandard" mode="copyprofile">
  <hrefstandard refid="{@refid}"/>
</xsl:template>




<xsl:template match="capabilityprofile" mode="copyprofile">
  <capabilityprofile type="cp" id="{@id}">
    <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
  </capabilityprofile>
</xsl:template>

<xsl:template match="profile" mode="copyprofile">
  <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
</xsl:template>


<xsl:template match="serviceprofile" mode="copyprofile">
  <serviceprofile id="{@id}">
    <xsl:apply-templates select="reftaxonomy" mode="copyprofile"/>
    <xsl:apply-templates select="obgroup" mode="copyprofile"/>
  </serviceprofile>
</xsl:template>



<xsl:template match="reftaxonomy" mode="copyprofile">
  <reftaxonomy refid="{@refid}"/>
</xsl:template>

<xsl:template match="subprofiles" mode="copyprofile">
  <xsl:apply-templates select="refprofile" mode="copyprofile"/>
</xsl:template>


<xsl:template match="refstandard" mode="copyprofile">
  <hrefstandard>
    <xsl:apply-templates select="@*"/>
  </hrefstandard>
</xsl:template>

<xsl:template match="refprofile" mode="copyprofile">
  <xsl:variable name="myid" select="@refid"/>
  <xsl:apply-templates select="/standards//*[@id=$myid]" mode="copyprofile"/>
</xsl:template>


<xsl:template match="obgroup" mode="copyprofile">
  <obgroup>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="refstandard" mode="copyprofile"/>
  </obgroup>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

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
		<xsl:value-of select="$cpbprf.cur/pdf"/>
	</pdf>
</xsl:template>

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

</xsl:stylesheet>
