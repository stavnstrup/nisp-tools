<!--

This stylesheet is created for the NATO Interoperability Standards and
Profiles (NISP), and contains intended for the one-page HTML version.

Copyright (c) 2001, 2016 Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">


<xsl:import href="../common/common.xsl"/>

<!-- parameters for output media -->

<xsl:param name="describe" select="''"/>



<!-- Titlepage stuff should follow the NISP style :

  <book/title>
  VOLUME <book/volumenum> - <subtitle>
  Version <../revision[1]/revnumber> [<../revision[1]/revdate>] - <corpauthor>

  We cheat a little by overriding corpauthor and subtitle.

  A standard titlepage also prints, pubdate and revisionhistory - get rid
  of those.

-->


<xsl:template name="book.titlepage.separator"/>



<xsl:template match="corpauthor" mode="titlepage.mode">
  <div class="{name(.)}">Version <xsl:apply-templates select="..//revision[1]/revnumber"
             mode="titlepage.mode"/> [<xsl:apply-templates
             select="..//revision[1]/date"
             mode="titlepage.mode"/>] - <xsl:apply-templates
             mode="titlepage.mode"/>
  </div>
</xsl:template>


<xsl:template match="book" mode="titlepage.mode"/>

<xsl:template match="//*/bookinfo/subtitle" mode="titlepage.mode">
  <xsl:variable name="volume">
    <xsl:apply-templates select="../volumenum" mode="titlepage.mode"/>
  </xsl:variable>
  <div class="book-subtitle"><xsl:if test="$volume &lt; 5">VOLUME <xsl:number
       format="I" value="$volume"/> - </xsl:if><xsl:apply-templates
       mode="titlepage.mode"/>
  </div>
</xsl:template>


<xsl:template match="revhistory" mode="titlepage.mode"/>


<xsl:template match="chapter/para
                     |appendix/para
                     |sect1/para
                     |sect2/para
                     |sect3/para
                     |sect4/para
                     |sect5/para">
  <p>
    <xsl:if test="$use.para.numbering != 0">
      <xsl:number from="book"
                 count="para[parent::chapter or
                             parent::appendix or
                             parent::sect1 or
                             parent::sect2 or
                             parent::sect3 or
                             parent::sect4 or
                             parent::sect5
                               ]" format="1" level="any"/>
      <xsl:text>. </xsl:text>

    </xsl:if>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<xsl:template name="create-header">
  <xsl:param name="prefix" select="'../'"/>

  <header xmlns="http://www.w3.org/1999/xhtml" id="header" class="hide-for-small">
    <xsl:if test="$nisp.lifecycle.stage != 'release'">
      <div class="nisp-lifecycle-stage">
        <xsl:text>NISP </xsl:text>
        <xsl:choose>
          <xsl:when test="$nisp.lifecycle.stage='draft'">DRAFT - rev. <xsl:value-of select="$describe"/></xsl:when>
          <xsl:when test="$nisp.lifecycle.stage='final'">FINAL DRAFT - rev. <xsl:value-of select="$describe"/></xsl:when>
	</xsl:choose>
      </div>
    </xsl:if>
    <div class="nisp">NATO Interoperability Standards and Profiles</div>
    <div class="banner"/>
  </header>
</xsl:template>


<xsl:template name="create-menubar">
  <xsl:param name="prefix" select="'../'"/>

  <xsl:variable name="docs" select="document('../../src/documents.xml')"/>
  <xsl:variable name="bookid" select="/book/@id"/>

  <div xmlns="http://www.w3.org/1999/xhtml" class="nav-container">
    <div class="row">
      <div class="twelve columns">
        <div class="contain-to-grid">
          <nav  class="top-bar">
            <ul>
              <li class="name"><a href="{$prefix}index.html">NISP</a></li>
              <li class="toggle-topbar"><a href="#"></a></li>
            </ul>
            <section>
              <ul class="left">
                <xsl:for-each select="$docs//docinfo">
                  <li>
                    <xsl:if test="./@id=$bookid">
                      <xsl:attribute name="class">active</xsl:attribute>
                    </xsl:if>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:value-of select="$prefix"/>
                        <xsl:value-of select="../@dir"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="./targets/target[@type='html']"/>
                      </xsl:attribute>
                      <xsl:attribute name="title">
                        <xsl:value-of select="./titles/title"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="./titles/longtitle"/>
                      </xsl:attribute>
                      <xsl:value-of select="./titles/menutitle"/>
                    </a>
                  </li>
                </xsl:for-each>
              </ul>
            </section>
          </nav>
        </div>
      </div>
    </div>
  </div>
</xsl:template>


<xsl:template name="nisp.footer">
  <xsl:param name="prefix" select="'../'"/>

  <footer xmlns="http://www.w3.org/1999/xhtml">
    <div class="row">
      <div class="twelve columns centered">
        <div class="footernav">
          <a href="{$prefix}index.html">Home</a> |
          <a href="{$prefix}userinfo.html">User Information</a> |
          <a href="{$prefix}introduction.html">Introduction</a> |
          <a href="{$prefix}acronyms/index.html">Acronyms</a> |
          <a href="{$prefix}PDFcoverdoc.html">Get NISP in PDF</a> |
          <a href="https://nhqc3s.hq.nato.int/Apps/Architecture/NISP2/">Search NISP DB</a>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="twelve columns">
        <div class="copyright">
          <xsl:text>Copyright &#x00A9; NATO - OTAN </xsl:text>
          <xsl:value-of select="$copyright.years"/>
          <xsl:text> | </xsl:text>
          <a href="{$prefix}disclaimer.html">Disclaimer</a>
        </div>
      </div>
    </div>
    <xsl:if test="$nisp.lifecycle.stage != 'release'">
      <div class="nisp-lifecycle-stage">
        <xsl:text>NISP </xsl:text>
        <xsl:choose>
          <xsl:when test="$nisp.lifecycle.stage='draft'">DRAFT - rev. <xsl:value-of select="$describe"/></xsl:when>
          <xsl:when test="$nisp.lifecycle.stage='final'">FINAL DRAFT - rev. <xsl:value-of select="$describe"/></xsl:when>
	      </xsl:choose>
      </div>
    </xsl:if>
  </footer>
</xsl:template>


</xsl:stylesheet>
