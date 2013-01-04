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

  <header xmlns="http://www.w3.org/1999/xhtml" id="header">
    <div class="row">
      <nav class="twelve columns" id="tophead">
        <ul class="nav-bar right" id="quickbar">
          <li><a href="{$prefix}index.html">Home</a></li>
          <li><a href="{$prefix}acronyms/index.html">Acronyms</a></li>
          <li><a href="{$prefix}member.html">Contact</a></li>
        </ul>
      </nav>
    </div>
    <div class="row">
      <div class="twelve columns" id="bottomhead"><span>NATO Interoperability Standards &amp; Profiles</span></div>
    </div>
  </header>
</xsl:template>


<xsl:template name="create-menubar">
  <xsl:param name="prefix" select="'../'"/>

  <xsl:variable name="docs" select="document('../../src/documents.xml')"/>
  <xsl:variable name="bookid" select="/book/@id"/>

  <div xmlns="http://www.w3.org/1999/xhtml" class="row">
    <nav  class="top-bar" id="menubar">
      <ul>
        <li class="name"><h1><a href="../index.html">NISP</a></h1></li>
        <li class="toggle-topbar"><a href="#"></a></li>
      </ul>
      <section>
        <ul class="left">
          <xsl:for-each select="$docs//docinfo">
            <li>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$prefix"/>
                  <xsl:value-of select="../@dir"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="./targets/target[@type='html']"/>
                </xsl:attribute>

                <xsl:attribute name="title">
                  <xsl:value-of select="./titles/longtitle"/>
                </xsl:attribute>
                <xsl:value-of select="./titles/title"/>
<!--
                <span class="show-for-small">
                  <xsl:text> - </xsl:text>
                  <xsl:value-of select="./titles/longtitle"/>
                </span>
-->
              </a>
            </li>
          </xsl:for-each>
<!--
          <li><a href="{$prefix}volume1/index.html">Vol 1</a></li>
          <li><a href="{$prefix}volume2/index.html">Vol 2</a></li>
          <li><a href="{$prefix}volume3/index.html">Vol 3</a></li>
          <li><a href="{$prefix}volume4/index.html">Vol 4</a></li>
          <li><a href="{$prefix}volume5/index.html">Vol 5</a></li>
-->
        </ul>
        <ul class="right">
          <li><a href="{$prefix}index.html">About NISP</a></li>
          <li><a  href="{$prefix}userinfo.html">User Information</a></li>
          <li><a href="{$prefix}introduction.html">Introduction</a></li>
        </ul>
      </section>
    </nav>
  </div>
</xsl:template>  


<xsl:template name="copyright.notice">
  <div xmlns="http://www.w3.org/1999/xhtml" class="row">
    <div class="twelve columns" id="footer">
      <xsl:text>Copyright &#x00A9; NATO - OTAN </xsl:text>
      <xsl:value-of select="$copyright.years"/>
      <xsl:text> | </xsl:text>
      <a href="disclaimer.html">Disclaimer</a>
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>



