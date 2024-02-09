<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'>

<xsl:variable name="draft" select="''"/>     <!-- Prefix text used in name for DRAFT version -->

<xsl:variable name="modelTitle" select="'NATO Interoperability Standards and Profiles (NISP)'"/>
<xsl:variable name="modelDescription" select="'The NISP prescribes the necessary technical standards and profiles to achieve interoperability of Communications and Information Systems in support of NATOs missions and operations.'"/>
<xsl:variable name="nispVersion" select="'ADatP-34 ed. N Ver. 2'"/>
<xsl:variable name="modelPurpose" select="'Official Release'"/>
<xsl:variable name="dateCreated" select="current-dateTime()"/>
<xsl:variable name="nispDateIssued" select="'2023-08-18'"/>
<xsl:variable name="nispDateAccepted" select="'2023-10-12'"/>
<xsl:variable name="acceptedDocIF" select="'AC/322-WP(2023)0051-REV 2-AS1'"/>
<xsl:variable name="gitDescribe" select="'v15.0-1-gaacc82a6'"/>
<xsl:variable name="creator" select="'Interoperability Profiles Capability Team (IP CaT)'"/>
<xsl:variable name="publisher" select="'Consultation, Command and Control Board (C3B)'"/>

<!-- Version 5.0 of the C3 Taxonomy -->
<xsl:variable name="c3t-statement" select="'Generated from the ACT Enterprise Mapping Wiki on 23 Sep 2021'"/>
<xsl:variable name="c3t-date" select="'23 Sep 2021'"/>

</xsl:stylesheet>
