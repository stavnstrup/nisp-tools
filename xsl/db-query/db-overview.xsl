<?xml version="1.0" encoding="ISO-8859-1"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>

<!--

This stylesheet is created for the NISP , and is
intended to create an overview of the starndard database.

Copyright (c) 2003, 2010  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  

<xsl:output method="html" encoding="ISO-8859-1" indent="yes"/>


<!-- If this param is set to one, only one headline is generated.
     You can therefore use the import the html file in excell XP 
     and use the freeze pane facility -->

<xsl:param name="excelXP" select="0"/>


<xsl:template match="standards">
  <xsl:message>Generating DB Overview.</xsl:message>
  <html>
    <head>
      <title>Overview of the NISP Standard Database</title>
      <style type="text/css">
        .head {background-color: #808080;  }
        .body,table {font-family: sans-serif;}
        .table {width: 100%;}
        .deleted { background-color: #FF5A41; color: white; font-weight: bold;}
        .missing { background-color: #FFFEA0;}
        .head { }
      </style>
    </head>
    <body>

    <h1>Overview of the NISP Standard Database</h1>

    <p>Created on 
    <xsl:variable name="date">
      <xsl:value-of select="date:date-time()"/>
    </xsl:variable>

    <xsl:value-of select="date:month-abbreviation($date)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="date:day-in-month()"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="date:year()"/>
    <xsl:text> - </xsl:text>
    <xsl:value-of select="substring-before(substring-after($date, 'T'),'+')"/>
    </p>
   
    <h2>Statistics</h2>

    <table border="0">
      <tr>
        <td><b>Rec</b></td>
        <td><b>Total</b></td>
        <td><b>Deleted</b></td>
      </tr>
      <tr>
        <td>standards</td>
        <td align="right"><xsl:value-of select="count(.//standard)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and ancestor::standard])"/></td>
      </tr>
      <tr>
        <td>profiles</td>
        <td align="right"><xsl:value-of select="count(.//profile)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and ancestor::profile])"/></td>
       </tr>
    </table>


  <h2>Standards</h2>

  <p>This section describes all standards and profiles included in the database.</p>

  <p>The database is organised in the following way. The database
  consists of a number of <em>servicearea</em> elements. Each
  <em>servicearea</em> consists of a number of
  <em>serviceategories</em> elements, which again consists of a number
  of <em>categories</em> In each <em>servicearea</em> the primary
  elements are a <em>standardrecord</em>, <em>profilerecords</em> or
  <em>referencerecord</em>. A <em>standardrecord</em> describes a
  given <em>standard</em>, which also might contain sub standards. A
  <em>profilerecord</em> describes a set of standards.</p>

  <p>In this overview, records with a red background are marked as
  deleted. Cells with a yellow background, indicates that that we
  properly don't have the information for this field. It will be
  appreciated very much, if YOU will send this information to chairman
  syndicate 2.</p>

  <p>These columns describes properties for a <em>standardrecord</em>,
  <em>profilerecord</em> or a <em>referencerecord</em></p>

   <ul>
     <li><b>ID</b> - What ID is associated with this <i>standard</i></li>
     <li><b>Type</b> - Is this a <i>coverstandard</i> (CS), a <i>single standard</i> or a <i>sub standard</i> (SS)</li>
     <li><b>Org</b> - What organisation have published this standard</li>
     <li><b>Pubnum</b> - The publication number of the <i>standard</i></li>
     <li><b>Title</b> - The title of the <i>standard</i></li>
     <li><b>Date</b> - The publication date of the <i>standard</i></li>
     <li><b>Correction</b> - Correction info for
        this <i>standard</i>. There might be multiple corrections
        records (Technical Correction, Ammentment etc.). Each record
        begins on a new line</li>
     <li><b>AKA</b> - (Also Known As) A standard can be published by
        another organisation. There might be multiple AKA record. Each
        record begins on a new line</li>
     <li><b>Tag</b> - What Tag is associated with this record</li>
     <li><b>Stage</b> - Stage info for this record</li>
     <li><b>Select</b> - Is this record selected by NATO</li>

     <li><b>History</b> - What is the history of the record</li>
   </ul>

   <p>The following properties are related to the <i>standard</i> elements in are part of the enclosing record element.</p>
 
   <ul>
     <li><b>Debug</b> - A comment, which are only used to remember observed problems with this record.</li>
     <li><b>Std</b> - The position of the <i>standard</i> in the database</li>
   </ul>
  <p></p>
  
  <xsl:if test="$excelXP = 1">
    <table border="1" width="100%">
      <xsl:call-template name="htmlheader"/>
    </table>
  </xsl:if>
<!--
  <xsl:apply-templates select="servicearea"/>
-->

  <table border="1">
    <xsl:call-template name="htmlheader"/>
    <xsl:apply-templates select="records/standard">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>

  <h2>Profiles</h2>
  
  
  <table border="1">
    <xsl:call-template name="htmlheader"/>
    <xsl:apply-templates select="//profile">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>

  
  </body></html>
</xsl:template>


<xsl:template name="htmlheader">
  <tr class="head">
    <td><b>ID</b></td>
    <td><b>Type</b></td>
    <td><b>Org</b></td>
    <td><b>PubNum</b></td>
    <td><b>Title</b></td>
    <td><b>Date</b></td>
    <td><b>Correction</b></td>
    <td><b>AKA</b></td>
    <td><b>Tag</b></td>
    <td><b>Stage</b></td>
    <td><b>Select</b></td>

    <td><b>History</b></td>

<!--
    <td><b>Rec</b></td>
    <td><b>Type</b></td>
    <td><b>Debug</b></td>

    <td><b>Std</b></td>
-->
   </tr>
</xsl:template>





<xsl:template match="profile">
  <xsl:variable name="myid" select="@id"/>
  <tr>
    <xsl:if test=".//event[@flag = 'deleted']">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
<!--
    <td align="right"><xsl:number from="records" count="profile" format="1" level="any"/></td>
-->
    <td><xsl:value-of select="@id"/></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="@type='base'">BP</xsl:when>
        <xsl:when test="@type='coi'">C</xsl:when>
        <xsl:otherwise>CM</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilenote/@orgid"/>
    </td>
    <td>
      <xsl:if test="d/@pubnum =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@pubnum"/>
    </td>
    <td>
      <xsl:if test="document/@title =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@title"/>
    </td>
    <td>
      <xsl:if test="document/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@date"/>
    </td>        
    <td><xsl:apply-templates select="document/correction"/>&nbsp;</td>
    <td><xsl:apply-templates select="document/alsoknown"/>&nbsp;</td>
    <td><xsl:value-of select="@tag"/>&nbsp;</td>
    <td>
      <xsl:if test="status/@stage =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="status/@stage"/>&nbsp;
    </td>
    <td align="center">
      <xsl:if test="/standards/lists//select[(@mode='mandatory') and (@id=$myid)]">M</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='emerging') and (@id=$myid)]">E</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='midterm') and (@id=$myid)]">EM</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='longterm') and (@id=$myid)]">EL</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='fading') and (@id=$myid)]">F</xsl:if>
      &nbsp;
    </td>
    <td><xsl:apply-templates select=".//event"/>&nbsp;</td>

  </tr>
</xsl:template>




<xsl:template match="standard">
  <xsl:variable name="myid" select="@id"/>
  <tr>
    <xsl:if test=".//event[@flag = 'deleted']">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
<!--
    <td align="right"><xsl:number from="records" count="standard" format="1" level="any"/></td>
-->
    <td><xsl:value-of select="@id"/></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="document/substandards">CS</xsl:when>
        <xsl:when test="//substandards/refstandard/@refid=$myid">SS</xsl:when>
        <xsl:otherwise>S</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@orgid"/>
    </td>
    <td>
      <xsl:if test="document/@pubnum =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@pubnum"/>
    </td>
    <td>
      <xsl:if test="document/@title =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@title"/>
    </td>
    <td>
      <xsl:if test="document/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@date"/>
    </td>        
    <td><xsl:apply-templates select="document/correction"/>&nbsp;</td>
    <td><xsl:apply-templates select="document/alsoknown"/>&nbsp;</td>
    <td><xsl:value-of select="@tag"/>&nbsp;</td>
    <td>
      <xsl:if test="status/@stage =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="status/@stage"/>&nbsp;
    </td>
    <td align="center">
      <xsl:if test="/standards/lists//select[(@mode='mandatory') and (@id=$myid)]">M</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='emerging') and (@id=$myid)]">E</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='midterm') and (@id=$myid)]">EM</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='longterm') and (@id=$myid)]">EL</xsl:if>
      <xsl:if test="/standards/lists//select[(@mode='fading') and (@id=$myid)]">F</xsl:if>
      &nbsp;
    </td>
    <td><xsl:apply-templates select=".//event"/>&nbsp;</td>
  </tr>
</xsl:template>





<xsl:template match="correction">
  <xsl:if test="position()=1 and (@cpubnum = ''or @date = '')">
    <xsl:attribute name="bgcolor">yellow</xsl:attribute>
  </xsl:if>
  <xsl:value-of select="@cpubnum"/><xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test=".!=''"><xsl:text> (</xsl:text><xsl:value-of select="."/><xsl:text>)</xsl:text></xsl:if>
  <xsl:if test="following-sibling::correction[position()=1]"><br /></xsl:if>
</xsl:template>


<xsl:template match="alsoknown">
  <xsl:if test="position()=1 and (@orgid='' or @pubnum='' or @date='')"><xsl:attribute name="bgcolor">yellow</xsl:attribute></xsl:if>

  <xsl:value-of select="@orgid"/><xsl:text>:</xsl:text><xsl:value-of 
       select="@pubnum"/><xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test="following-sibling::alsoknown[position()=1]"><br /></xsl:if>
</xsl:template>



<xsl:template match="event">
  <xsl:if test="position()=1 and (@date = '')">
    <xsl:attribute name="class">missing</xsl:attribute>
  </xsl:if>
  <xsl:value-of select="translate(substring(@flag,1,1), 'acd', 'ACD')"/>
  <xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test="following-sibling::event[position()=1]"><br /></xsl:if>
</xsl:template>





















<xsl:template match="servicearea">
  <xsl:message>  processing <xsl:value-of select="@title"/></xsl:message>

  <h2><a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute><xsl:value-of select="@title"/> (ID: <xsl:value-of select="@id"/>)</a></h2>

  <table border="1" width="100%">
    <xsl:apply-templates/>
  </table>
</xsl:template>


<xsl:template name="zhtmlheader">
  <tr>
    <td><b>Rec</b></td>
    <td><b>Type</b></td>
    <td><b>ID</b></td>
    <td><b>Tag</b></td>
    <td><b>Stage</b></td>
    <td><b>Select</b></td>
    <td><b>History</b></td>
    <td><b>Debug</b></td>

    <td><b>Std</b></td>
    <td><b>Org</b></td>
    <td><b>PubNum</b></td>
    <td><b>Title</b></td>
    <td><b>Date</b></td>
    <td><b>Correction</b></td>
    <td><b>AKA</b></td>
   </tr>
</xsl:template>


<xsl:template match="servicecategory">
  <tr>
    <td colspan="16"  align="left" bgcolor="#00c0f2"><a><xsl:attribute name="name"><xsl:value-of select="@cid"/></xsl:attribute></a>
    <b><xsl:value-of select="@title"/> (ID: <xsl:value-of select="@id"/>)</b></td>
  </tr>
  <xsl:if test="$excelXP = 0"><xsl:call-template name="htmlheader"/></xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="category">
  <tr>
    <td colspan="16"  align="left"><a><xsl:attribute name="name"><xsl:value-of select="@cid"/></xsl:attribute></a>
    <b><xsl:value-of select="@title"/> (ID: <xsl:value-of select="@id"/>)</b></td>
  </tr>
  <xsl:if test="$excelXP = 0"><xsl:call-template name="htmlheader"/></xsl:if>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="standardrecord|profilerecord">
  <xsl:variable name="myid" select="@id"/>

  <tr>
    <!-- Use bgcolor=red for deleted records -->
    <xsl:if test=".//event[@flag = 'deleted']">
      <xsl:attribute name="bgcolor">red</xsl:attribute>
    </xsl:if>

    <td align="right"><xsl:number from="standards" count="standardrecord|profilerecord" format="1" level="any"/></td>
    <td align="center">
      <xsl:if test="name(.)='profilerecord'">P</xsl:if>
      <xsl:if test="name(.)='standardrecord'">S</xsl:if>
    </td>
    <td><xsl:value-of select="@id"/>&nbsp;</td>
    <td><xsl:value-of select="@tag"/>&nbsp;</td>
    <td><xsl:if test="status/@stage =''"><xsl:attribute name="bgcolor">yellow</xsl:attribute></xsl:if><xsl:value-of select="status/@stage"/>&nbsp;</td>
    <td align="center">
      <xsl:if test="//select[(@mode='mandatory') and (@id=$myid)]">M</xsl:if>
      <xsl:if test="//select[(@mode='emerging') and (@id=$myid)]">E</xsl:if>
      <xsl:if test="//select[(@mode='midterm') and (@id=$myid)]">EM</xsl:if>
      <xsl:if test="//select[(@mode='longterm') and (@id=$myid)]">EL</xsl:if>
      <xsl:if test="//select[(@mode='fading') and (@id=$myid)]">F</xsl:if>
      &nbsp;
    </td>
    <td><xsl:apply-templates select=".//event"/>&nbsp;</td>
    <td><xsl:value-of select="./debug"/>&nbsp;</td>

    <!-- From cell 9-16 -->
    <td colspan="8" bgcolor="#cecece">&nbsp;</td>
  </tr>
  <xsl:if test="name(.)='profilerecord'">
    <xsl:apply-templates select="parts"/>
  </xsl:if>
  <xsl:if test="name(.)='standardrecord'">
    <xsl:apply-templates select="standard"/>
  </xsl:if>
</xsl:template>



<xsl:template match="parts">
  <xsl:apply-templates select="standard"/>
</xsl:template>


<xsl:template match="zstandard">

  <tr>
    <!-- Use bgcolor=red for deleted records -->
    <xsl:if test="ancestor::standardrecord//event[@flag='deleted']|ancestor::profilerecord//event[@flag='deleted']">
      <xsl:attribute name="bgcolor">red</xsl:attribute>
    </xsl:if>

    <!-- Skip record properties -->
    <td colspan="8" bgcolor="#cecece">&nbsp;</td>

    <td align="right"><xsl:number from="/" count="standard" format="1" level="any"/></td>
    <td><xsl:if test="@orgid =''"><xsl:attribute name="bgcolor">yellow</xsl:attribute></xsl:if><xsl:value-of select="@orgid"/>&nbsp;</td>    
    <td><xsl:if test="@pubnum =''"><xsl:attribute name="bgcolor">yellow</xsl:attribute></xsl:if><xsl:value-of select="@pubnum"/>&nbsp;</td>
    <td><xsl:if test="@title =''"><xsl:attribute name="bgcolor">yellow</xsl:attribute></xsl:if><xsl:value-of select="@title"/>&nbsp;</td>    
    <td><xsl:if test="@date =''"><xsl:attribute name="bgcolor">yellow</xsl:attribute></xsl:if><xsl:value-of select="@date"/>&nbsp;</td>    
    <td><xsl:apply-templates select="correction"/>&nbsp;</td>
    <td><xsl:apply-templates select="alsoknown"/>&nbsp;</td>
  </tr>
  <xsl:apply-templates select="parts"/>
</xsl:template>






<xsl:template match="*"/>


</xsl:stylesheet>
