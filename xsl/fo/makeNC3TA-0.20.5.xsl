<?xml version='1.0'?>
<!--

Name        : makeNC3TA.xsl

Description : This stylesheet is a customization of Norman Walsh DocBook
              XSL-FO stylesheets  and is used to create a XSL-FO version of 
              the technical architecture. The stylesheet create as output 
              XSL-FO files according to the Word Wide Webs Consortiums 
              specification: "Extensible Stylesheet Language" version 1.0. 
              (see: http://www.w3c.org/REC/2001/XSL.html).

              The stylesheet imports stylesheet modification, which are geared 
              specifically towards The Apache Foundation Formatting Object 
              processor (FOP), which still lack implementation of multiple 
              features.

              If the stylesheet is used, whith another FO processor,
              make at minimum the following modifications to the stylesheet.

              1. Do not import the fop-bugs/*.xsl stylesheets.

              2. Use the appropiate processer extension, if available

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


<xsl:import href="../docbook-xsl/fo/docbook.xsl"/>
<xsl:import href="nisp-layout.xsl"/>
<xsl:import href="../common/common.xsl"/>

<xsl:import href="fo-common.xsl"/>


<!-- Fix FOP bugs -->

<!-- Select output mode -->

<xsl:output method="xml" indent="no"
            saxon:next-in-chain="fop-bugs/fo-post-for-fop-0.20.5.xsl"/>


<!-- ==================================================================== -->
<!--   Global parameters used to modify the functionality of the DocBook  -->
<!--   XSL/FO stylesheets.                                                -->
<!-- ==================================================================== -->


<!-- Processor Extensions -->


<xsl:param name="fop.extensions" select="1"/>
<xsl:param name="xep.extensions" select="0"/>

<!-- Stylesheet Extensions -->

<xsl:param name="use.extensions" select="1"/>
<xsl:param name="tablecolumns.extension" select="1"/> 


</xsl:stylesheet>
