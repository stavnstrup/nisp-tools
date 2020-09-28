<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                extension-element-prefixes="saxon"
                version='2.0'>


<!--
<xsl:output indent="yes" saxon:next-in-chain="db2archimate-p4.xsl"/>
-->
<xsl:output indent="yes"/>



<xsl:template match="standards">
  <model xmlns="http://www.opengroup.org/xsd/archimate/3.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengroup.org/xsd/archimate/3.0/ http://www.opengroup.org/xsd/archimate/3.1/archimate3_Diagram.xsd" identifier="id-93c48180-9e5b-4220-a666-ee020c07d53a">
    <name xml:lang="en">NISP</name>
    <!-- Define meta-data attributes -->
    <xsl:apply-templates select="records"/>
  </model>
</xsl:template>


<xsl:template match="records">
  <!-- List all elements -->
  <elements xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:apply-templates select="standard|coverdoc|profilespec|profile|profilecontainer|serviceprofile|serviceprofile/refgroup" mode="element"/>
  </elements>
  <relationships xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <!-- Traverse the profiletrees -->
    <xsl:apply-templates select="/standards/profiletrees//refstandard" mode="listProfileRealtionship"/>
    <!-- Traverse the list of organizational pages -->
    <xsl:apply-templates select="/standards/orglist//reference" mode="listProfileRealtionship"/>
  </relationships>
  <!-- Organize elemets and relations -->
  <organizations xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <item>
      <label xml:lang="en">Business</label>
      <item>
        <label xml:lang="en">Agreement</label>
        <xsl:apply-templates select="coverdoc" mode="organization"/>
      </item>
      <item>
         <label xml:lang="en">Standards</label>
         <xsl:apply-templates select="/standards/organisations/orgkey" mode="organization"/>
      </item>
      <item>
        <label xml:lang="en">Profiles</label>
        <xsl:apply-templates select="profile" mode="organization"/>
      </item>
      <item>
        <label xml:lang="en">Profile Specifications</label>
        <xsl:apply-templates select="profilespec" mode="organization"/>
      </item>
      <item>
        <label xml:lang="en">Service Profile</label>
        <xsl:apply-templates select="serviceprofile" mode="organization"/>
      </item>
    </item>
    <item>
      <label xml:lang="en">Other</label>
      <item>
        <label xml:lang="en">Profile Containers</label>
        <xsl:apply-templates select="profilecontainer" mode="organization"/>
      </item>
      <item>
        <label xml:lang="en">Reference Groups</label>
        <xsl:apply-templates select="refgroup" mode="organization"/>
      </item>
    </item>
    <item>
      <label xml:lang="en">Relations</label>
      <xsl:apply-templates select="/standards/profiletrees//refstandard" mode="refProfileRealtionship"/>
    </item>
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
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="BusinessObject">
    <name xml:lang="en"><xsl:value-of select="document/@title"/>
      <xsl:if test="document/@orgid or document/@pubnum">
        <xsl:text>, </xsl:text>
        <xsl:if test="document/@orgid">
          <xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@short"/>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="document/@pubnum">
          <xsl:value-of select="document/@pubnum"/>
        </xsl:if>
      </xsl:if>
      <xsl:if test="document/@date">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="substring(document/@date, 1, 4)"/>
      </xsl:if>
    </name>
    <!--
    <documentation xml:lang="en"><xsl:apply-templates select="applicability"/></documentation>
    -->
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='publisher']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@short"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='identifier']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@pubnum"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='title']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="document/@title"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='dateAccepted']/@position"/>
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
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispResponsibleParty']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="/standards/organisations/orgkey[@key=$rp]/@short"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='externalIdentifier']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="status/uri"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="uuid"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
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
  <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="BusinessObject">
    <name xml:lang="en"><xsl:value-of select="@title"/></name>
    <properties>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='publisher']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@short"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='identifier']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="@pubnum"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='dateAccepted']/@position"/>
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
          <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
        </xsl:attribute>
        <value xml:lang="en"><xsl:value-of select="uuid"/></value>
      </property>
      <property>
        <xsl:attribute name="propertyDefinitionRef">
          <xsl:text>propid-</xsl:text>
          <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
        </xsl:attribute>
        <value xml:lang="en">profilespec</value>
      </property>
    </properties>
  </element>
</xsl:template>


<xsl:template match="profile|serviceprofile"  mode="element">
   <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="BusinessObject">
     <name xml:lang="en"><xsl:value-of select="@title"/></name>
     <properties>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
         </xsl:attribute>
         <value xml:lang="en"><xsl:value-of select="uuid"/></value>
       </property>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
         </xsl:attribute>
         <value xml:lang="en"><xsl:value-of select="local-name(.)"/></value>
       </property>
     </properties>
   </element>
</xsl:template>

<xsl:template match="profilecontainer"  mode="element">
   <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{uuid}" xsi:type="Grouping">
     <name xml:lang="en"><xsl:value-of select="@title"/></name>
     <properties>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
         </xsl:attribute>
         <value xml:lang="en"><xsl:value-of select="uuid"/></value>
       </property>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
         </xsl:attribute>
         <value xml:lang="en">profile container</value>
       </property>
     </properties>
   </element>
</xsl:template>


<xsl:template match="refgroup"  mode="element">
   <element xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifier="id-{@uuid}" xsi:type="Grouping">
     <name xml:lang="en"><xsl:value-of select="@title"/></name>
     <properties>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>description</xsl:text>
         </xsl:attribute>
         <value xml:lang="en"><xsl:value-of select="description"/></value>
       </property>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='nispObligation']/@position"/>
         </xsl:attribute>
         <value xml:lang="en"><xsl:value-of select="@obligation"/></value>
       </property>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='nisplifecycle']/@position"/>
         </xsl:attribute>
         <value xml:lang="en"><xsl:value-of select="@lifecycle"/></value>
       </property>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='nispUUID']/@position"/>
         </xsl:attribute>
         <value xml:lang="en"><xsl:value-of select="@uuid"/></value>
       </property>
       <property>
         <xsl:attribute name="propertyDefinitionRef">
           <xsl:text>propid-</xsl:text>
           <xsl:value-of select="/standards/allattributes/def[@attribute='stereotype']/@position"/>
         </xsl:attribute>
         <value xml:lang="en">refgroup</value>
       </property>
     </properties>
   </element>
</xsl:template>


<!-- ============================================================== -->
<!--                          Relationships                         -->
<!-- ============================================================== -->


<xsl:template match="refstandard" mode="listProfileRealtionship">
  <xsl:variable name="mytarget" select="@refid"/>
  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                 identifier="id-{@uuid}"
                 source="{ancestor::capabilityprofile/@uuid}"
                 xsi:type="Aggregation">
    <xsl:attribute name="target">
      <xsl:text>id-</xsl:text>
      <xsl:apply-templates select="/standards/records/*[@id=$mytarget]/uuid"/>
    </xsl:attribute>
  </relationship>
 </xsl:template>


<xsl:template match="reference" mode="listProfileRealtionship">
<!--
  <xsl:variable name="mytarget" select="@refid"/>
  <relationship xmlns="http://www.opengroup.org/xsd/archimate/3.0/"
                identifier="id-{@uuid}"
                source="id-{../@uuid}"
                xsi:type="Composition">
    <xsl:attribute name="target">
      <xsl:text>id-</xsl:text>
      <xsl:apply-templates select="/standards/records/*[@id=$mytarget]/uuid"/>
    </xsl:attribute>
  </relationship>
-->
 </xsl:template>


<xsl:template match="refstandard" mode="refProfileRealtionship">
  <item  xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifierRef="id-{@uuid}"/>
</xsl:template>

<!--
<xsl:apply-templates select="/standards/orglist//reference" mode="listProfileRealtionship"/>
-->


<!-- ============================================================== -->
<!--                          Organization                          -->
<!-- ============================================================== -->


<xsl:template match="orgkey" mode="organization">
  <xsl:variable name="myorg" select="@key"/>
  <xsl:if test="count(/standards//document[@orgid=$myorg])  > 0">
    <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
      <label xml:lang="en"><xsl:value-of select="@short"/></label>
      <xsl:apply-templates select="/standards//standard[document/@orgid=$myorg]" mode="organization"/>
    </item>
  </xsl:if>
</xsl:template>

<xsl:template match="standard|coverdoc|profilespec|profile|profilecontainer|serviceprofile" mode="organization">
  <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifierRef">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="uuid"/>
    </xsl:attribute>
  </item>
</xsl:template>

<xsl:template match="refstandard" mode="organization">
  <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:attribute name="identifierRef">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="@uuid"/>
    </xsl:attribute>
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


<!-- ============================================================== -->


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
