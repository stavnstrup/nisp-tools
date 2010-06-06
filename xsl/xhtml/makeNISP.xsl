<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

Name        : chunk.xsl

Description : This stylesheet is a customization of Norman Walsh DocBook
              XSL/XHTML stylesheets and is used to create a XHTML version of 
              the technical architecture. The stylesheet create as output 
              XHTML files according to the Word Wide Webs Consortiums 
              specification: "Extensible Stylesheet Language" version 1.0. 
              (see: http://www.w3c.org/REC/2001/XSL.html).

              Copyright (C) 2001,2006 Jens Stavnstrup/DDRE <js@ddre.dk>,
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
  

<xsl:import href="../docbook-xsl/xhtml/chunk.xsl"/>
<xsl:import href="../common/common.xsl"/>

<xsl:output method="saxon:xhtml" encoding="utf-8" omit-xml-declaration="yes"/>

<!-- ==================================================================== -->
<!--  Global parameters used to modify the functionality of the Chunked   -->
<!--  DocBook  XHTML stylesheets                                          -->
<!-- ==================================================================== -->

<!-- ToC/LoT/Index Generation -->

<xsl:variable name="toc.section.depth">0</xsl:variable>

<xsl:param name="generate.toc">
  chapter  toc
  sect1    toc
  sect2    toc
  appendix toc
</xsl:param>

<xsl:param name="generate.index" select="0"/>


<!-- Extensions -->

<xsl:param name="use.tablecolumns.extension" select="1"/>

<xsl:param name="use.extensions" select="1"/>

<!-- XSLT Processing -->

<xsl:param name="id.warnings" select="0"/>

<!-- Automatic Labeling -->

<xsl:param name="appendix.autolabel" select="'A'"/>

<xsl:param name="section.autolabel" select="1"/>

<xsl:param name="section.label.includes.component.label" select="1"/>


<!-- HTML  -->

<xsl:param name="html.stylesheet">../style/nc3ta.css</xsl:param>

<xsl:param name="css.decoration" select="0"/>
	
<xsl:param name="spacing.paras" select="'1'"/>


<!-- Linking -->

<xsl:param name="target.database.document" select="'../../src/olinks/olinksdb.xml'"/> 


<!-- Miscellaneous -->

<xsl:param name="formal.title.placement">
  figure after
  table  after
</xsl:param> 

<xsl:param name="show.comments" select="0"/>

<xsl:param name="show.revisionflag" select="0"/>

<xsl:param name="xref.with.number.and.title" select="0"/>


<!-- Chunking -->

<xsl:param name="chunker.output.doctype-public"
           select="'-//W3C//DTD XHTML 1.0 Transitional//EN'"/>

<xsl:param name="chunker.output.doctype-system" 
           select="'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'"/>

<xsl:param name="chunker.output.encoding" select="'iso-8859-1'"/>

<xsl:param name="chunker.output.indent" select="'yes'"/>

<xsl:param name="html.extra.head.links" select="1"/>

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

<!-- Set by build file -->
<xsl:param name="nisp.lifecycle.stage" select="''"/>
<xsl:param name="nisp.lifecycle.postfix" select="''"/>
<xsl:param name="nisp.class.label" select="''"/>
<xsl:param name="nisp.release.label" select="''"/>



<!-- ==================================================================== -->
<!-- Customized Docbook templates                                         -->
<!-- ==================================================================== -->

<!--

<xsl:template match="/">
  <xsl:comment>
    Comment using <xsl:value-of select="system-property('xsl:vendor')"/>
    on 
  </xsl:comment>
  <xsl:apply-templates/>
</xsl:template>

-->


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

<!-- Titlepage relates templates -->

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
  <div class="book-subtitle"><xsl:if test="$volume &lt; 6">VOLUME <xsl:number 
       format="I" value="$volume"/> - </xsl:if><xsl:apply-templates 
       mode="titlepage.mode"/>
  </div>
</xsl:template>


<xsl:template match="revhistory" mode="titlepage.mode"/>

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
<!-- Create navigation bar                                                -->


<xsl:template name="create-navbar">

  <xsl:variable name="docroot" select="/"/>

  <div id="navMenu">
    <xsl:variable name="docs" select="document('../../src/documents.xml')"/>
    <xsl:variable name="bookid" select="/book/@id"/>
    <ul>
      <li><a href="../about.html">About the volumes</a></li>
      <li class="pdf"><span class="h">Download </span>
        <a>
          <xsl:attribute name="href">
            <xsl:text>../pdf/</xsl:text>
            <xsl:value-of select="$pdf.prefix"/>
            <xsl:text>-v</xsl:text>
            <xsl:value-of select="$docs/documents/versioninfo/package/@major"/>

<!--
            <xsl:value-of select=
              "substring-before(//book/bookinfo/revhistory/revision[1]/revnumber,'.')"/>
-->
           <xsl:value-of select="$nisp.lifecycle.postfix"/>
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
      <li><img src="../images/cgey/menu_icon-onder.gif" alt="NATO Logo" width="195" height="72"/></li>
    </ul>
  </div>
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


<xsl:template name="user.head.content">
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
  <meta http-equiv="Content-Language" content="en-uk" />
  <meta name="MSSmartTagsPreventParsing" content="true" />
  <meta name="author" content="NATO Open Systems Working Group (NOSWG)" /> 
  <meta http-equiv="Expires" content="0" />
</xsl:template>


<!-- ==================================================================== -->



<xsl:template name="user.header.navigation">
  <xsl:if test="$for.internet.publication=0">
    <div class="classification">
      <xsl:value-of select="$class.label"/>
    </div>
  </xsl:if>
</xsl:template>


<xsl:template name="user.footer.navigation">
  <xsl:if test="$for.internet.publication=0">
    <div class="classification">
      <xsl:value-of select="$class.label"/>
    </div>
  </xsl:if>
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

      <table id="mainbody" cellspacing="0" cellpadding="0"><tr><td class="wNavigationBox">
        <div id="taNavigationBox" class="left mainmenu wNavigationBox">
          <div id="navHeader">NISP Volumes</div>
          <xsl:call-template name="create-navbar"/>
        </div>
      </td><td>
        <div id="taContents">  <!-- NEVER CHANGE this id, that will break the CGEY portal -->
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
      </td><!--<td class="wInfoBox">
        <div id="taInfoBox" class="wInfoBox">

          <ul>
            <li class="pdf"><span class="h">PDF</span>
              <a>
                <xsl:attribute name="href">
                  <xsl:text>../pdf/</xsl:text>
                  <xsl:value-of select="$pdf.prefix"/>
                  <xsl:text>-v</xsl:text>
                  <xsl:value-of select=
                    "substring-before(//book/bookinfo/revhistory/revision[1]/revnumber,'.')"/>
                  <xsl:if test="$for.internet.publication=1">
                    <xsl:value-of select="$internet.postfix"/>
                  </xsl:if>
                  <xsl:text>.pdf</xsl:text>
                </xsl:attribute>
                <xsl:text>Download </xsl:text><xsl:value-of 
                   select="$db//docinfo[@id=$docid]/titles/short"/>
              </a>
            </li>
            <li><span class="h">Forum discussion</span><a href="#">Join the discussion
              about the latest version of the NISP.</a></li>
            <li><span class="h">Enter a RFCP</span><a href="#">Use the webform to
              submit a change proposal.</a></li>
            <li><span class="h">Create an Architecture
              template</span><a href="#">Use one of 7 different
            available webforms.</a></li>
          </ul>
        </div>
      </td>--></tr></table>

      <div id="taFooter">Copyright &#x00A9; NATO - OTAN 1998-2010 | <a href="../disclaimer.html">Disclaimer</a></div>
    </body>
  </html>
</xsl:template>

<!-- ==================================================================== -->

<!-- ....................................................................

     Copied from: xhtml/component.xsl, DocBook XSL 1.75.2
     Rationale: Necessary to give this template the right priority

     .................................................................... -->


<xsl:template match="dedication/title|dedication/info/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::dedication[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="acknowledgements/title|acknowledgements/info/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::acknowledgements[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="preface/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::preface[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="appendix/title|appendix/appendixinfo/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::appendix[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="article/title|article/articleinfo/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::article[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="chapter/title|chapter/chapterinfo/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="component.title">
    <xsl:with-param name="node" select="ancestor::chapter[1]"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<!-- ....................................................................

     Copied from: xhtml/sections.xsl, DocBook XSL 1.75.2
     Rationale: Necessary to give these templates the right priority

     .................................................................... -->

<xsl:template match="simplesect/title|simplesect/info/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="section/title |section/info/title |sectioninfo/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect1/title |sect1/info/title |sect1info/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect2/title |sect2/info/title |sect2info/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect3/title |sect3/info/title |sect3info/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect4/title |sect4/info/title |sect4info/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<xsl:template match="sect5/title |sect5/info/title |sect5info/title" mode="titlepage.mode" priority="2">
  <xsl:call-template name="section.title"/>
</xsl:template>

<!-- ==================================================================== -->

<!-- ....................................................................

     Derived from: xhtml/html.xsl, DocBook XSL 1.75.2
     Effected lines: 169
     Descr.: Line <a id="{$id}"/> changed into <a id="{$id}" style="display:none">&#160;</a>
     Rationale: Ensure that no single <a>-elements like <a name="xxx"/> are generated,
                but always elements <a>-elements with opening and closing tags <a name="xxx"></a>.
                This solves the problem that <a>-elements are misinterpreted by the CSS-interpretors
                of several webbrowsers.

     .................................................................... -->

<xsl:template name="anchor">
  <xsl:param name="node" select="."/>
  <xsl:param name="conditional" select="1"/>
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xslo:if xmlns:xslo="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon" test="not($node[parent::blockquote])"><xsl:if test="$conditional = 0 or $node/@id or $node/@xml:id">
    <a id="{$id}" style="display:none">&#160;</a>
  </xsl:if></xslo:if>
</xsl:template>

<!-- ==================================================================== -->

<!-- ....................................................................

     Derived from: xhtml/titlepage.xsl, DocBook XSL 1.75.2
     Effected lines: 576 and 954
     Descr.: Line <a id="{$id}"/> changed into <a id="{$id}" style="display:none">&#160;</a>
     Rationale: Ensure that no single <a>-elements like <a name="xxx"/> are generated,
                but always elements <a>-elements with opening and closing tags <a name="xxx"></a>.
                This solves the problem that <a>-elements are misinterpreted by the CSS-interpretors
                of several webbrowsers.

     .................................................................... -->

<xsl:template match="legalnotice" mode="titlepage.mode">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:choose>
    <xsl:when test="$generate.legalnotice.link != 0">
      
      <!-- Compute name of legalnotice file -->
      <xsl:variable name="file">
	<xsl:call-template name="ln.or.rh.filename"/>
      </xsl:variable>

      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir" select="$base.dir"/>
	  <xsl:with-param name="base.name" select="$file"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="title">
        <xsl:apply-templates select="." mode="title.markup"/>
      </xsl:variable>

      <a href="{$file}">
        <xsl:copy-of select="$title"/>
      </a>

      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="quiet" select="$chunk.quietly"/>
        <xsl:with-param name="content">
        <xsl:call-template name="user.preroot"/>
          <html>
            <head>
              <xsl:call-template name="system.head.content"/>
              <xsl:call-template name="head.content"/>
              <xsl:call-template name="user.head.content"/>
            </head>
            <body>
              <xsl:call-template name="body.attributes"/>
              <div>
                <xsl:apply-templates select="." mode="common.html.attributes"/>
                <xsl:apply-templates mode="titlepage.mode"/>
              </div>
            </body>
          </html>
          <xsl:value-of select="$chunk.append"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
          <a id="{$id}" style="display:none">&#160;</a>
        <xsl:apply-templates mode="titlepage.mode"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="title" mode="titlepage.mode">
  <xsl:variable name="id">
    <xsl:choose>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h1>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:if test="$generate.id.attributes = 0">
      <a id="{$id}" style="display:none">&#160;</a>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$show.revisionflag != 0 and @revisionflag">
	<span class="{@revisionflag}">
	  <xsl:apply-templates mode="titlepage.mode"/>
	</span>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="titlepage.mode"/>
      </xsl:otherwise>
    </xsl:choose>
  </h1>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
