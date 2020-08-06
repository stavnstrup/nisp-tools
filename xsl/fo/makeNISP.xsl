<?xml version='1.0'?>
<!--

Name        : makeNISP.xsl

Description : This stylesheet is a customization of Norman Walsh DocBook
              XSL-FO stylesheets  and is used to create a XSL-FO version of
              the NATO Interoperability Standards and Profiles (NISP).
              The stylesheet create as output XSL-FO files according to
              the Word Wide Webs Consortiums specification: "Extensible
              Stylesheet Language" version 1.0.
              (see: http://www.w3c.org/REC/2001/XSL.html).

              The stylesheet imports defined modifications, which are geared
              specifically towards The Apache Foundation Formatting Object
              processor (FOP), which still lack implementation of multiple
              features.

              If the stylesheet is used, whith another FO processor, then
              use the appropiate processer extension, if available.

              Copyright (C) 2001-2020 Jens Stavnstrup/DALO <stavnstrup@mil.dk>,
              Danish Defence Research Establishment (DDRE), and
              Danish Acquisition and Logistics Organisation and
              NATO Command, Control and Consultation Organisation.(NC3O)


-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
                xmlns:xtbl="com.nwalsh.xalan.Table"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="#default saxon axf rx stbl xtbl"
                version="1.1">

<xsl:import href="../docbook-xsl/fo/docbook.xsl"/>
<xsl:import href="nisp-titlepages.xsl"/>
<xsl:import href="../common/common.xsl"/>


<!-- Select output mode -->

<xsl:output method="xml" indent="no"/>


<!-- ==================================================================== -->
<!--   Global parameters used to modify the functionality of the DocBook  -->
<!--   XSL/FO stylesheets.                                                -->
<!-- ==================================================================== -->


<!-- ToC/LoT/Index Generation -->

<xsl:param name="generate.toc">
  book title toc,title,figure
</xsl:param>

<xsl:param name="toc.section.depth">2</xsl:param>

<xsl:param name="process.empty.source.toc" select="1"/>

<xsl:template name="page.number.format">
  <xsl:param name="element" select="local-name(.)"/>
  <xsl:param name="master-reference" select="''"/>

  <xsl:choose>
    <xsl:when test="$element = 'toc' and self::book">i</xsl:when>
    <xsl:when test="$element = 'set'">i</xsl:when>
    <xsl:when test="$element = 'book'">i</xsl:when>
    <xsl:when test="$element = 'preface'">i</xsl:when>
    <xsl:when test="$element = 'dedication'">i</xsl:when>
    <xsl:when test="$element = 'acknowledgements'">i</xsl:when>
    <xsl:when test="$element = 'toc'">i</xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- Processor Extensions -->

<xsl:param name="fop1.extensions" select="1"/>


<!-- Stylesheet Extensions -->

<xsl:param name="tablecolumns.extension" select="1"/>
<xsl:param name="use.extensions" select="1"/>

<xsl:param name="graphicsize.extension" select="1"/>

<!-- Automatic labelling -->

<xsl:param name="appendix.autolabel" select="'A'"/>
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>

<!-- Tables -->

<xsl:param name="default.table.width" select="'16cm'"/>

<xsl:attribute-set name="table.table.properties">
  <xsl:attribute name="hyphenate">true</xsl:attribute>
</xsl:attribute-set>

<!-- Bibliography (defined in ../common/common.xsl) -->


<!-- Miscellaneous -->

<xsl:param name="formal.title.placement">
  figure after
  table before
</xsl:param>

<xsl:param name="hyphenate">false</xsl:param>
<xsl:param name="show.comments" select="0"/>
<xsl:param name="ulink.show" select="0"/>
<xsl:param name="ulink.hyphenate" select="''"/>
<xsl:param name="xref.with.number.and.title" select="0"/>

<xsl:attribute-set name="xref.properties">
  <xsl:attribute name="color">
    <xsl:choose>
      <xsl:when test="self::ulink">#2ba6cb</xsl:when>
      <xsl:otherwise>inherit</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="component.title.properties">
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>


<xsl:param name="table.footnote.number.format">1</xsl:param>

<!-- Graphics -->

<xsl:param name="preferred.mediaobject.role" select="'fop'"/>


<!-- Pagination and General Styles-->

<!-- The letter A-H refers to the figure describing page 
     setup in the DocBook XSL-FO documentation

     http://docbook.sourceforge.net/release/xsl/current/doc/fo/general.html
 -->

<xsl:param name="paper.type" select="'A4'"/>
<xsl:param name="double.sided" select="1"/>

<xsl:param name="page.margin.inner" select="'25mm'"/>      <!-- G -->
<xsl:param name="page.margin.outer" select="'25mm'"/>      <!-- H -->
<xsl:param name="page.margin.top" select="'15mm'"/>        <!-- A -->

<xsl:param name="region.before.extent" select="'42pt'"/>   <!-- B -->
<xsl:param name="body.margin.top" select="'56pt'"/>        <!-- C -->

<xsl:param name="region.after.extent" select="'48pt'"/>    <!-- D -->
<xsl:param name="page.margin.bottom" select="'14mm'"/>     <!-- E -->
<xsl:param name="body.margin.bottom" select="'57pt'"/>     <!-- F -->


<xsl:param name="body.start.indent" select="'0pc'"/>

<xsl:param name="body.font.master" select="12"/>

<xsl:param name="title.margin.left" select="'0pc'"/>

<xsl:param name="draft.mode" select="''"/> <!-- Set by build file -->
<xsl:param name="draft.watermark.image" select="'../images/draft.svg'"/>

<xsl:param name="headers.on.blank.pages" select="1"/>
<xsl:param name="footers.on.blank.pages" select="1"/>

<xsl:param name="header.rule" select="0"/>
<xsl:param name="footer.rule" select="0"/>

<xsl:attribute-set name="header.content.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="footer.content.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>


<!-- Font Families -->

<!-- Use only the build-in Adobe Fonts (Supported by PDF) :
     Times, Courier, Helvetica, Symbol and Zapf Dingbats -->

<xsl:param name="body.font.family" select="'Times'"/>

<xsl:param name="title.font.family" select="'Helvetica'"/>
<!--
<xsl:param name="dingbat.font.family" select="'Zapf Dingbats'"/>
-->
<xsl:param name="dingbat.font.family" select="'Serif'"/>

<xsl:param name="monospace.font.family" select="'Courier'"/>
<xsl:param name="sans.font.family" select="'Helvetica'"/>


<!-- Property Sets -->

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

<xsl:attribute-set name="figure.properties">
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>


<xsl:param name="header.column.widths">6 10 6</xsl:param>
<xsl:param name="footer.column.widths">6 10 6</xsl:param>

<xsl:param name="stylesheet.result.type" select="'fo'"/>

<xsl:attribute-set name="formal.title.properties"
                   use-attribute-sets="normal.para.spacing">
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>







<xsl:param name="intentionally-blank" select="'../images/intentionally-blank.svg'"/>
<xsl:param name="intentionally-blank-draft" select="'../images/intentionally-blank-draft.svg'"/>


<!-- External stylesheet parameter -->

<xsl:param name="pdf.prefix" select="''"/>

<xsl:param name="nisp.lifecycle.stage" select="draft"/>
<xsl:param name="nisp.class.label" select="''"/>
<xsl:param name="nisp.release.label" select="''"/>
<xsl:param name="describe" select="''"/>




<!-- ==================================================================== -->
<!-- Define standard page headers for even- and odd pages                 -->
<!-- ==================================================================== -->


<!-- Set name of resulting document (without extension) e.g. NISP-Vol1 -->

<xsl:variable name="docname">
  <xsl:value-of select="$pdf.prefix"/>

  <xsl:variable name="revision" select="//book/bookinfo/revhistory/revision[1]/revnumber"/>

  <xsl:text>-v</xsl:text>
  <xsl:choose>
    <xsl:when test="contains($revision,'.')">
      <xsl:value-of select="substring-before($revision,'.')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$revision"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>.xml</xsl:text>
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
<!-- Custom templates for titlepage elements                              -->
<!-- ==================================================================== -->

<!-- The volume number should be preceded with the text "Volume", except for
     volume 6 (the rationale document), where we do not want any volume info
     printed out -->

<xsl:template match="volumenum" mode="titlepage.mode">
   <xsl:variable name="vol"><xsl:value-of select="."/></xsl:variable>
   <xsl:choose>
     <xsl:when test="$vol &lt; 100">
       Volume <xsl:value-of select="."/>
     </xsl:when>
     <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- The Document number should be embraced in a parentesis -->


<xsl:template match="biblioid" mode="titlepage.mode">
  <fo:block>
    NATO STANDARD
  </fo:block>
  <fo:block space-before="8mm">
    <xsl:text></xsl:text>
    <xsl:value-of select="."/>
<!-- This is not allowed in the NSO template 
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$allied.publication.edition"/>
    <xsl:text>) / Version </xsl:text>
    <xsl:choose>
      <xsl:when test="$version.minor=0">
        <xsl:value-of select="$version.major"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$version.major+1"/>
      </xsl:otherwise>
    </xsl:choose>
-->
  </fo:block>
</xsl:template>


<xsl:template match="productname" mode="titlepage.mode">
  <fo:block space-before="8mm">NORTH ATLANTIC TREATY ORGANIZATION</fo:block>
  <fo:block>
      <xsl:call-template name="capitalize">
        <xsl:with-param name="string" select="."/>
      </xsl:call-template>
  </fo:block>
  <fo:block font-family="Helvetica" font-size="11px">
    <fo:block>Published by the</fo:block>
    <fo:block>NATO STANDARDIZATION OFFICE (NSO)</fo:block>
    <fo:block>&#x00A9; NATO/OTAN</fo:block>
  </fo:block>
</xsl:template>


<!-- We only want to use the first revision element. Print version and date on
     seperate lines, preceeded with the text "Version" and "Date" -->

<xsl:template match="revhistory" mode="titlepage.mode">
  <fo:block>
    <!--Date: --><xsl:value-of select="./revision[1]/date"/>
  </fo:block>
</xsl:template>


<xsl:template match="bookinfo/corpauthor" mode="titlepage.mode" 
              priority="2">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="preface[@role='promulgation-thiswillnotwork']">
  <fo:block>NORTH ATLANTIC TREATY ORGANIZATION (NATO)</fo:block>
  <fo:block>NATO STANDARDISATION OFFICE (NSO)</fo:block>
  <xsl:apply-templates/>
</xsl:template>

<!-- Don't prefix Chapters or Appendixes, with the text Chapter/Appendix the
     format described below (component number and title).

     This may look very weird, but what we actually do is to redefine a
     a subtree of the in-memory copy of the file:
     "xsl/docbook-xsl/common/l10n.xml", and more precisely the subtree
     represented by the file: xsl/docbook-xsl/common/en.xml


     As of NISP 13 (Dec 2019) we want chapter/annex heading to exists, which is
     why the template below is commented out.
-->

<!--
<xsl:param name="local.l10n.xml" select="document('')"/>


<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
          language="en">
    <l:context name="title-numbered">
      <l:template name="appendix" text="%n. %t"/>
      <l:template name="chapter" text="%n. %t"/>
    </l:context>
  </l:l10n>
</l:i18n>
-->

<!-- ==================================================================== -->
<!--  Generate headers                                                    -->
<!-- ==================================================================== -->

<!-- ....................................................................

     Source: fo/pagesetup.xsl - DocBook XSL 1.75.2

     Descr: Generate headers

     .................................................................... -->




<!-- ==================================================================== -->

<!-- Change behavour of header content -->

<xsl:template name="header.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

<!--
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->

  <fo:block>

    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <xsl:when test="$position='center' and
                      ($nisp.lifecycle.stage = 'draft')">
<!--
        <xsl:value-of select="$nisp.class.label"/>
        <fo:block><xsl:value-of select="$nisp.release.label"/></fo:block>
        <fo:block font-size="9pt" font-family="mono">revision: <xsl:value-of select="/book/bookinfo/productnumber"/></fo:block>
-->
        <fo:block font-family="{$title.font.family}">revision: <xsl:value-of select="$describe"/></fo:block>
      </xsl:when>

      <xsl:when test="$pageclass='titlepage' or $sequence='first' or $sequence='odd'">
        <xsl:choose>
          <xsl:when test="$position='right'">
            <xsl:value-of select="$allied.publication.number"/>
            <xsl:if test="($nisp.revision != 0) and ($nisp.lifecycle.stage = 'board' or $nisp.lifecycle.stage = 'release')">
              <xsl:text>-REV</xsl:text>
              <xsl:value-of select="$nisp.revision"/>
            </xsl:if>
            <fo:block>Volume <xsl:value-of select="//book/bookinfo/volumenum"/></fo:block>
          </xsl:when>
          <xsl:when test="$position='left'">
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$sequence='even' or $sequence='blank'">
        <xsl:choose>
          <xsl:when test="$position='left'">
            <xsl:value-of select="$allied.publication.number"/>
            <xsl:if test="($nisp.revision != 0) and ($nisp.lifecycle.stage = 'board' or $nisp.lifecycle.stage = 'release')">
              <xsl:text>-REV</xsl:text>
              <xsl:value-of select="$nisp.revision"/>
            </xsl:if>
            <fo:block>Volume <xsl:value-of select="//book/bookinfo/volumenum"/></fo:block>
          </xsl:when>
          <xsl:when test="$position='right'">
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$position='left'">
        <!-- Same for odd, even, empty, and blank sequences -->
        <xsl:call-template name="draft.text"/>
      </xsl:when>

      <xsl:when test="($sequence='odd' or $sequence='even') and $position='center'">
        <xsl:if test="$pageclass != 'titlepage'">
          <xsl:choose>
            <xsl:when test="ancestor::book and ($double.sided != 0)">
              <fo:retrieve-marker retrieve-class-name="section.head.marker"
                                  retrieve-position="first-including-carryover"
                                  retrieve-boundary="page-sequence"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="titleabbrev.markup"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:when>

      <xsl:when test="$position='center'">
        <!-- nothing for empty and blank sequences -->
      </xsl:when>

      <xsl:when test="$position='right'">
        <!-- Same for odd, even, empty, and blank sequences -->
        <xsl:call-template name="draft.text"/>
      </xsl:when>

      <xsl:when test="$sequence = 'first'">
        <!-- nothing for first pages -->
      </xsl:when>

      <xsl:when test="$sequence = 'blank'">
        <!-- nothing for blank pages -->
      </xsl:when>
    </xsl:choose>
  </fo:block>
</xsl:template>


<!-- ==================================================================== -->
<!--  Generate footers                                                    -->
<!-- ==================================================================== -->

<!-- ....................................................................

     Source: fo/pagesetup.xsl - DocBook XSL 1.75.2

     Descr: Generate footers

     .................................................................... -->


<xsl:template name="footer.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

<!--
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->

  <fo:block>
    <!-- pageclass can be front, body, back -->
    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->

    <!-- -->
    <xsl:if test="(($sequence='blank' or $sequence='even') and $position='left') or
                  (($sequence='first' or $sequence='odd') and $position='right')">
      Edition <xsl:value-of select="$allied.publication.edition"/> Version <xsl:value-of select="$allied.publication.version"/>
<!--
      <xsl:if test="$nisp.lifecycle.stage='draft'">
        <xsl:choose>
          <xsl:when test="$version.minor=0"/>
          <xsl:when test="$version.minor &gt; 2 and $version.minor &lt; 21"><xsl:value-of select="$version.minor"/>th </xsl:when>
          <xsl:when test="$version.minor mod 10=1"><xsl:value-of select="$version.minor"/>st </xsl:when>
          <xsl:when test="$version.minor mod 10=2"><xsl:value-of select="$version.minor"/>nd </xsl:when>
          <xsl:otherwise><xsl:value-of select="$version.minor"/>th </xsl:otherwise>
      </xsl:choose>
      </xsl:if>
      <xsl:if test="$nisp.lifecycle.stage='final' or $nisp.lifecycle.stage='board'">Final </xsl:if>
      <xsl:if test="$nisp.lifecycle.stage!='release'">Draft</xsl:if>
      <xsl:if test="$nisp.lifecycle.stage='board'"><fo:block>Released to C3B</fo:block></xsl:if>
-->
    </xsl:if>

    <xsl:if test="$position='center' and $nisp.lifecycle.stage!='release'">
    </xsl:if>
    <!-- Put pagenumber on all pages except the title page -->
    <xsl:if test="$pageclass != 'titlepage' and $position='center'">
      <fo:block space-before="4pt">- <fo:page-number/> -</fo:block>
    </xsl:if>
  </fo:block>
</xsl:template>


<!-- ==================================================================== -->
<!-- Handling of blank pages                                              -->
<!-- ==================================================================== -->

<!-- ....................................................................

       Descr.: FOP 1.0+ do not allow text in fo:region-body on blank
       pages. So we are not able to put "This page is not
       intentionally blank" on blank pages. According to
       http://xmlgraphics.apache.org/fop/fo.html#fo-blank-pages, we
       can by putting it in a header, but then we can not have a normal NISP
       header.

       N.B. Both Antenna House and Render X allows this behaviour.

       Soulution: We are able to create a background image on all
       pages incl. blank pages. So we can create a backgrund image
       with the text "This page is intentionally left blank". We need
       two images depending on the draft-mode parameter being set to
       yes or no.

       The template "user.pagemasters" declares two set of pagemasters, one for
       normal pages (incl. blank pages) and one set for draft pages.

       The template "select.user.pagemaster" contains the logic for selecting
       the userdefined page masters instead of the default pagemasters.

       See http://www.sagehill.net/docbookxsl/PageDesign.html for a detailed
       explanation of userdefined pagemasters.

       Note, that we use the default pagemaster for titlepages ???
       NEED TO IVESTIGATE THE LAST STATEMENT

       .................................................................... -->


<xsl:template name="user.pagemasters">

  <!-- NISP page master for normal blank pages (final, board and release versions) -->

  <fo:simple-page-master master-name="nisp.blank"
                         page-width="{$page.width}"
                         page-height="{$page.height}"
                         margin-top="{$page.margin.top}"
                         margin-bottom="{$page.margin.bottom}">
    <xsl:attribute name="margin-{$direction.align.start}">
      <xsl:value-of select="$page.margin.outer"/>
    </xsl:attribute>
    <xsl:attribute name="margin-{$direction.align.end}">
      <xsl:value-of select="$page.margin.inner"/>
    </xsl:attribute>
    <fo:region-body margin-bottom="{$body.margin.bottom}"
                    margin-top="{$body.margin.top}">
      <xsl:attribute name="background-image">
        <xsl:call-template name="fo-external-image">
          <xsl:with-param name="filename" select="$intentionally-blank"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="background-attachment">fixed</xsl:attribute>
      <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
      <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
      <xsl:attribute name="background-position-vertical">center</xsl:attribute>
    </fo:region-body>
    <fo:region-before region-name="xsl-region-before-blank"
                      extent="{$region.before.extent}"
                      display-align="before"/>
    <fo:region-after region-name="xsl-region-after-blank"
                     extent="{$region.after.extent}"
                      display-align="after"/>
  </fo:simple-page-master>



  <!-- NISP page master for normal blank pages (draft versions) -->
  <fo:simple-page-master master-name="nisp.blank-draft"
                         page-width="{$page.width}"
                         page-height="{$page.height}"
                         margin-top="{$page.margin.top}"
                         margin-bottom="{$page.margin.bottom}">
    <xsl:attribute name="margin-{$direction.align.start}">
      <xsl:value-of select="$page.margin.outer"/>
    </xsl:attribute>
    <xsl:attribute name="margin-{$direction.align.end}">
      <xsl:value-of select="$page.margin.inner"/>
    </xsl:attribute>
    <fo:region-body margin-bottom="{$body.margin.bottom}"
                    margin-top="{$body.margin.top}">
      <xsl:attribute name="background-image">
        <xsl:call-template name="fo-external-image">
          <xsl:with-param name="filename" select="$intentionally-blank-draft"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="background-attachment">fixed</xsl:attribute>
      <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
      <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
      <xsl:attribute name="background-position-vertical">center</xsl:attribute>
    </fo:region-body>
    <fo:region-before region-name="xsl-region-before-blank"
                      extent="{$region.before.extent}"
                      display-align="before"/>
    <fo:region-after region-name="xsl-region-after-blank"
                     extent="{$region.after.extent}"
                      display-align="after"/>
  </fo:simple-page-master>


  <!-- setup for title page(s) -->
<!--
  <fo:page-sequence-master master-name="nisp.titlepage">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="nisp.blank"
                                            blank-or-not-blank="blank"/>
      <fo:conditional-page-master-reference master-reference="titlepage-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="titlepage-odd"
                                            odd-or-even="odd"/>
      <fo:conditional-page-master-reference
                                            odd-or-even="even">
        <xsl:attribute name="master-reference">
          <xsl:choose>
            <xsl:when test="$double.sided != 0">titlepage-even</xsl:when>
            <xsl:otherwise>titlepage-odd</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </fo:conditional-page-master-reference>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>
-->

  <!-- setup for lots -->
  <fo:page-sequence-master master-name="nisp.lot">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="nisp.blank"
                                            blank-or-not-blank="blank"/>
      <fo:conditional-page-master-reference master-reference="lot-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="lot-odd"
                                            odd-or-even="odd"/>
      <fo:conditional-page-master-reference
                                            odd-or-even="even">
        <xsl:attribute name="master-reference">
          <xsl:choose>
            <xsl:when test="$double.sided != 0">lot-even</xsl:when>
            <xsl:otherwise>lot-odd</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </fo:conditional-page-master-reference>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <!-- setup front matter -->
  <fo:page-sequence-master master-name="nisp.front">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="nisp.blank"
                                            blank-or-not-blank="blank"/>
      <fo:conditional-page-master-reference master-reference="front-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="front-odd"
                                            odd-or-even="odd"/>
      <fo:conditional-page-master-reference
                                            odd-or-even="even">
        <xsl:attribute name="master-reference">
          <xsl:choose>
            <xsl:when test="$double.sided != 0">front-even</xsl:when>
            <xsl:otherwise>front-odd</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </fo:conditional-page-master-reference>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <!-- setup for body pages -->
  <fo:page-sequence-master master-name="nisp.body">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="nisp.blank"
                                            blank-or-not-blank="blank"/>
      <fo:conditional-page-master-reference master-reference="body-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="body-odd"
                                            odd-or-even="odd"/>
      <fo:conditional-page-master-reference
                                            odd-or-even="even">
        <xsl:attribute name="master-reference">
          <xsl:choose>
            <xsl:when test="$double.sided != 0">body-even</xsl:when>
            <xsl:otherwise>body-odd</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </fo:conditional-page-master-reference>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <!-- setup back matter -->
  <fo:page-sequence-master master-name="nisp.back">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="nisp.blank"
                                            blank-or-not-blank="blank"/>
      <fo:conditional-page-master-reference master-reference="back-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="back-odd"
                                            odd-or-even="odd"/>
      <fo:conditional-page-master-reference
                                            odd-or-even="even">
        <xsl:attribute name="master-reference">
          <xsl:choose>
            <xsl:when test="$double.sided != 0">back-even</xsl:when>
            <xsl:otherwise>back-odd</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </fo:conditional-page-master-reference>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <!-- setup back matter -->
  <fo:page-sequence-master master-name="nisp.index">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="nisp.blank"
                                            blank-or-not-blank="blank"/>
      <fo:conditional-page-master-reference master-reference="index-first"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="index-odd"
                                            odd-or-even="odd"/>
      <fo:conditional-page-master-reference
                                            odd-or-even="even">
        <xsl:attribute name="master-reference">
          <xsl:choose>
            <xsl:when test="$double.sided != 0">index-even</xsl:when>
            <xsl:otherwise>index-odd</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </fo:conditional-page-master-reference>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>


  <xsl:if test="$draft.mode != 'no'">
    <!-- setup for draft title page(s) -->
<!--
    <fo:page-sequence-master master-name="nisp.titlepage-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="nisp.blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="titlepage-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="titlepage-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference
                                              odd-or-even="even">
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="$double.sided != 0">titlepage-even-draft</xsl:when>
              <xsl:otherwise>titlepage-odd-draft</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:conditional-page-master-reference>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>
-->

    <!-- setup for draft lots -->
    <fo:page-sequence-master master-name="nisp.lot-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="nisp.blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="lot-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="lot-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference
                                              odd-or-even="even">
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="$double.sided != 0">lot-even-draft</xsl:when>
              <xsl:otherwise>lot-odd-draft</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:conditional-page-master-reference>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup draft front matter -->
    <fo:page-sequence-master master-name="nisp.front-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="nisp.blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="front-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="front-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference
                                              odd-or-even="even">
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="$double.sided != 0">front-even-draft</xsl:when>
              <xsl:otherwise>front-odd-draft</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:conditional-page-master-reference>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup for draft body pages -->
    <fo:page-sequence-master master-name="nisp.body-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="nisp.blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="body-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="body-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference
                                              odd-or-even="even">
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="$double.sided != 0">body-even-draft</xsl:when>
              <xsl:otherwise>body-odd-draft</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:conditional-page-master-reference>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup draft back matter -->
    <fo:page-sequence-master master-name="nisp.back-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="nisp.blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="back-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="back-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference
                                              odd-or-even="even">
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="$double.sided != 0">back-even-draft</xsl:when>
              <xsl:otherwise>back-odd-draft</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:conditional-page-master-reference>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- setup draft index pages -->
    <fo:page-sequence-master master-name="nisp.index-draft">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="nisp.blank-draft"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="index-first-draft"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="index-odd-draft"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference
                                              odd-or-even="even">
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="$double.sided != 0">index-even-draft</xsl:when>
              <xsl:otherwise>index-odd-draft</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:conditional-page-master-reference>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

  </xsl:if>
</xsl:template>



<xsl:template name="select.user.pagemaster">
  <xsl:param name="element"/>
  <xsl:param name="pageclass"/>
  <xsl:param name="default-pagemaster"/>

  <xsl:choose>
<!--
    <xsl:when test="$default-pagemaster = 'titlepage'">
      <xsl:value-of select="'nisp.titlepage'"/>
    </xsl:when>
-->
    <xsl:when test="$default-pagemaster = 'lot'">
      <xsl:value-of select="'nisp.lot'"/>
    </xsl:when>
    <xsl:when test="$default-pagemaster = 'front'">
      <xsl:value-of select="'nisp.front'"/>
    </xsl:when>
    <xsl:when test="$default-pagemaster = 'body'">
      <xsl:value-of select="'nisp.body'"/>
    </xsl:when>
    <xsl:when test="$default-pagemaster = 'back'">
      <xsl:value-of select="'nisp.back'"/>
    </xsl:when>

    <xsl:when test="$default-pagemaster = 'index'">
      <xsl:value-of select="'nisp.index'"/>
    </xsl:when>

<!--
    <xsl:when test="$default-pagemaster = 'titlepage-draft'">
      <xsl:value-of select="'nisp.titlepage-draft'"/>
    </xsl:when>
-->
    <xsl:when test="$default-pagemaster = 'lot-draft'">
      <xsl:value-of select="'nisp.lot-draft'"/>
    </xsl:when>
    <xsl:when test="$default-pagemaster = 'front-draft'">
      <xsl:value-of select="'nisp.front-draft'"/>
    </xsl:when>
    <xsl:when test="$default-pagemaster = 'body-draft'">
      <xsl:value-of select="'nisp.body-draft'"/>
    </xsl:when>
    <xsl:when test="$default-pagemaster = 'back-draft'">
      <xsl:value-of select="'nisp.back-draft'"/>
    </xsl:when>

    <xsl:when test="$default-pagemaster = 'index-draft'">
      <xsl:value-of select="'nisp.index-draft'"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$default-pagemaster"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- ====================================================== -->
<!-- Do not include preface in TOC                          -->

<xsl:template match="preface" mode="toc" />

<xsl:template match="subject">
  <xsl:text>Generated using Git rev. </xsl:text>
  <xsl:value-of select="$describe"/>
</xsl:template>

<!-- Add for each Volume in the PDF file a bookmark showing titleabbrev and subtitle. -->
<!-- Add possibility to collapse this bookmark. -->
<!-- Template is customization of docbook-xsl/fo/docbook.xsl -->
<xsl:template match="set|book|part|reference|
                     preface|chapter|appendix|article|topic
                     |glossary|bibliography|index|setindex
                     |refentry
                     |sect1|sect2|sect3|sect4|sect5|section"
              mode="bookmark">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <!-- Put the root element bookmark at the same level as its children -->
  <!-- If the object is a set or book, generate a bookmark for the toc -->

  <xsl:choose>
    <xsl:when test="self::index and $generate.index = 0"/>
    <xsl:when test="parent::*">
      <fo:bookmark internal-destination="{$id}">
        <xsl:attribute name="starting-state">
          <xsl:value-of select="$bookmarks.state"/>
        </xsl:attribute>
        <fo:bookmark-title>
          <xsl:value-of select="normalize-space($bookmark-label)"/>
        </fo:bookmark-title>
        <xsl:apply-templates select="*" mode="bookmark"/>
      </fo:bookmark>
    </xsl:when>
    <xsl:otherwise>
      <fo:bookmark internal-destination="{$id}" starting-state="show">
        <fo:bookmark-title>
          <xsl:value-of select="concat(normalize-space(bookinfo/titleabbrev), ' - ', normalize-space(bookinfo/subtitle))"/>
        </fo:bookmark-title>

        <xsl:variable name="toc.params">
          <xsl:call-template name="find.path.params">
            <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:if test="contains($toc.params, 'toc')
                      and (book|part|reference|preface|chapter|appendix|article|topic
                           |glossary|bibliography|index|setindex
                           |refentry
                           |sect1|sect2|sect3|sect4|sect5|section)">
          <fo:bookmark internal-destination="toc...{$id}">
            <fo:bookmark-title>
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'TableofContents'"/>
              </xsl:call-template>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>
        <xsl:apply-templates select="*" mode="bookmark"/>
      </fo:bookmark>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
