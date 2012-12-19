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



<xsl:template name="create-header">
  <xsl:param name="prefix" select="'../'"/>

  <div xmlns="http://www.w3.org/1999/xhtml" id="header">
    <div id="tophead">
      <span id="quickMenu"><a href="{$prefix}index.html">Home</a> | 
        <a href="{$prefix}acronyms/index.html">Acronyms</a> | <a href="{$prefix}member.html">Contact</a></span>
    </div>

    <div id="bottomhead"><span>NATO Interoperability Standards &amp; Profiles</span></div>
  </div>
</xsl:template>


<xsl:template name="create-menubar">
  <xsl:param name="prefix" select="'../'"/>

  <div xmlns="http://www.w3.org/1999/xhtml" id="menubar">
    <a href="{$prefix}index.html">About NISP</a>
    <a  href="{$prefix}userinfo.html">User Information</a>
    <a href="{$prefix}introduction.html">Introduction</a>
  </div>
</xsl:template>  


<xsl:template name="copyright.notice">
  <div xmlns="http://www.w3.org/1999/xhtml" id="footer">
    <xsl:text>Copyright &#x00A9; NATO - OTAN </xsl:text>
    <xsl:value-of select="$copyright.years"/>
    <xsl:text> | </xsl:text>
    <a href="disclaimer.html">Disclaimer</a>
  </div>
</xsl:template>

</xsl:stylesheet>



