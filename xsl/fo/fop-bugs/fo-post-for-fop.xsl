<?xml version="1.0"?>

<!--

This stylesheet is created for post-processing of FO result-trees intended for 
delivery to FOP 0.92beta or newer. This should temporary solve problems caused by wrong 
or unimplemented features in FOP.

When using Saxon, this stylesheet can be automatically processed by adding the 
attribute saxon:next-in-chain to the xsl:output element of your own 
stylesheet.

E.g.

  <xsl:output method="xml" indent="no"  
              saxon:next-in-chain="fo-post-for-fop.xsl"/>
              
N.B. Remember to attach the namespace declaration 

   xmlns:saxon="http://icl.com/saxon"

to your stylesheet element

If you are using Xalan, you can use the Xalan pipeDocument extension. See also 
http://xml.apache.org/xalan2/docs/extensionslib.html

Copyright (c) 2002, 2006 Jens Stavnstrup/DDRE <js@ddre.dk>

-->



<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:fox="http://xml.apache.org/fop/entensions"
                xmlns:saxon="http://icl.com/saxon"
                version='1.0'
                exclude-result-prefixes="xsl saxon">



<xsl:param name="default.table.width" select="'16cm'"/> 


<!-- This default template is used to copy everything -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>



<!-- ....................................................................

     Problem  : FOP does not implement the text-transform property. Especially 
                the capatialize functonality is needed. These templates could just 
                as well be extended for other text-transform proerties.

     Solution : Copy the element and all attributes except text-transform.
                Copy all children elements unmodified, except text nodes, which 
                should be capitalized.

     Resolved : -
     .................................................................... -->

<!-- 
<xsl:template match="fo:block[@text-transform = 'uppercase']">
  <xsl:copy>
    <xsl:apply-templates select="@*[name() != 'text-transform']"/>
    <xsl:apply-templates mode="uc"/>
  </xsl:copy>
</xsl:template>
-->

<!-- Text nodes should be capitialized -->

<!--
<xsl:template match="text()" mode="uc">
  <xsl:variable name="text" select="."/> 
  <xsl:value-of
       select="translate($text,
                          'abcdefghijklmnopqrstuvwxyz',
                          'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:template>
-->

<!-- Everything else should just be copied -->

<!--
<xsl:template match="@*|*" mode="uc">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates mode="uc"/>
  </xsl:copy>
</xsl:template>
-->

<!-- ....................................................................

     Problem  : The reference-orientation property is not supported

     Solution : Remove this property

     Resolved : -
     .................................................................... -->

<!--
<xsl:template match="fo:block-container[@reference-orientation='90']">
  <xsl:apply-templates select="./*"/>
</xsl:template>
-->

<!-- Don't report errors, when encountering these properties, just remove them 
     from the element -->
<!--
<xsl:template match="@reference-orientation|
                     @linefeed-treatment|
                     @last-line-end-indent|
                     @relative-align"/>
-->

<!-- ....................................................................

     Problem  : When generating Headers and Footer. The stylesheets use % as and 
                indicator on how big a column or a table should be. This is not 
                supported by FOP. Other templates are also affected, e.g. 
                variable lists, but the consequences of this have not been 
                considered yet.

     Solution : Replace the width of the table with default.table.width, and 
                change width of columns from % to proportional width.

     Resolved : -
     .................................................................... -->

<!--
<xsl:template match="fo:table[@width='100%']">
  <xsl:copy>
    <xsl:apply-templates select="@*[name() != 'width']"/>
    <xsl:attribute name="width"><xsl:value-of  select="$default.table.width"/></xsl:attribute> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
-->

<!--
<xsl:template match="fo:table-column">
  <xsl:copy>
    <xsl:apply-templates select="@*[name() != 'column-width']"/>
    <xsl:if test="contains(string(@column-width), '%')">
       <xsl:variable name="proportional"
                    select="substring-before(@column-width, '%')"/>
       <xsl:attribute
       name="column-width">proportional-column-width(<xsl:value-of select="$proportional"/>)</xsl:attribute>  
    </xsl:if>
    <xsl:if test="not(contains(string(@column-width), '%'))">
      <xsl:apply-templates select="@*[name() = 'column-width']"/>
    </xsl:if>
  </xsl:copy>
</xsl:template>
-->

<!-- ....................................................................

     Problem  : When creatng an index, the index title is embedded in a
                fo:block using a span attribute with value inherit, which 
                FOP does not understand this

     Solution : Remove the @span which have the value 'inherit'

     Resolved : -
     .................................................................... -->


<!--
<xsl:template match="fo:block[@span='inherit']">
  <xsl:copy>
    <xsl:apply-templates select="@*[name() != 'span']"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
-->

</xsl:stylesheet>
