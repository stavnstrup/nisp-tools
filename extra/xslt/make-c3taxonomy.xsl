<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:swivt="http://semantic-mediawiki.org/swivt/1.0#"
                xmlns:wiki="http://localhost/em/index.php/Special:URIResolver/"
                xmlns:property="http://localhost/em/index.php/Special:URIResolver/Property-3A"
                xmlns:wikiurl="http://localhost/em/index.php/"
                exclude-result-prefixes="xsl rdf rdfs owl swivt wiki property wikiurl"
                version='2.0'>

<!--

Apply this stylesheet to the RDF dump of the C3 taxonomy to generate a NISP version of the taxonomy.
This stylesheet will only create "level 1" nodes (i.e. nodes which are visible to the Taxonomy and
Technical Services Taxonomy Posters.

The EM-Wiki term level is not identical to the term level used in this stylesheet.

Copyright (c) 2017  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:output indent="yes"/>

<xsl:variable name="c3root" select="'http://localhost/em/index.php/Special:URIResolver/'"/>

<xsl:template match="rdf:RDF">
  <taxonomy>
    <xsl:apply-templates select="swivt:Subject[@rdf:about=concat($c3root,'Operational_Context')]">
      <xsl:with-param name="level" select="1"/>
      <xsl:with-param name="maxlevel" select="4"/>
      <xsl:sort select="property:Order" order="ascending" data-type="number"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="swivt:Subject[@rdf:about=concat($c3root,'CIS_Capabilities')]">
      <xsl:with-param name="level" select="1"/>
      <xsl:with-param name="maxlevel" select="4"/>
      <xsl:sort select="property:Order" order="ascending" data-type="number"/>
    </xsl:apply-templates>
  </taxonomy>
</xsl:template>


<xsl:template match="swivt:Subject">
  <xsl:param name="level"/>
  <xsl:param name="maxlevel" select="0"/>

  <xsl:variable name="myname" select="@rdf:about"/>
  <node title="{rdfs:label}" level="{$level}" emUUID="{property:UUID}">
    <xsl:if test="($maxlevel = 0) or ($level &lt; $maxlevel)">
      <xsl:apply-templates select="/rdf:RDF/swivt:Subject[property:Is_child_of/@rdf:resource=$myname]">
        <xsl:with-param name="level" select="$level + 1"/>
        <xsl:with-param name="maxlevel" select="$maxlevel"/>
        <xsl:sort select="property:Order" order="ascending" data-type="number"/>
      </xsl:apply-templates>
    </xsl:if>
  </node>
</xsl:template>


<!-- Change maxlevel for these subtrees i.e. main nodes in the Technical Service Framework -->

<xsl:template match="swivt:Subject[rdfs:label = 'Community Of Interest (COI) Services' or
                                   rdfs:label = 'Core Services' or
                                   rdfs:label = 'Communications Services']">
  <xsl:param name="level"/>
  <xsl:variable name="myname" select="@rdf:about"/>

  <node title="{rdfs:label}" level="{$level}" emUUID="{property:UUID}">
    <xsl:apply-templates select="/rdf:RDF/swivt:Subject[property:Is_child_of/@rdf:resource=$myname]">
      <xsl:with-param name="level" select="$level + 1"/>
      <xsl:with-param name="maxlevel" select="7"/>
      <xsl:sort select="property:Order" order="ascending" data-type="number"/>
    </xsl:apply-templates>
  </node>
</xsl:template>


<xsl:template match="swivt:Subject[rdfs:label = 'Missions and Operations'  or
                                   rdfs:label = 'Capability Hierarchy, Codes and Statements' or
                                   rdfs:label = 'Business Processes']"/>

</xsl:stylesheet>
