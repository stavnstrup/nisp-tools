<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl ="http://www.w3.org/2002/07/owl#"
	xmlns:swivt="http://semantic-mediawiki.org/swivt/1.0#"
	xmlns:wiki="http://localhost/em/index.php/Special:URIResolver/"
	xmlns:property="http://localhost/em/index.php/Special:URIResolver/Property-3A"
  exclude-result-prefixes="rdf rdfs owl swivt wiki property">
  <xsl:output method="xml"/>
  <xsl:output encoding="utf-8"/>
  <xsl:output indent="yes"/>
  <xsl:key name="subject"
           match="/rdf:RDF/swivt:Subject"
           use="substring-after(property:Is_child_of/@rdf:resource,$wiki)"/>

	<xsl:param name="id.name" select="'id'"/>
	<xsl:param name="generate.id" select="1"/>
	<xsl:param name="generate.description" select="0"/>
	<xsl:param name="generate.uuid" select="1"/>
	
	<xsl:variable name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
	<xsl:variable name="rdfs" select="'http://www.w3.org/2000/01/rdf-schema#'"/>
	<xsl:variable name="owl" select="'http://www.w3.org/2002/07/owl#'"/>
	<xsl:variable name="swivt" select="'http://semantic-mediawiki.org/swivt/1.0#'"/>
	<xsl:variable name="wiki" select="'http://localhost/em/index.php/Special:URIResolver/'"/>
	<xsl:variable name="property" select="'http://localhost/em/index.php/Special:URIResolver/Property-3A'"/>
	<xsl:variable name="wikiurl" select="'http://localhost/em/index.php?title='"/>
  <xsl:variable name="root.page.id" select="'C3_Taxonomy'"/>
  <xsl:variable name="root.page" select="/rdf:RDF/swivt:Subject[substring-after(@rdf:about,$wiki)=$root.page.id]"/>

  <xsl:template match="/">
    <taxonomy>
      <xsl:call-template name="create.node.tree">
        <xsl:with-param name="page" select="$root.page"/>
        <xsl:with-param name="page.id" select="$root.page.id"/>
        <xsl:with-param name="page.level" select="1"/>
      </xsl:call-template>
    </taxonomy>
  </xsl:template>

  <xsl:template name="create.node.tree">
    <xsl:param name="page"/>
    <xsl:param name="page.id"/>
    <xsl:param name="page.level"/>
    <xsl:variable name="page.title" select="$page/rdfs:label"/>
    <xsl:variable name="page.url" select="substring-after($page/swivt:page/@rdf:resource,$wikiurl)"/>
    <xsl:variable name="page.description" select="$page/property:Description"/>
    <xsl:variable name="page.uuid" select="$page/property:UUID"/>
    <node>
			<xsl:if test="$generate.id=1">
				<xsl:attribute name="{$id.name}"><xsl:value-of select="$page.id"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="title"><xsl:value-of select="$page.title"/></xsl:attribute>
			<xsl:attribute name="level"><xsl:value-of select="$page.level"/></xsl:attribute>
			<xsl:if test="$generate.uuid=1">
				<xsl:attribute name="emuuid"><xsl:value-of select="$page.uuid"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$generate.description=1">
				<description><xsl:value-of select="normalize-space($page.description)"/></description>
			</xsl:if>
			<xsl:for-each select="key('subject',$page.id)[property:Is_child_of/@rdf:resource=concat($wiki,$page.id)]">
				<xsl:sort select="property:Order" order="ascending" data-type="number"/>
				<xsl:variable name="child.page" select="self::node()"/>
				<xsl:variable name="child.page.id"
					select="substring-after(@rdf:about,$wiki)"/>
				<xsl:call-template name="create.node.tree">
					<xsl:with-param name="page" select="$child.page"/>
					<xsl:with-param name="page.id" select="$child.page.id"/>
					<xsl:with-param name="page.level" select="$page.level + 1"/>
				</xsl:call-template>
      </xsl:for-each>
    </node>
  </xsl:template>
    
</xsl:stylesheet>