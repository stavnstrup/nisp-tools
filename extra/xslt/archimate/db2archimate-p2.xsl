<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                extension-element-prefixes="saxon"
                version='2.0'
                >


<!--
<xsl:output indent="yes" saxon:next-in-chain="db2archimate-p3.xsl"/>
-->
<xsl:output indent="yes"/>



<xsl:template match="standards">
  <model xmlns="http://www.opengroup.org/xsd/archimate/3.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengroup.org/xsd/archimate/3.0/ http://www.opengroup.org/xsd/archimate/3.1/archimate3_Diagram.xsd" identifier="id-93c48180-9e5b-4220-a666-ee020c07d53a">
    <name xml:lang="en">NISP Samples</name>
<!-- meta-data attributes -->
    <xsl:apply-templates select="records"/>
  </model>
</xsl:template>


<xsl:template match="records">
  <elements xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:apply-templates select="standard|coverdoc|profilespec|profile|serviceprofile" mode="element"/>
  </elements>
  <!--
  <relationships xmlns="http://www.opengroup.org/xsd/archimate/3.0/"/>
  -->
  <organizations xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <item>
      <label xml:lang="en">Technology &amp; Physical</label>
      <item>
        <label xml:lang="en">Profiles</label>
        <xsl:apply-templates select="profile" mode="organization"/>
      </item>
      <item>
        <label xml:lang="en">Service Profiles</label>
        <xsl:apply-templates select="serviceprofile" mode="organization"/>
      </item>
    </item>
    <item>
      <label xml:lang="en">Motivation</label>
       <xsl:apply-templates select="standard|coverdoc" mode="organization"/>
       <item>
         <label xml:lang="en">Profile Specifications</label>
         <xsl:apply-templates select="profilespec" mode="organization"/>
       </item>
    </item>
      <!--
    <item>
      <label xml:lang="en">Relations</label>
      <xsl:apply-templates select=".//refstandard" mode="organization"/>
      <xsl:apply-templates select=".//refprofile" mode="organization"/>
      <xsl:apply-templates select=".//refgroup" mode="organization"/>
    </item>
      -->
    <item>
      <label xml:lang="en">Views</label>
    </item>
  </organizations>
  <propertyDefinitions xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:apply-templates select="/standards/allattributes/*"/>
  </propertyDefinitions>
  <!--
  <views  xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <diagrams>
    </diagrams>
  </views>
  -->
</xsl:template>



<!-- ============================================================== -->
<!--                            Elements                            -->
<!-- ============================================================== -->


<xsl:template match="standard|coverdoc" mode="element">
  <xsl:variable name="myorgid" select="document/@orgid"/>
  <xsl:variable name="rp" select="responsibleparty/@rpref"/>
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="{uuid}" xsi:type="Principle">
    <name xml:lang="en"><xsl:value-of select="document/@title"/></name>
    <!--
    <documentation xml:lang="en"><xsl:apply-templates select="applicability"/></documentation>
    -->
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='organisation']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@short"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='pubnum']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@pubnum"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='date']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@date"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='version']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@version"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='responsibleparty']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="/standards/organisations/orgkey[@key=$rp]/@short"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='uri']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="status/uri"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nisp_element']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="local-name(.)"/></value>
      </property>
    </properties>
  </element>
</xsl:template>

<xsl:template match="applicability">
  <xsl:apply-templates xmlns="http://www.opengroup.org/xsd/archimate/3.0/"/>
</xsl:template>


<xsl:template match="profilespec" mode="element">
  <xsl:variable name="myorgid" select="@orgid"/>
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="{uuid}" xsi:type="Principle">
    <name xml:lang="en"><xsl:value-of select="@title"/></name>
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='organisation']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@short"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='pubnum']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="@pubnum"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='date']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="@date"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='version']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="@version"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nisp_element']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">profilespec</value>
      </property>
    </properties>
  </element>
</xsl:template>


<xsl:template match="profile|serviceprofile"  mode="element">
   <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="{uuid}" xsi:type="TechnologyService">
     <name xml:lang="en"><xsl:value-of select="@title"/></name>
     <properties>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='nisp_element']/@position"/>
         </xsl:attribute>
         <value xml:lang="en"><xsl:value-of select="local-name(.)"/></value>
       </property>
     </properties>
   </element>
</xsl:template>



<!-- ============================================================== -->
<!--                          Organization                          -->
<!-- ============================================================== -->


<xsl:template match="standard|coverdoc|profilespec|profile|serviceprofile" mode="organization">
  <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifierRef" select="uuid"/>
  </item>
</xsl:template>




<xsl:template match="refstandard|refprofile|refgroup" mode="organization">
 <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifierRef" select="@uuid"/>
  </item>
</xsl:template>


<!-- ============================================================== -->
<!--                      Propertydefinition                        -->
<!-- ============================================================== -->

<xsl:template match="def">
  <propertyDefinition xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifier">
      <xsl:text>propid-</xsl:text>
      <xsl:value-of select="@position"/>
    </xsl:attribute>
    <xsl:attribute name="type" select="'string'"/>
    <name><xsl:value-of select="@attribute"/></name>
  </propertyDefinition>
</xsl:template>





<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
