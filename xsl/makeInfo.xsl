<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:import href="common/common.xsl"/>

<xsl:output method="xml" indent="yes"/>
<!-- omit-xml-declaration="yes"/> -->


<xsl:variable name="alldocs" select="document('../src/documents.xml')"/>


<xsl:template match="documents">
  <html>
    <head>
     <title>NISP Info</title>
     <style type="text/css">
       .warning {
          color: red;
       }
       .figure {
          border: 1px solid black;
       }
     </style>
    </head>
    <body>
      <h1>documents.xml</h1>
      The NATO Interoperability Standards and Profiles (NISP) consists of 6 documents.
      <xsl:apply-templates select="$alldocs//docinfo"/>
    </body>
  </html>
</xsl:template>


<xsl:template match="docinfo">
  <h2>
   <xsl:value-of select="./titles/title"/>
   <xsl:text> - </xsl:text>
   <xsl:value-of select="./titles/longtitle"/>
  </h2>

  <p>In the <strong>documents.xml</strong> file this document are described with the following parameters</p>

  <table>
    <tr>
      <th>Main document</th><td>/src/<xsl:value-of select="../@dir"/>/<xsl:value-of select="main"/></td>
    </tr>
    <tr>
      <th>Id</th><td><xsl:value-of select="@id"/></td>
    </tr>
    <tr>
      <th>Short title</th><td><xsl:value-of select="titles/short"/></td>
    </tr>
    <tr>
      <th>Title</th><td><xsl:value-of select="titles/title"/></td>
    </tr>
    <tr>
      <th>Long title</th><td><xsl:value-of select="titles/longtitle"/></td>
    </tr>
    <tr>
      <th></th><td></td>
    </tr>
  </table>


  <p><xsl:value-of select="titles/title"/>
    <xsl:text> is resolved using the </xsl:text>
    <xsl:if test="resolve/@usedb='no'">
      <xsl:text>standard resolver stylesheet.</xsl:text>
    </xsl:if>
    <xsl:if test="resolve/@usedb='yes'">
      <xsl:text>special resolver stylesheet </xsl:text>
      <strong><xsl:value-of select="resolve"/></strong>
      <xsl:text>, which also merge the document with the database </xsl:text>
      <strong><xsl:value-of select="resolve/@db"/></strong>
      <xsl:text>.</xsl:text>
    </xsl:if>
  </p>

  <!-- something about targets -->

  <xsl:variable name="doclocation">
    <xsl:text>../build.src/</xsl:text>
    <xsl:value-of select="substring-before(main,'.')"/>
    <xsl:text>-resolved.xml</xsl:text>
  </xsl:variable>

  <xsl:variable name="thisdoc" select="document($doclocation)"/>

  <xsl:variable name="chap" select="count($thisdoc//chapter)"/>
  <xsl:variable name="app" select="count($thisdoc//appendix)"/>

  <p><xsl:text>The resolved version of </xsl:text>
    <xsl:value-of select="titles/title"/>
    <xsl:text> consists of </xsl:text>
    <xsl:if test="$chap > 0">
      <strong><xsl:value-of select="$chap"/></strong>
      <xsl:text> chapter</xsl:text>
      <xsl:if test="$chap > 1">s</xsl:if>
    </xsl:if>
    <xsl:if test="$chap > 0 and $app > 0">
      <xsl:text> and </xsl:text>
    </xsl:if>
    <xsl:if test="$app > 0">
      <xsl:value-of select="$app"/>
      <xsl:text> appendix</xsl:text>
      <xsl:if test="$app > 1">es</xsl:if>
    </xsl:if>
  </p>

  <p></p>
  
  <table>
    <tr>
      <th>Title</th><td><xsl:value-of select="$thisdoc/book/bookinfo/title"/></td>
    </tr>
    <tr>
      <th>Subtitle</th><td><xsl:value-of select="$thisdoc/book/bookinfo/subtitle"/>
      <xsl:if test="$thisdoc/book/bookinfo/subtitle != titles/short">
        <xsl:text> - </xsl:text><span class="warning">Different from Longtitle in documents.xml</span>
      </xsl:if></td>
    </tr>
    <tr>
      <th>Coorporate Author</th><td><xsl:value-of select="$thisdoc/book/bookinfo/corpauthor"/></td>
    </tr>
    <tr>
      <th>Productname</th><td><xsl:value-of select="$thisdoc/book/bookinfo/productname"/></td>
    </tr>
    <tr>
      <th>Biblio ID</th><td><xsl:value-of select="$thisdoc/book/bookinfo/biblioid"/></td>
    </tr>
    <tr>
      <th>Volume number</th><td><xsl:value-of select="$thisdoc/book/bookinfo/volumenum"/></td>
    </tr>
  </table>


  <p>There are <xsl:value-of select="count($thisdoc//figure)"/> figures in the document.</p>


  <xsl:apply-templates select="$thisdoc//figure"/>

</xsl:template>


<xsl:template match="figure">
  <div class="figure">
    <img>
     <xsl:attribute name="src">
       <xsl:value-of select="./mediaobject[1]/imageobject/imagedata/@fileref"/>
     </xsl:attribute>
    </img>
    <p><strong>Title</strong>: <xsl:value-of select="./title"/></p>
  </div>
</xsl:template>



</xsl:stylesheet>
