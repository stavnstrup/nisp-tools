<?xml version='1.0'?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY scope 'count(ancestor::node()|$scope) = count(ancestor::node())
                and ($role = @role or $type = @type or
                (string-length($role) = 0 and string-length($type) = 0))'>

]>

<!--

Name        : fo-common.xsl

Description : This stylesheet is a customization of Norman Walsh DocBook
              XSL-FO stylesheets  and is used to create a XSL-FO version of 
              the technical architecture. The stylesheet create as output 
              XSL-FO files according to the Word Wide Webs Consortiums 
              specification: "Extensible Stylesheet Language" version 1.0. 
              (see: http://www.w3c.org/REC/2001/XSL.html).

              This stylesheet contains the common modifications to the
              DocBook specifications need by the Technical Architecture. This
              stylesheet is not actually used, but is imported by other
              stylesheets.

              Copyright (C) 2001-2003 Jens Stavnstrup/DDRE <js@ddre.dk>,
              Danish Defence Research Establishment (DDRE) and 
              NATO Command, Control and Consultation Organisation.(NC3O)
-->



<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'
                xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
                xmlns:xtbl="com.nwalsh.xalan.Table"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:fox="http://xml.apache.org/fop/extensions"
                exclude-result-prefixes="#default stbl xtbl fox saxon">

<!-- Fix DocBook-XSL Bugs -->


<!-- ==================================================================== -->
<!--   Global parameters used to modify the functionality of the DocBook  -->
<!--   XSL/FO stylesheets.                                                -->
<!-- ==================================================================== -->

<!-- ToC/LoT/Index Generation -->

<xsl:param name="generate.toc">
  book toc,title
</xsl:param>

<xsl:variable name="toc.section.depth">2</xsl:variable>


<!-- Automatic labelling -->

<xsl:param name="appendix.autolabel" select="'A'"/>

<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>

<!-- Tables -->

<xsl:param name="default.table.width" select="'16cm'"/>


<!-- Miscellaneous -->

<xsl:param name="formal.title.placement">
  figure after
  table after
</xsl:param>

<xsl:param name="show.comments" select="0"/>
<xsl:param name="ulink.show" select="1"/>
<xsl:param name="ulink.hyphenate" select="''"/>


<!-- Pagination and General Styles-->

<xsl:param name="paper.type" select="'A4'"/>
<xsl:param name="double.sided" select="1"/>

<!-- The letter A-H refers to the figure describing page 
     setup in the DocBook XSL-FO documentation -->

<xsl:param name="page.margin.top" select="'15mm'"/>        <!-- A -->
<xsl:param name="region.before.extent" select="'42pt'"/>   <!-- B -->
<xsl:param name="body.margin.top" select="'56pt'"/>        <!-- C -->

<xsl:param name="region.after.extent" select="'36pt'"/>    <!-- D -->
<xsl:param name="page.margin.bottom" select="'15mm'"/>     <!-- E -->
<xsl:param name="body.margin.bottom" select="'60pt'"/>     <!-- F -->

<xsl:param name="page.margin.inner" select="'25mm'"/>      <!-- G -->
<xsl:param name="page.margin.outer" select="'25mm'"/>      <!-- H -->

<xsl:param name="body.start.indent" select="'0pc'"/>

<xsl:param name="body.font.master" select="12"/>

<xsl:param name="title.margin.left" select="'0pc'"/>

<xsl:param name="draft.mode" select="'no'"/> <!-- maybee -->
<xsl:param name="draft.watermark.image" select="''"/>

<xsl:param name="headers.on.blank.pages" select="1"/>
<xsl:param name="footers.on.blank.pages" select="1"/>

<xsl:param name="header.rule" select="0"/>
<xsl:param name="footer.rule" select="0"/>


<!-- Font Families -->

<!-- Use only the build-in Adobe Fonts (Supported by PDF) :
     Times, Courier, Helvetica, Symbol and Zapf Dingbats -->

<xsl:param name="body.font.family" select="'Times'"/>
<xsl:param name="title.font.family" select="'Times'"/>
<!--
<xsl:param name="dingbat.font.family" select="'Zapf Dingbats'"/>
-->
<xsl:param name="monospace.font.family" select="'Courier'"/>
<xsl:param name="sans.font.family" select="'Helvetica'"/>


<xsl:param name="preferred.mediaobject.role" select="'fop'"/>

<!-- FO -->

<xsl:param name="xref.with.number.and.title" select="0"/>


<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="font-size">
    <xsl:text>16pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level2.properties">
  <xsl:attribute name="font-size">
    <xsl:text>16pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level3.properties">
  <xsl:attribute name="font-size">
    <xsl:text>16pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level4.properties">
  <xsl:attribute name="font-size">
    <xsl:text>15pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>



<xsl:param name="stylesheet.result.type" select="'fo'"/>


<xsl:attribute-set name="formal.title.properties"
                   use-attribute-sets="normal.para.spacing">
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>

<!-- ==================================================================== -->
<!--   NC3TA Specific Parameters .                                        -->
<!-- ==================================================================== -->


<!-- External stylesheet parameter -->

<xsl:param name="pdf.prefix" select="''"/>

<!-- For Internet distribution - we don't want any classification label -->

<xsl:param name="for.internet.publication" select="0"/> <!--  Do not change this Wouter ! -->

<xsl:param name="class.label" select="'NATO/EAPC UNCLASSIFIED'"/>

<xsl:param name="releasability.label"
           select="'RELEASABLE FOR INTERNET TRANSMISSION'"/>


<!-- Put special text on the blank page (This will properly be part of the
     official DocBook stylesheet collection) -->

<xsl:param name="special.blankpage" select="0"/> <!-- Does not work with FOP yet -->

<xsl:param name="blank.text" select="'This page is left blank intentionally'"/>


<!-- ==================================================================== -->
<!--  Specific Parameters                                                 -->
<!-- ==================================================================== -->





<!-- ==================================================================== -->
<!-- Define standard page headers for even- and odd pages                 -->
<!-- ==================================================================== -->


<!-- Set name of resulting document (without extension) e.g. NC3TA-Vol1 -->

<xsl:variable name="docname">
  <xsl:value-of select="$pdf.prefix"/>

  <xsl:variable name="revision" select="//book/bookinfo/revhistory/revision[1]/revnumber"/>

  <xsl:text>-v</xsl:text>
  <xsl:choose>
    <xsl:when test="contains($revision,'.')">
      <xsl:value-of select=
          "substring-before($revision,'.')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$revision"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>.xml</xsl:text>
</xsl:variable>



<xsl:template name="genhead.left.right">
  <xsl:param name="left"></xsl:param>
  <xsl:param name="right"></xsl:param>

  <fo:list-block provisional-distance-between-starts="4.0in"
                 provisional-label-separation="0pt">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="start"><xsl:value-of select="$left"/></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block text-align="end"><xsl:value-of
                  select="$right"/></fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </fo:list-block>
	</xsl:template>


<xsl:variable name="even.page.head">
  <xsl:call-template name="genhead.left.right">
    <xsl:with-param name="left"><xsl:value-of   
                    select="$docname"/></xsl:with-param>
    <xsl:with-param name="right"><xsl:value-of 
                    select="//book/bookinfo/biblioid"/></xsl:with-param>
  </xsl:call-template>
</xsl:variable>


<xsl:variable name="odd.page.head">
  <xsl:call-template name="genhead.left.right">
    <xsl:with-param name="left"><xsl:value-of 
                    select="//book/bookinfo/biblioid"/></xsl:with-param>
    <xsl:with-param name="right"><xsl:value-of 
                    select="$docname"/></xsl:with-param>
  </xsl:call-template>
</xsl:variable>


<!-- ==================================================================== -->
<!--   Modify stylesheets to comply with the layout of the Word version   -->
<!-- ==================================================================== -->

<!-- Hack to enforce paragraph numbering -->

<xsl:template match="chapter/para
                     |appendix/para
                     |sect1/para
                     |sect2/para
                     |sect3/para
                     |sect4/para
                     |sect5/para">
  <fo:block xsl:use-attribute-sets="normal.para.spacing">
    <xsl:if test="$use.para.numbering != 0">
      <xsl:number from="book" 
                 count="para[parent::chapter or
                               parent::appendix or
                               parent::sect1 or
                               parent::sect2 or
                               parent::sect3 or
                               parent::sect4 or
                               parent::sect5]" format="111" level="any"/>
      <xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<xsl:template match="beginpage">
  <fo:block break-after="page"/>
</xsl:template>

<!-- ==================================================================== -->
<!--  We need to put some extra text on the titlepage, besides what is    -->
<!--  specified in nc3ta-layout.xml                                       -->
<!-- ==================================================================== -->

<!-- The volume number should be preceded with the text "Volume", except for 
     volume 6 (the rationale document), where we do not want any volume info 
     printed out -->

<xsl:template match="volumenum" mode="titlepage.mode">
   <xsl:variable name="vol"><xsl:value-of select="."/></xsl:variable>
   <xsl:choose>
     <xsl:when test="$vol &lt; 6">
       Volume <xsl:value-of select="."/>
     </xsl:when>
     <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- The Document number should be embraced in a parentesis -->

<xsl:template match="biblioid" mode="titlepage.mode">(<xsl:value-of 
     select="."/>)
</xsl:template>

<!-- We only want to use the first revision element. Print version and date on 
     seperate lines, preceeded with the text "Version" and "Date" -->

<xsl:template match="revhistory" mode="titlepage.mode">
  <fo:block>
    Version <xsl:value-of select="./revision[1]/revnumber"/>
    <fo:block space-before="16mm">
      Date: <xsl:value-of select="./revision[1]/date"/>
    </fo:block>
  </fo:block>
</xsl:template>


<xsl:template match="bookinfo/corpauthor" mode="titlepage.mode" 
              priority="2">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<!-- Don't prefix Chapters or Appendixes, with the text Chapter/Appendix the
     format described below (component number and title).
     
     This may look very weird, but what we actually do is modifying the 
     in-memory copy of the file: "xsl/docbook-xsl/common/l10n.xml", and more 
     precisely the subtree represented by the file: 
     xsl/docbook-xsl/common/en.xml -->

<xsl:param name="local.l10n.xml" select="document('')"/>


<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" 
          language="en">
    <l:context name="title-numbered">
      <l:template name="appendix" text="%n.&#160;%t"/>
      <l:template name="chapter" text="%n.&#160;%t"/>
    </l:context>
  </l:l10n>
</l:i18n>


<!-- ==================================================================== -->
<!--  Generate headers and footers                                        -->
<!-- ==================================================================== -->

<!-- ....................................................................

     Source: fo/pagesetup.xsl, v 1.27 - DocBook XSL 1.58.1

     Descr: Generate headers and footers

-->


<xsl:template name="header.table">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="gentext-key" select="''"/>


  <!-- sequence can be odd, even, first, blank -->

  <xsl:variable name="candidate">
    <xsl:choose>
      <!-- Title page header -->
      <xsl:when test="$pageclass='titlepage'">
        <fo:block text-align="center">
          <fo:block><xsl:copy-of select="$odd.page.head"/></fo:block>
          <xsl:if test="$for.internet.publication=0">
            <fo:block><xsl:value-of select="$class.label"/></fo:block>
<!--
            <fo:block><xsl:value-of select="$releasability.label"/></fo:block>
-->
          </xsl:if>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <!-- First and Odd pages is identical -->
          <xsl:when test="$sequence='first' or $sequence='odd'">
            <fo:block text-align="center">
              <xsl:copy-of select="$odd.page.head"/>
              <xsl:if test="$for.internet.publication=0">
                <fo:block 
                  text-align="center"><xsl:value-of select="$class.label"/></fo:block>
              </xsl:if>
            </fo:block>
          </xsl:when>
          <!-- Blank and even pages are identical -->
          <xsl:when test="$sequence='blank' or $sequence='even'">
            <fo:block text-align="center">
              <xsl:copy-of select="$even.page.head"/>
              <xsl:if test="$for.internet.publication=0">
                <fo:block 
                  text-align="center"><xsl:value-of select="$class.label"/></fo:block>
              </xsl:if>
            </fo:block>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Really output a header? -->

  <xsl:choose>
    <xsl:when test="$pageclass = 'titlepage' and $gentext-key = 'book'
                    and $sequence='blank'">
      <!-- no, book titlepages (blank) have no headers at all -->
    </xsl:when>
    <xsl:when test="$sequence = 'blank' and $headers.on.blank.pages = 0">
      <!-- no output -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$candidate"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="footer.table">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <!-- default is a single table style for all footers -->
  <!-- Customize it for different page classes or sequence location -->

  <xsl:variable name="foot">
    <xsl:if test="$for.internet.publication=0"> 
      <fo:block><xsl:value-of select="$class.label"/></fo:block>
    </xsl:if>
    <fo:block space-before="5pt">- <fo:page-number/> -</fo:block>
  </xsl:variable>

  <xsl:variable name="candidate">
    <xsl:choose>
      <!-- Title page header -->
      <xsl:when test="$pageclass='titlepage'">
        <xsl:if test="$for.internet.publication=0">
          <fo:block text-align="center">
            <fo:block><xsl:value-of select="$class.label"/></fo:block>
<!--
            <fo:block><xsl:value-of select="$releasability.label"/></fo:block>
-->
          </fo:block>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <fo:block text-align="center" font-size="{$body.font.size}">
          <xsl:copy-of select="$foot"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Really output a footer? -->

  <xsl:choose>
    <xsl:when test="$pageclass='titlepage' and $gentext-key='book'
                    and $sequence='blank'">
      <!-- book titlepages (blank) have no footers at all -->
    </xsl:when>
    <xsl:when test="$sequence = 'blank' and $footers.on.blank.pages = 0">
      <!-- no output -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$candidate"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- ....................................................................

     Source: fo/pagesetup.xsl, v 1.27 - DocBook XSL 1.58.0

     Descr.: Since 1.58.0 a static xsl-footnote-separator flow is
     generated, this seems not to be implemented by FOP.

     .................................................................... -->


<xsl:template name="footnote-separator">
<!--
  <fo:static-content flow-name="blank-page">
    <fo:block text-align="center">
      This page is intentionally left blank.
    </fo:block>
  </fo:static-content>
-->
</xsl:template>

<!-- ....................................................................

     Source: fo/footnote.xsl, v 1.8 - DocBook XSL 1.57.0

     Descr.: Footnotes are created using baseline-shift super. This does not 
     seems to work in FOP. So instead we embed footnotes in square brackets.
     .................................................................... -->


<xsl:template name="format.footnote.mark">
  <xsl:param name="mark" select="'?'"/>
  <fo:inline>
    <xsl:text>[</xsl:text><xsl:copy-of 
      select="$mark"/><xsl:text>]</xsl:text>
  </fo:inline>
</xsl:template>


<!-- ==================================================================== -->
<!-- Potential bugs in the DocBook XSL stylesheet                         -->
<!-- ==================================================================== -->

<!--
<xsl:template match="address">
  <fo:block text-align="start">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>
-->

<!-- ....................................................................

     Source: fo/verbatim.xsl, v 1.10 - DocBook XSL 1.62.0 

     Descr: The Address should be text-aligned="start" (In Fop 0.20.4
     embedding the attribut was inherited (corretly or not ??), now it isn't.
     
     .................................................................... -->

<!-- Does no work in 1.62.4 -->

<xsl:template match="address">
  <xsl:param name="suppress-numbers" select="'0'"/>

  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="$suppress-numbers = '0'
                      and @linenumbering = 'numbered'
                      and $use.extensions != '0'
                      and $linenumbering.extension != '0'">
        <xsl:call-template name="number.rtf.lines">
          <xsl:with-param name="rtf">
            <xsl:apply-templates/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:block wrap-option='no-wrap'

            text-align="start"   

            white-space-collapse='false'
            linefeed-treatment="preserve"
            xsl:use-attribute-sets="verbatim.properties">
    <xsl:copy-of select="$content"/>
  </fo:block>
</xsl:template>




<xsl:template match="address/email">
  <fo:inline><xsl:value-of select="."/></fo:inline>
</xsl:template>


</xsl:stylesheet>
