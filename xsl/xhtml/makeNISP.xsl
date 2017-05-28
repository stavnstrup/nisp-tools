<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
Name        : makeNISP.xsl

Description : This stylesheet is a customization of Norman Walsh
              DocBook XSL/XHTML stylesheets and is used to create a
              XHTML version of the NATO Interoperability Standards and
              Profiles (NISP).  The stylesheet create as output XHTML
              files according to the Word Wide Webs Consortiums
              specification: "Extensible Stylesheet Language" version
              1.0.  (see: http://www.w3c.org/REC/2001/XSL.html).

              Copyright (C) 2001,2015 Jens Stavnstrup/DALO <stavnstrup@mil.dk>,
              Danish Defence Acquisition and Logistic Organisation (DALO),
              Danish Defence Research Establishment (DDRE) and
              NATO Command, Control and Consultation Organisation.(NC3O)

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:saxon="http://icl.com/saxon"
                xmlns="http://www.w3.org/1999/xhtml"
                version='1.1'
                extension-element-prefixes="exsl saxon"
                exclude-result-prefixes="#default">


<xsl:import href="../docbook-xsl/xhtml5/chunk.xsl"/>
<xsl:import href="../common/common.xsl"/>
<xsl:import href="html-common.xsl"/>

<xsl:output omit-xml-declaration="yes"/>

<!-- ==================================================================== -->
<!--  Global parameters used to modify the functionality of the Chunked   -->
<!--  DocBook  XHTML stylesheets                                          -->
<!-- ==================================================================== -->

<!-- ToC/LoT/Index Generation -->

<xsl:variable name="toc.section.depth">1</xsl:variable>

<xsl:param name="generate.toc">
  book toc
</xsl:param>

<xsl:param name="generate.index" select="0"/>


<!-- Extensions -->

<xsl:param name="use.tablecolumns.extension" select="1"/>

<xsl:param name="use.extensions" select="1"/>

<xsl:param name="graphicsize.extension" select="1"/>

<!-- XSLT Processing -->

<xsl:param name="id.warnings" select="0"/>

<!-- Automatic Labeling -->

<xsl:param name="appendix.autolabel" select="'A'"/>

<xsl:param name="section.autolabel" select="1"/>

<xsl:param name="section.label.includes.component.label" select="1"/>


<!-- HTML  -->

<xsl:param name="html.stylesheet">../css/nisp.css</xsl:param>

<xsl:param name="css.decoration" select="0"/>

<xsl:param name="spacing.paras" select="'1'"/>

<xsl:param name="generate.id.attributes" select="1"></xsl:param>

<!-- Linking -->

<xsl:param name="target.database.document" select="'../../src/olinks/olinksdb.xml'"/>


<!-- Miscellaneous -->

<xsl:param name="formal.title.placement">
  figure after
  table  before
</xsl:param>

<xsl:param name="show.comments" select="0"/>

<xsl:param name="show.revisionflag" select="0"/>

<xsl:param name="xref.with.number.and.title" select="0"/>

<xsl:param name="draft.watermark.image" select="''"/>

<xsl:param name="table.footnote.number.format">1</xsl:param>

<!-- Chunking -->

<xsl:param name="docbook.css.source"></xsl:param>

<xsl:param name="chunker.output.method">saxon:xhtml</xsl:param>

<xsl:param name="chunker.output.encoding" select="'UTF-8'"/>

<xsl:param name="chunker.output.indent" select="'yes'"/>

<!--
<xsl:param name="chunker.output.omit-xml-declaration">yes</xsl:param>
-->

<xsl:param name="html.extra.head.links" select="1"/>

<xsl:param name="html.ext">.html</xsl:param>

<xsl:param name="chunk.section.depth" select="1"/>

<xsl:param name="chunk.fast" select="1"/>

<xsl:param name="navig.showtitles" select="0"/>

<!-- ==================================================================== -->
<!--   NISP Specific Parameters                                           -->
<!-- ==================================================================== -->

<xsl:param name="check.idref" select="0"/>

<xsl:variable name="db" select="document('../../src/documents.xml')"/>

<!-- External parameter -->

<xsl:param name="docid" select="''"/>
<xsl:param name="pdf.prefix" select="''"/>
<xsl:param name="describe" select="''"/>


<!-- Set by build file -->
<xsl:param name="nisp.lifecycle.stage" select="''"/>
<xsl:param name="nisp.lifecycle.postfix" select="''"/>
<xsl:param name="nisp.class.label" select="''"/>
<xsl:param name="nisp.release.label" select="''"/>


<!-- ==================================================================== -->
<!-- Customized Docbook templates                                         -->
<!-- ==================================================================== -->


<!-- Get the version number from the first revision element -->

<xsl:variable name="version.major" select="substring-before(//book/bookinfo/revhistory/revision[1]/revnumber,'.')"/>
<xsl:variable name="version.minor" select="substring-after(//book/bookinfo/revhistory/revision[1]/revnumber,'.')"/>

<!-- AdatP-34 edition number.
     E.g.  NISP 4.0 will be ADatP-34 edition D, NISP 4.1 - 5.0 will be ADatP-34 edition E -->

<xsl:variable name="adatp34edition">
  <xsl:choose>
    <xsl:when test="$version.minor=0">
      <xsl:value-of select="substring('ABCDEFGHIJKLMNOPQRSTUVWXUZ',$version.major, 1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring('ABCDEFGHIJKLMNOPQRSTUVWXUZ',$version.major+1, 1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>


<!-- We don't use beginpage here, however it is parts of some documents
     and tells the fo stylesheet, when a page-break should be enforced -->

<xsl:template match="beginpage"/>

<!-- Add text arrows to the prev and next links. Note, that we can actually
     add real graphical arrow using the navig.graphics parameters.

     This may look very weird, but what we actually do is modifying the
     in-memory copy of the file: "xsl/docbook-xsl/common/l10n.xml", and more
     precisely the subtree represented by the file:
     xsl/docbook-xsl/common/en.xml -->

<xsl:param name="local.l10n.xml" select="document('')"/>

<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
          language="en">
    <l:gentext key="nav-next" text="Next >"/>
    <l:gentext key="nav-prev" text="&lt; Prev"/>
  </l:l10n>
</l:i18n>

<!-- ==================================================================== -->

<!-- Titlepage related templates -->

<xsl:template name="book.titlepage.separator"/>


<xsl:template match="corpauthor" mode="titlepage.mode">
  <div class="{name(.)}">
    <div>AdatP-34(<xsl:value-of select="$adatp34edition"/>)</div>
    <div><xsl:apply-templates select="..//revision[1]/revnumber"
       mode="titlepage.mode"/></div>
    <div><xsl:apply-templates
       select="..//revision[1]/date"
       mode="titlepage.mode"/></div>
    <div><xsl:value-of select="."/></div>
  </div>
</xsl:template>


<xsl:template match="book" mode="titlepage.mode"/>


<xsl:template match="//*/bookinfo/subtitle" mode="titlepage.mode">
  <xsl:variable name="volume">
    <xsl:apply-templates select="../volumenum" mode="titlepage.mode"/>
  </xsl:variable>
  <div class="book-subtitle">
     <div><xsl:if test="$volume &lt; 6">VOLUME <xsl:number
       format="I" value="$volume"/></xsl:if></div>
     <div><xsl:apply-templates
       mode="titlepage.mode"/></div>
  </div>
</xsl:template>


<xsl:template match="revhistory"  mode="book.titlepage.recto.auto.mode"/>


<!-- ==================================================================== -->

<!-- Special NISP paranumbering. The use.para.numbering variable is
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
<!-- Create navigation bar (Sidebar)                                      -->

<xsl:template name="create-navbar">
  <xsl:variable name="docroot" select="/"/>

  <xsl:variable name="docs" select="document('../../src/documents.xml')"/>
  <xsl:variable name="bookid" select="/book/@id"/>
  <ul>
<!--
    <li id="menuhead">NISP Volumes</li>
-->
    <li class="pdf"><span class="h">Download </span>
      <a>
        <xsl:attribute name="href">
          <xsl:text>../pdf/</xsl:text>
          <xsl:value-of select="$pdf.prefix"/>
          <xsl:text>-v</xsl:text>
          <xsl:value-of select="$docs/documents/versioninfo/package/@major"/>
          <xsl:if test="$nisp.lifecycle.stage != 'draft'">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$nisp.lifecycle.stage"/>
          </xsl:if>
          <xsl:text>.pdf</xsl:text>
        </xsl:attribute>
        <xsl:text>PDF of </xsl:text><xsl:value-of
           select="$db//docinfo[@id=$docid]/titles/short"/>
      </a>
    </li>

    <xsl:for-each select="$docs//docinfo">
      <li>
        <xsl:choose>
          <xsl:when test="./@id=$bookid">
            <xsl:value-of select="./titles/short"/>
            <xsl:if test="not(./titles/short='')">
               <xsl:text> - </xsl:text>
            </xsl:if>
            <xsl:value-of select="./titles/longtitle"/>
            <ul id="navSubMenu">
              <xsl:apply-templates select="$docroot//preface" mode="navElement"/>
              <xsl:apply-templates select="$docroot//chapter" mode="navElement"/>
              <xsl:if test="count($docroot//appendix)>0">
                <xsl:apply-templates select="$docroot//appendix" mode="navElement"/>
              </xsl:if>
            </ul>
          </xsl:when>
          <xsl:otherwise>
            <a>
              <xsl:attribute name="href">
                <xsl:text>../</xsl:text>
                <xsl:value-of select="../@dir"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="./targets/target[@type='html']"/>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="./titles/longtitle"/>
              </xsl:attribute>
              <xsl:value-of select="./titles/short"/>
              <xsl:if test="not(./titles/short='')">
                <xsl:text> - </xsl:text>
              </xsl:if>
              <xsl:value-of select="./titles/longtitle"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </xsl:for-each>
    <li class="hide-for-small"><img src="../images/menu_icon-onder.gif" alt="NATO Logo" width="195" height="72"/></li>
  </ul>
</xsl:template>


<xsl:template match="preface|chapter|appendix" mode="navElement">
  <!-- write index for components (chapter/appendix) -->
  <xsl:variable name="uid">
    <xsl:value-of select="generate-id(.)"/>
  </xsl:variable>
  <li>
    <xsl:if test="name()='chapter'">
      <xsl:number count="chapter" format="1"/>
      <xsl:text> - </xsl:text>
    </xsl:if>
    <xsl:if test="name()='appendix'">
      <xsl:number count="appendix" format="A"/>
      <xsl:text> - </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="." mode="navElementRef"/>
  </li>
</xsl:template>


<xsl:template match="preface|chapter|appendix|sect1" mode="navElementRef">
  <!-- Create link to component/section chunk -->
  <xsl:variable name="chunk-name">
    <xsl:apply-templates select="." mode="chunk-filename"/>
  </xsl:variable>
  <a href="{$chunk-name}"><xsl:apply-templates
     select="." mode="capitalize.title"/></a>
</xsl:template>


<xsl:template match="*" mode="capitalize.title">
    <!-- Capitalize a title -->
    <xsl:value-of
       select="translate(./title[1],
                         'abcdefghijklmnopqrstuvwxyz',
                         'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template name="user.preroot"/>

<!-- ==================================================================== -->

<xsl:template name="system.head.content">
  <meta charset="UTF-8" />
<!--
  <meta http-equiv="Content-Language" content="en-uk" />
-->
  <meta name="viewport" content="width=device-width" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
</xsl:template>

<xsl:template name="user.head.content">
  <meta name="author" content="Interoperability Capability Team (IP CaT)" />
  <meta name="pubsnummer">
    <xsl:attribute name="content">
      <xsl:value-of select="$describe"/>
    </xsl:attribute>
  </meta>
  <meta http-equiv="Expires" content="0" />
</xsl:template>


<!-- ==================================================================== -->


<xsl:template name="user.header.navigation">
<!--
  <xsl:if test="$nisp.lifecycle.stage != 'release'">
    <div class="classification">
      <xsl:value-of select="$class.label"/>
    </div>
  </xsl:if>
-->
</xsl:template>

<xsl:template name="user.footer.navigation">
<!--
  <xsl:if test="$nisp.lifecycle.stage != 'release'">
    <div class="classification">
      <xsl:value-of select="$class.label"/>
    </div>
  </xsl:if>
-->
</xsl:template>


<!-- ==================================================================== -->


<!-- ....................................................................

     Source: xhtml/chunk-common.xsl, v 1.xx - DocBook XSL 1.66.1

     Descr.:

     .................................................................... -->

<xsl:template name="chunk-element-content">
  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <xsl:param name="nav.context"/>
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>

  <xsl:call-template name="user.preroot"/>

  <html xmlns="http://www.w3.org/1999/xhtml">
    <xsl:call-template name="html.head">
      <xsl:with-param name="prev" select="$prev"/>
      <xsl:with-param name="next" select="$next"/>
    </xsl:call-template>

    <body>
      <xsl:call-template name="body.attributes"/>

      <xsl:call-template name="create-header"/>
      <xsl:call-template name="create-menubar"/>
      <div class="row" id="container">
        <div class="twelve columns" id="docbook">
          <xsl:call-template name="user.header.navigation"/>

          <xsl:call-template name="header.navigation">
            <xsl:with-param name="prev" select="$prev"/>
	    <xsl:with-param name="next" select="$next"/>
	    <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>

          <xsl:call-template name="user.header.content"/>

          <xsl:copy-of select="$content"/>

          <xsl:call-template name="user.footer.content"/>

          <xsl:call-template name="footer.navigation">
	    <xsl:with-param name="prev" select="$prev"/>
	    <xsl:with-param name="next" select="$next"/>
	    <xsl:with-param name="nav.context" select="$nav.context"/>
          </xsl:call-template>
          <xsl:call-template name="user.footer.navigation"/>
        </div>
      </div>
      <xsl:call-template name="nisp.footer"/>
    </body>
  </html>
</xsl:template>




<!-- =================================================================== -->

<xsl:template name="navig.content">
  <xsl:param name="direction" select="next"/>
  <xsl:choose>
    <xsl:when test="$direction = 'prev'">
      <i class="fa fa-arrow-left"></i>
    </xsl:when>
    <xsl:when test="$direction = 'next'">
      <i class="fa fa-arrow-right"></i>
    </xsl:when>
    <xsl:when test="$direction = 'up'">
      <i class="fa fa-arrow-up"></i>
    </xsl:when>
    <xsl:when test="$direction = 'home'">
      <i class="fa fa-home"></i>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>xxx</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>





<!-- =================================================================== -->

<!-- Simpliefied template originally taken from
     xhtml/chunker.xsl (1.77.1) Id 9147 2011-11-12 00:05:44Z bobstayton

     We have extracted the part of the template, which generates saxon output and with empty
     doctype declaration and empty media-type and finaly extended the saxon:output element with
     a saxon:next-in-chain attribute.
-->

<xsl:template name="write.chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="quiet" select="$chunk.quietly"/>
  <xsl:param name="suppress-context-node-name" select="0"/>
  <xsl:param name="message-prolog"/>
  <xsl:param name="message-epilog"/>

  <xsl:param name="method" select="$chunker.output.method"/>
  <xsl:param name="encoding" select="$chunker.output.encoding"/>
  <xsl:param name="indent" select="$chunker.output.indent"/>
  <xsl:param name="omit-xml-declaration" select="$chunker.output.omit-xml-declaration"/>
  <xsl:param name="standalone" select="$chunker.output.standalone"/>
  <xsl:param name="doctype-public" select="$chunker.output.doctype-public"/>
  <xsl:param name="doctype-system" select="$chunker.output.doctype-system"/>
  <xsl:param name="media-type" select="$chunker.output.media-type"/>
  <xsl:param name="cdata-section-elements" select="$chunker.output.cdata-section-elements"/>

  <xsl:param name="content"/>

  <xsl:if test="$quiet = 0">
    <xsl:message>
      <xsl:if test="not($message-prolog = '')">
        <xsl:value-of select="$message-prolog"/>
      </xsl:if>
      <xsl:text>Writing </xsl:text>
      <xsl:value-of select="$filename"/>
      <xsl:if test="name(.) != '' and $suppress-context-node-name = 0">
        <xsl:text> for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:if test="@id or @xml:id">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="(@id|@xml:id)[1]"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:if test="not($message-epilog = '')">
        <xsl:value-of select="$message-epilog"/>
      </xsl:if>
    </xsl:message>
  </xsl:if>

  <saxon:output saxon:character-representation="{$saxon.character.representation}" href="{$filename}" method="{$method}"
         encoding="{$encoding}" indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
         cdata-section-elements="{$cdata-section-elements}" standalone="{$standalone}"
         saxon:next-in-chain="html5.xsl">
    <xsl:copy-of select="$content"/>
  </saxon:output>
</xsl:template>

</xsl:stylesheet>
