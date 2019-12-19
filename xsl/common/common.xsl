<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- These parameters are used both in the XHTML and the FO stylesheets -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.1"
                exclude-result-prefixes="#default">


<!-- ==================================================================== -->
<!--   Global parameters used to modify the functionality of the DocBook  -->
<!--   HTML and XSL-FO stylesheets.                                       -->
<!-- ==================================================================== -->

<xsl:param name="bibliography.numbered" select="1"/>

<!-- Stylesheet Extensions -->


<!-- ==================================================================== -->
<!--   NISP Specific Parameters
-->
<!-- ==================================================================== -->

<!-- Copyright notice -->

<xsl:param name="datestamp" select="''"/>

<xsl:param name="copyright.first.year" select="'1998'"/>
<xsl:param name="copyright.last.year" select="substring($datestamp,1,4)"/>

<xsl:param name="copyright.years" select="concat($copyright.first.year, '-', 
                                                 $copyright.last.year)"/>

<!-- Get the version number from the first revision element -->

<xsl:variable name="version.major" select="substring-before(//book/bookinfo/revhistory/revision[1]/revnumber,'.')"/>
<xsl:variable name="version.minor" select="substring-after(//book/bookinfo/revhistory/revision[1]/revnumber,'.')"/>


<xsl:variable name="allied.publication.number" select="'ADatP-34'"/>

<!-- AdatP-34 edition number.
     E.g.  NISP 4.0 will be ADatP-34 edition D, NISP 4.1 - 5.0 will be ADatP-34 edition E -->

<xsl:variable name="allied.publication.edition">
  <xsl:choose>
    <xsl:when test="$version.minor=0">
      <xsl:value-of select="substring('ABCDEFGHIJKLMNOPQRSTUVWXUZ', $version.major, 1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring('ABCDEFGHIJKLMNOPQRSTUVWXUZ', $version.major+1, 1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="allied.publication.version" select="1"/>



<!-- Should we use the paragraph numbering hack ? -->

<xsl:param name="use.para.numbering" select="1"/>


<!-- Classification parameters  -->

<xsl:param name="for.internet.publication" select="0"/> <!-- Do not change this -->
<xsl:param name="internet.postfix" select="''"/>        <!-- Do not change this -->
<xsl:param name="class.label" select="'NATO/EAPC UNCLASSIFIED / RELEASABLE TO THE PUBLIC'"/>
<xsl:param name="nisp.revision" select="0"/>

<!-- ==================================================================== -->
<!--    Misc. Templates                                                   -->
<!-- ==================================================================== -->


<xsl:template name="capitalize">
  <xsl:param name="string"></xsl:param>
  <xsl:value-of
       select="translate($string,
                         'abcdefghijklmnopqrstuvwxyz',
                         'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:template>




</xsl:stylesheet>
