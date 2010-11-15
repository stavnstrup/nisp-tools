<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.1"
                exclude-result-prefixes="#default">


<xsl:import href="../docbook-xsl/htmlhelp/htmlhelp.xsl"/>
<xsl:import href="../common/common.xsl"/>



<!-- ==================================================================== -->
<!--  Global parameters used to modify the functionality of the Chunked   -->
<!--  DocBook  XHTML stylesheets                                          -->
<!-- ==================================================================== -->


<!-- ToC/LoT/Index Generation -->

<xsl:param name="generate.toc">
 book figure,table
 set toc
</xsl:param>


<xsl:param name="generate.index" select="0"/>



<!-- Automatic Labeling -->

<xsl:param name="section.autolabel" select="1"/>

<xsl:param name="section.label.includes.component.label" select="1"/>


<!-- Extensions -->

<xsl:param name="use.extensions" select="1"/>

<!-- HTML  -->

<xsl:param name="html.stylesheet">htmlhelp.css</xsl:param>

<!-- XSLT Processing -->

<xsl:param name="suppress.navigation" select="0"/>


<!-- Miscellaneous -->

<xsl:param name="show.comments" select="0"/>


<!-- Chunking -->

<xsl:param name="chunker.output.encoding" select="'iso-8859-1'"/>

<xsl:param name="saxon.character.representation" select="'native'"/>


<!-- HTML Help -->

<xsl:param name="htmlhelp.encoding" select="'iso-8859-1'"/>

<xsl:param name="htmlhelp.autolabel" select="1"/>

<xsl:param name="htmlhelp.chm" select="concat('nisp-' , $nisp-ver, '.chm')"/>    

<xsl:param name="htmlhelp.enumerate.images" select="1"/>

<xsl:param name="htmlhelp.hhc.show.root" select="0"/>

<xsl:param name="htmlhelp.hhc.folders.instead.books" select="1"/>

<xsl:param name="htmlhelp.title" select="concat('NISP Version ', $nisp-ver)"/>

<xsl:param name="htmlhelp.button.next" select="1"/>

<xsl:param name="htmlhelp.button.prev" select="1"/>

<xsl:param name="htmlhelp.use.hhk" select="1"/>

<xsl:param name="htmlhelp.only" select="0"/>
         

<!-- ==================================================================== -->
<!--   NISP Specific Parameters                                           -->
<!-- ==================================================================== -->

<xsl:variable name="nisp-ver"> 
  <xsl:value-of select="document('../../src/documents.xml')/documents/versioninfo/package/@major"/>
  <xsl:text>.</xsl:text>
  <xsl:value-of select="document('../../src/documents.xml')/documents/versioninfo/package/@minor"/>
</xsl:variable>

<!-- ==================================================================== -->
<!-- Customized DocBook templates                                         -->
<!-- ==================================================================== -->

<xsl:template match="revhistory" mode="titlepage.mode">
  <p>
    <b>Version</b>: <xsl:value-of select="revision[1]/revnumber"/><br />
    <b>Date</b>: <xsl:value-of select="revision[1]/date"/>
  </p>
</xsl:template>

<!-- ==================================================================== -->

<!-- We don't use beginpage here, however it is parts of some documents
     and tells the fo stylesheet, when a page-break should be enforced -->

<xsl:template match="beginpage"/>

<!-- ==================================================================== -->

<!-- Special NISP Paranumbering. The use.para.numbering variable is
     defined in the file common/common.xsl -->

<xsl:template match="chapter/para
                     |appendix/para
                     |sect1/para
                     |sect2/para
                     |sect3/para
                     |sect4/para
                     |sect5/para">
  <p>
    <xsl:if test="$use.para.numbering != 0">
      <xsl:text></xsl:text>
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

<!-- ==================================================================== -->

<xsl:template match="setinfo/releaseinfo" mode="set.titlepage.recto.mode">
  <p>Release number: <xsl:value-of select="$nisp-ver"/><br />
  Release date: <xsl:value-of 
     select="document('../../src/documents.xml')/documents/versioninfo/release/@date"/></p>
  <p>This set consists of the following documents:</p>
  <ul>
    <xsl:for-each select="//book[position() &gt; 0]">
      <li><a><xsl:attribute name="href"><xsl:value-of
        select="concat('bk0', position() ,'.html')"/></xsl:attribute><xsl:value-of 
        select="./bookinfo/title"/></a><xsl:text>, ver. </xsl:text><xsl:value-of 
        select="./bookinfo/revhistory/revision[1]/revnumber"/><xsl:text> (</xsl:text><xsl:value-of
        select="./bookinfo/revhistory/revision[1]/date"/><xsl:text>)</xsl:text></li>
    </xsl:for-each>
  </ul>
</xsl:template>

</xsl:stylesheet>
