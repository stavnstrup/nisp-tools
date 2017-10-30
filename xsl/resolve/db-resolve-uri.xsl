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
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:output method="xml" version="1.0" encoding="ISO-8859-1"/>

<!-- ==================================================================== -->
	<xsl:param name="capabilityprofile.list.dir"/>
	<xsl:param name="capabilityprofiles.location.pathname"/>
	<xsl:param name="capabilityprofiles.location.name"/>
  <xsl:variable name="capabilityprofile.list" select="document(concat($capabilityprofile.list.dir,'capabilityprofiles.xml'))/capabilityprofiles"/>

<xsl:template match="/">
  <xsl:comment>
<xsl:value-of select="$capabilityprofile.list.dir"/>
     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.
     
  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>  

<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="capabilityprofile/status/uri">
	<xsl:variable name="cpbprf.id" select="../../@id"/>
	<uri>
		<xsl:choose>
			<xsl:when test="$capabilityprofiles.location.pathname != 'none'">
				<xsl:value-of select="concat($capabilityprofiles.location.pathname, $capabilityprofile.list/capabilityprofile[id=$cpbprf.id]/pdf, '.pdf')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$capabilityprofile.list/capabilityprofile[id=$cpbprf.id]/locations/location[@name=$capabilityprofiles.location.name]"/>
			</xsl:otherwise>
		</xsl:choose>
	</uri>
	<pdf>
		<xsl:value-of select="$capabilityprofile.list/capabilityprofile[id=$cpbprf.id]/pdf"/>
	</pdf>
</xsl:template>

</xsl:stylesheet>
