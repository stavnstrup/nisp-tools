<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'>

<xsl:output method="text" indent="yes"/>

<xsl:template match="standards">
<xsl:text>// CREATE ORGANISATION VERTICESS&#x0A;</xsl:text>
<xsl:apply-templates select="organisations"/>
<xsl:text>// CREATE RESPONSIBLE PARTY VERTICES&#x0A;</xsl:text>
<xsl:apply-templates select="responsibleparties"/>
<xsl:text>// CREATE TAXONOMY NODES VERTICES&#x0A;</xsl:text>
<xsl:apply-templates select="taxonomy"/>
<xsl:text>// CREATE EDGES BETWEEN TAXONOMY NODES&#x0A;</xsl:text>
<xsl:apply-templates select="taxonomy" mode="edge"/>
<xsl:text>// CREATE STANDARD VERTICES&#x0A;</xsl:text>
<xsl:apply-templates select="records/standard"/>
<xsl:text>// CREATE INDICES</xsl:text>
</xsl:template>



<!-- ============================================
     Create Organisation vertices
     ============================================
-->

<xsl:template match="orgkey">
<xsl:text>CREATE (</xsl:text>
<xsl:value-of select="@key"/>
<xsl:text>:ORGANISATION { id: '</xsl:text>
<xsl:value-of select="@key"/>
<xsl:text>', short: '</xsl:text>
<xsl:value-of select="@short"/>
<xsl:text>', text: '</xsl:text>
<xsl:value-of select="@text"/>
<xsl:if test="@uri != ''"><xsl:text>', uri: '</xsl:text><xsl:value-of select="@uri"/></xsl:if>
<xsl:text>'})&#x0A;</xsl:text>
</xsl:template>


<!-- ============================================
     Create Responsible party vertices
     ============================================
-->

<xsl:template match="rpkey">
<xsl:text>CREATE (</xsl:text>
<xsl:value-of select="@key"/>
<xsl:text>:RESPONSIBLEPARTY { id: '</xsl:text>
<xsl:value-of select="@key"/>
<xsl:text>', short: '</xsl:text>
<xsl:value-of select="@short"/>
<xsl:text>', long: '</xsl:text>
<xsl:value-of select="@long"/>
<xsl:text>'})&#x0A;</xsl:text>
</xsl:template>


<!-- ============================================
     Create taxonomy structure
     ============================================
-->

<xsl:template match="node">
<xsl:text>CREATE (</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>:NODE {  id: '</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>', title: '</xsl:text><xsl:value-of select="@title"/>
<xsl:text>', level: '</xsl:text><xsl:value-of select="@level"/><!--
<xsl:text>', description: '</xsl:text><xsl:value-of select="@description"/>-->
<xsl:text>', emUUID: '</xsl:text><xsl:value-of select="@emUUID"/>
<xsl:text>'})&#x0A;</xsl:text>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="node" mode="edge">
<xsl:if test="parent::node">
<xsl:text>CREATE (</xsl:text>
<xsl:value-of select="../@id"/>
<xsl:text>)-[:HAS_CHILD]->(</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>)&#x0A;</xsl:text>
</xsl:if>
<xsl:apply-templates mode="edge"/>
</xsl:template>


<!-- ============================================
     Create Standard vertices
     Create edges between owners and standards
     ============================================
-->

<xsl:template match="standard">
<xsl:text>CREATE (</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>:STANDARD { id: '</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>', tag: '</xsl:text><xsl:value-of select="@tag"/>
<xsl:text>', pubnum: '</xsl:text><xsl:value-of select="document/@pubnum"/>
<xsl:text>', title: '</xsl:text><xsl:value-of select="document/@title"/>
<xsl:text>', version: '</xsl:text><xsl:value-of select="document/@version"/>
<xsl:text>', date: '</xsl:text><xsl:value-of select="document/@date"/>
<xsl:text>', applicability: '</xsl:text><xsl:value-of select="Xapplicability"/>
<xsl:text>', uri: '</xsl:text><xsl:value-of select="status/uri"/>
<!-- We are not finished with standards yet -->
<xsl:text>'})&#x0A;</xsl:text>
<xsl:text>CREATE (</xsl:text>
<xsl:value-of select="document/@orgid"/>
<xsl:text>)-[:OWNS]->(</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>)&#x0A;</xsl:text>
</xsl:template>


<xsl:match template="capabilityprofile"/>

<xsl:match template="profile"/>

<xsl:match template="serviceprofile"/>



</xsl:stylesheet>
