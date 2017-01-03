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

Copyright (c) 2017  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:output indent="yes"/>

<xsl:variable name="c3root" select="'http://localhost/em/index.php/Special:URIResolver/'"/>

<xsl:template match="rdf:RDF">
  <taxonomy>
    <xsl:apply-templates select="swivt:Subject[property:Is_child_of/@rdf:resource=concat($c3root,'C3_Taxonomy')]">
      <xsl:with-param name="level" select="1"/>
    </xsl:apply-templates>
  </taxonomy>
</xsl:template>


<xsl:template match="swivt:Subject">
  <xsl:param name="level"/>

  <xsl:variable name="myname" select="@rdf:about"/>

  <node title="{rdfs:label}" level="{$level}" emUUID="{property:UUID}">
    <xsl:apply-templates select="/rdf:RDF/swivt:Subject[property:Is_child_of/@rdf:resource=$myname]">
      <xsl:with-param name="level" select="$level + 1"/>
    </xsl:apply-templates>
  </node>
</xsl:template>

<!-- As of January 2, 2017 - 62 nodes in the Operational Context do not have an UUID, so for the time being,
     we will exclude that part of the taxonomy. We btw- only need the Information Products sub tree -->
<xsl:template match="swivt:Subject[rdfs:label = 'Operational Context']"/>

</xsl:stylesheet>
