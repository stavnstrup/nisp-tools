<!--

This stylesheet is created for the NC3 Technical Architecture, and contains
intended for the one-page HTML version.

Copyright (c) 2001, 2006 Jens Stavnstrup/DDRE <js@ddre.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<!-- parameters for output media -->



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


 
</xsl:stylesheet>
