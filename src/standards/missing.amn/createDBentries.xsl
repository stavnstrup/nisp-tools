<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:swivt="http://semantic-mediawiki.org/swivt/1.0#"
                xmlns:wiki="http://tide.act.nato.int/em/index.php?title=Special:URIResolver/"
                xmlns:property="http://tide.act.nato.int/em/index.php?title=Special:URIResolver/Property-3A"
                exclude-result-prefixes="rdf rdfs owl swivt wiki property saxon xs xdt"
                version='2.0'>

<xsl:output indent="yes"/>




<xsl:variable name="now">
  <xsl:value-of select="substring-before(xs:string(current-dateTime()), 'T')"/>
</xsl:variable>



<xsl:param name="wiki" select="'http://tide.act.nato.int/em/index.php?title=Special:URIResolver/'"/>

<xsl:param name="rdffile_prefix" select="'RFC_'"/>


<xsl:param name="nispVersion" select="'7.1'"/>


<xsl:template match="missing-amn-standards">
  <amn><xsl:apply-templates/></amn>
</xsl:template>

<xsl:template match="knockoff-emwiki[@type='rfc']">
  <xsl:variable name="rdfimport" select="concat($rdffile_prefix, format-number(@std,'0000'), '.rdf')"/>
  <xsl:apply-templates select="document($rdfimport)/rdf:RDF">
    <xsl:with-param name="orgid" tunnel="yes" select="'ietf'"/>
    <xsl:with-param name="pubnum" tunnel="yes" select="concat('rfc',format-number(@std,'####'))"/>
    <xsl:with-param name="tag" tunnel="yes" select="@tag"/>
  </xsl:apply-templates>
</xsl:template> 


<xsl:template match="knockoff-emwiki[@type='w3c']">
  <xsl:variable name="rdfimport" select="concat(@id, '.rdf')"/>
  <xsl:apply-templates select="document($rdfimport)/rdf:RDF">
    <xsl:with-param name="orgid" tunnel="yes" select="'w3c'"/>
    <xsl:with-param name="pubnum" tunnel="yes" select="@id"/>
    <xsl:with-param name="tag" tunnel="yes" select="@tag"/>
  </xsl:apply-templates>
</xsl:template> 




<xsl:template match="rdf:RDF">
  <xsl:apply-templates select="swivt:Subject"/>
</xsl:template>


<xsl:template match="swivt:Subject">
  <xsl:param name="orgid" tunnel="yes"/>
  <xsl:param name="pubnum" tunnel="yes"/>
  <xsl:param name="tag" tunnel="yes"/>

  <standard>
    <xsl:attribute name="id">
      <xsl:value-of select="concat($orgid,'-',$pubnum)"/>
    </xsl:attribute>
    <xsl:attribute name="tag">
      <xsl:value-of select="$tag"/>
    </xsl:attribute>
    <document orgid="{$orgid}" pubnum="{$pubnum}">
      <xsl:attribute name="title">
        <xsl:value-of select="property:Title"/>
      </xsl:attribute>
      <xsl:attribute name="date">
        <xsl:value-of select="substring-before(property:Version_date, 'T')"/>
      </xsl:attribute>
<!--
      <xsl:attribute name="version">
      </xsl:attribute>
-->
      <applicability><xsl:value-of select="property:Description"/></applicability>
      <status mode="unknown">
        <uri><xsl:value-of select="property:Link/@rdf:resource"/></uri>
        <history>
          <event flag="added" date="{$now}" rfcp="" version="{$nispVersion}"/>
        </history>
      </status>
    </document>
  </standard>
</xsl:template>


<xsl:template match="standard">
  <standard tag="{@tag}">
    <xsl:attribute name="id">
      <xsl:if test="document/@orgid">
        <xsl:value-of select="document/@orgid"/>
      </xsl:if>
      <xsl:if test="(document/@orgid != '') and (document/@pubnum != '')">
        <xsl:text>-</xsl:text>
      </xsl:if>
      <xsl:value-of select="document/@pubnum"/>
    </xsl:attribute>
    <xsl:apply-templates select="document"/>
    <status>
      <xsl:if test="./uri">
        <uri><xsl:value-of select="./uri"/></uri>
      </xsl:if>
      <history>
        <event flag="added" date="{$now}" rfcp=""  version="{$nispVersion}"/>
      </history>
    </status>
  </standard>   
</xsl:template>



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
