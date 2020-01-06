<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<!--

Make dynamic targets.

-->

<xsl:import href="common/common.xsl"/>

<xsl:output method="xml" indent="yes"/>
<!-- omit-xml-declaration="yes"/> -->


<xsl:template match="documents">
  <project>

  <!-- Generate multitarget -->
<!--
  <xsl:call-template name="alldocs">
    <xsl:with-param name="ext" select="'valid'"/>
    <xsl:with-param name="comment" select="'* Validate all source documents'"/>
  </xsl:call-template>
-->

  <xsl:call-template name="alldocs">
    <xsl:with-param name="ext" select="'resolve'"/>
    <xsl:with-param name="dependsOn" select="'init'"/>
  </xsl:call-template>

  <xsl:call-template name="alldocs">
    <xsl:with-param name="ext" select="'olinks'"/>
    <xsl:with-param name="dependsOn" select="'init'"/>
  </xsl:call-template>

<!--
  <xsl:call-template name="alldocs">
    <xsl:with-param name="ext" select="'svg'"/>
    <xsl:with-param name="dependsOn" select="'init'"/>
  </xsl:call-template>

  <xsl:call-template name="alldocs">
    <xsl:with-param name="ext" select="'getfigs'"/>
    <xsl:with-param name="dependsOn" select="'init'"/>
  </xsl:call-template>
-->

  <xsl:call-template name="alldocs">
    <xsl:with-param name="ext" select="'html'"/>
    <xsl:with-param name="dependsOn" select="'init, master, acronyms'"/>
    <xsl:with-param name="comment" select="'* Create all HTML files destined for the web'"/>
  </xsl:call-template>

<!--
  <xsl:call-template name="alldocs">
    <xsl:with-param name="ext" select="'rtf'"/>
    <xsl:with-param name="dependsOn" select="'init, pdf'"/>
    <xsl:with-param name="comment" select="'* Create all RTF files'"/>
  </xsl:call-template>
-->

  <xsl:call-template name="alldocs">
    <xsl:with-param name="ext" select="'pdf'"/>
    <xsl:with-param name="dependsOn" select="'init'"/>
    <xsl:with-param name="comment" select="'* Create a PDF version of NISP'"/>
    <xsl:with-param name="additionaltarget" select="'bigPDF'"/>
  </xsl:call-template>



  <target name="copy.svg">
    <mkdir>
      <xsl:attribute name="dir">
        <xsl:text>${build.dir}/figures</xsl:text>
      </xsl:attribute>
    </mkdir>
    <copy preservelastmodified="true">
      <xsl:attribute name="todir">
        <xsl:text>${build.dir}/figures</xsl:text>
      </xsl:attribute>
      <fileset>
        <xsl:attribute name="dir">
          <xsl:text>${src.dir}/figures/</xsl:text>
        </xsl:attribute>
        <include name="*.svg"/>
        <exclude name="obsolete/*.svg"/>
      </fileset>
    </copy>
  </target>

  <target name="svg.required" depends="copy.svg">
    <uptodate property="svg.notRequired">
      <srcfiles includes="*.svg">
        <xsl:attribute name="dir">
          <xsl:text>${build.dir}/figures</xsl:text>
        </xsl:attribute>
      </srcfiles>
      <mapper type="glob" from="*.svg">
        <xsl:attribute name="to">
          <xsl:text>${build.dir}/figures/*.${nisp.image.ext}</xsl:text>
        </xsl:attribute>
      </mapper>
    </uptodate>
  </target>

  <target name="svg" depends="init, svg.required"
          unless="svg.notRequired">
    <echo>
      <xsl:attribute name="message">
        <xsl:text>Create figures for HTML (${dpi.raster} dpi)</xsl:text>
      </xsl:attribute>
    </echo>
    <rasterize bg="255,255,255">
      <xsl:attribute name="result">
        <xsl:text>${nisp.image.mimetype}</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="quality">
        <xsl:text>${nisp.image.quality}</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="dpi">
        <xsl:text>${dpi.raster}</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="destdir">
        <xsl:text>${build.dir}/figures/</xsl:text>
      </xsl:attribute>
      <fileset>
        <xsl:attribute name="dir">
          <xsl:text>${build.dir}/figures/</xsl:text>
        </xsl:attribute>
        <include name="*.svg"/>
        <depend>
          <xsl:attribute name="targetdir">
            <xsl:text>${build.dir}/figures/</xsl:text>
          </xsl:attribute>
          <mapper type="glob" from="*.svg">
            <xsl:attribute name="to">
              <xsl:text>*.${nisp.image.ext}</xsl:text>
            </xsl:attribute>
          </mapper>
        </depend>
      </fileset>
    </rasterize>
  </target>

  <target name="getfigs" depends="svg">
    <copy>
      <xsl:attribute name="preservelastmodified">
        <xsl:text>true</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="todir">
        <xsl:text>${build.dir}/htmlhelp/figures</xsl:text>
      </xsl:attribute>
      <fileset>
        <xsl:attribute name="dir">
          <xsl:text>${build.dir}/figures</xsl:text>
        </xsl:attribute>
        <include>
          <xsl:attribute name="name">
            <xsl:text>*.${nisp.image.ext}</xsl:text>
          </xsl:attribute>
        </include>
      </fileset>
    </copy>
  </target>

  <target name="bigPDF.required">
    <uptodate property="bigPDF.notRequired">
      <xsl:attribute name="targetfile">
        <xsl:text>${build.dir}/pdf/NISP-v${src-version-major}${nisp.lifecycle.postfix}.pdf</xsl:text>
      </xsl:attribute>
      <srcfiles includes="NISP-Vol*.pdf">
         <xsl:attribute name="dir">
           <xsl:text>${build.dir}/pdf</xsl:text>
         </xsl:attribute>
      </srcfiles>
    </uptodate>
  </target>

  <target name="bigPDF" unless="bigPDF.notRequired">
    <xsl:attribute name="depends">
      <xsl:for-each select=".//docinfo">
        <xsl:value-of select="@id"/>
        <xsl:text>.pdf, </xsl:text>
      </xsl:for-each>
      <xsl:text>bigPDF.required</xsl:text>
    </xsl:attribute>
    <java classname="dk.stavnstrup.nisp.apps.MergePDF" fork="yes">
      <xsl:attribute name="dir">
         <xsl:text>${build.fo}</xsl:text>
      </xsl:attribute>
      <arg>
        <xsl:attribute name="line">
          <xsl:text>${tool-version} ${describe} NISP-v${src-version-major}${nisp.lifecycle.postfix}.pdf </xsl:text>
          <xsl:for-each select=".//docinfo">
            <xsl:value-of select="targets/target[@type='pdf']"/>
            <xsl:text>-v${src-version-major}${nisp.lifecycle.postfix}.pdf </xsl:text>
          </xsl:for-each>
        </xsl:attribute>
      </arg>
      <classpath refid="lib-fop-classpath"/>
    </java>
    <delete quiet="true">
      <xsl:attribute name="file">
        <xsl:text>${build.fo}/CombinedPDFDocument.pdf</xsl:text>
      </xsl:attribute>
    </delete>
  </target>

  <!-- Generate targets for each document -->
  <xsl:apply-templates/>

  </project>
</xsl:template>


<xsl:template match="docinfo">
  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>
  <xsl:variable name="title" select="./titles/title"/>

  <xsl:comment> Directories </xsl:comment>
  <property name="src.{$docid}">
    <xsl:attribute name="value">
      <xsl:text>${src.dir}/</xsl:text>
      <xsl:value-of select="$dir"/>
    </xsl:attribute>
  </property>

  <property name="build.{$docid}">
    <xsl:attribute name="value">
      <xsl:text>${build.dir}/</xsl:text>
      <xsl:value-of select="../@dir"/>
    </xsl:attribute>
  </property>

  <xsl:comment> Source file names </xsl:comment>

  <property name="{$docid}.main.src">
    <xsl:attribute name="value">
      <xsl:value-of select=".//main"/>
    </xsl:attribute>
  </property>

  <property name="{$docid}.resolve.src" value="{$docid}-resolved.xml"/>
  <property name="{$docid}.postresolve.src" value="{$docid}-postresolved.xml"/>

  <property name="{$docid}.pdf.file">
    <xsl:attribute name="value">
      <xsl:value-of select=".//target[@type='pdf']"/>
      <xsl:text>-v${src-version-major}${nisp.lifecycle.postfix}.pdf</xsl:text>
    </xsl:attribute>
  </property>

  <property name="{$docid}.rtf.file">
    <xsl:attribute name="value">
      <xsl:value-of select=".//target[@type='pdf']"/>
      <xsl:text>-v${src-version-major}${nisp.lifecycle.postfix}.rtf</xsl:text>
    </xsl:attribute>
  </property>


  <xsl:variable name="resolve" select="./resolve"/>

  <property name="xsl-resolve-{$docid}" value="{$resolve}"/>

  <!-- HTML/PDF targets -->
  <target name="{$docid}" description="* Create {$title} in HTML5 and PDF" depends="{$docid}.html, {$docid}.pdf"/>

  <!-- Validate targets -->
<!--
  <xsl:call-template name="makeValid"/>
-->

  <!-- Resolve targets -->
  <xsl:call-template name="makeResolve"/>

  <!-- Olink targets -->
  <xsl:call-template name="makeOLINKS"/>

  <!-- SVG to Raster targets -->
<!--
  <xsl:choose>
    <xsl:when test="figures"><xsl:call-template name="makeSVG"/></xsl:when>
    <xsl:otherwise><target name="{$docid}.svg"/></xsl:otherwise>
  </xsl:choose>

  <xsl:call-template name="getFIGS"/>
-->

  <!-- HTML5 targets -->
  <xsl:call-template name="makeHTML"/>

  <!-- PDF target -->
  <xsl:call-template name="makePDF"/>

  <!-- RTF target -->
<!--
  <xsl:call-template name="makeRTF"/>
-->

</xsl:template>


<xsl:template match="part">
  <xsl:text>,</xsl:text>
  <xsl:value-of select="."/>
</xsl:template>



<!-- =================================================================== -->
<!-- Create Validation targets                                           -->
<!-- =================================================================== -->

<xsl:template name="makeValid">
  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>

  <target name="{$docid}.valid">
    <xmlvalidate failonerror="no"
                 classname="org.apache.xerces.parsers.SAXParser">
      <fileset>
        <xsl:attribute name="dir">
          <xsl:text>${src.</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>}</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="includes">
	  <xsl:text>${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.main.src}</xsl:text>
	</xsl:attribute>
      </fileset>
      <attribute name="http://apache.org/xml/features/xinclude" value="true"/>
      <attribute name="http://xml.org/sax/features/namespaces" value="true"/>
      <attribute name="http://xml.org/sax/features/validation" value="true"/>
      <xmlcatalog refid="allcatalogs"/>
      <classpath refid="lib-saxon-classpath"/>
    </xmlvalidate>
  </target>
</xsl:template>


<!-- =================================================================== -->
<!-- Create Resolved targets                                             -->
<!-- =================================================================== -->

<xsl:template name="makeResolve">
  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>
  <xsl:variable name="title" select="./titles/title"/>
  <xsl:variable name="usedb" select="./resolve/@usedb"/>
  <xsl:variable name="db" select="./resolve/@db"/>

  <xsl:if test="$usedb='yes'">
    <!-- Check if the database needs to be resolved -->

    <target name="{$docid}.db-resolve.check">
      <uptodate property="{$docid}.db-resolve.notRequired">
        <xsl:attribute name="targetfile">
	  <xsl:text>${build.resolve}/resolved-</xsl:text>
          <xsl:value-of select="$db"/>
	</xsl:attribute>

        <srcfiles>
          <xsl:attribute name="includes">
            <xsl:value-of select="$db"/>
          </xsl:attribute>
          <xsl:attribute name="dir">
            <xsl:text>${src.dir}/standards/</xsl:text>
          </xsl:attribute>
        </srcfiles>

        <srcfiles>
          <xsl:attribute name="dir">
            <xsl:text>${xsl-styles.dir}/resolve</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="includes">
            <xsl:text>${xsl-resolve-db}</xsl:text>
          </xsl:attribute>
        </srcfiles>
      </uptodate>
    </target>

    <!-- resolve the database -->

    <target name="{$docid}.db-resolve"
            depends="init, {$docid}.db-resolve.check"
            unless="{$docid}.db-resolve.notRequired">
      <echo message="Resolve {$title} DB"/>
      <java fork="yes">
        <xsl:attribute name="classname">
          <xsl:text>${xslt.class}</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="dir">
          <xsl:text>${src.</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>}</xsl:text>
        </xsl:attribute>
        <arg>
          <xsl:attribute name="line">
            <xsl:text>${xslt.opts} -o ${build.resolve}/resolved-</xsl:text>
            <xsl:value-of select="$db"/>
            <xsl:text> ${src.dir}/standards/</xsl:text>
            <xsl:value-of select="$db"/>
            <xsl:text></xsl:text>
            <xsl:text> ${xsl-styles.dir}/resolve/${xsl-resolve-db}</xsl:text>
          </xsl:attribute>
        </arg>

        <classpath refid="lib-saxon-classpath"/>
        <jvmarg><xsl:attribute name="value"><xsl:text>${use.sax}</xsl:text></xsl:attribute></jvmarg>
        <jvmarg><xsl:attribute name="value"><xsl:text>${use.dom}</xsl:text></xsl:attribute></jvmarg>
        <jvmarg><xsl:attribute name="value"><xsl:text>${use.xinc}</xsl:text></xsl:attribute></jvmarg>
      </java>
    </target>
  </xsl:if>

  <!-- Check if the document needs to be resolved -->

  <target name="{$docid}.resolve.check">
    <uptodate  property="{$docid}-resolve.notRequired">
      <xsl:attribute name="targetfile">
        <xsl:text>${build.resolve}/${</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>.resolve.src}</xsl:text>
      </xsl:attribute>

      <srcfiles>
        <xsl:attribute name="dir">
          <xsl:text>${src.</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>}</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="includes">
          <xsl:text>*.xml</xsl:text>
        </xsl:attribute>
      </srcfiles>

      <xsl:if test="$usedb='yes'">
        <srcfiles>
          <xsl:attribute name="includes">
	    <xsl:text>resolved-</xsl:text>
            <xsl:value-of select="$db"/>
          </xsl:attribute>
          <xsl:attribute name="dir">
            <xsl:text>${build.resolve}/</xsl:text>
          </xsl:attribute>
        </srcfiles>
      </xsl:if>

      <srcfiles>
        <xsl:attribute name="dir">
          <xsl:text>${xsl-styles.dir}/resolve</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="includes">
          <xsl:text>${xsl-resolve-</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>}</xsl:text>
        </xsl:attribute>
      </srcfiles>
    </uptodate>
  </target>

  <!-- resolve the document -->

  <target name="{$docid}.resolve"
          unless="{$docid}-resolve.notRequired">
    <xsl:attribute name="depends">
      <xsl:text>init, </xsl:text>
      <xsl:if test="$usedb='yes'">
        <xsl:value-of select="$docid"/>
        <xsl:text>.db-resolve, </xsl:text>
      </xsl:if>
      <xsl:value-of select="$docid"/>
      <xsl:text>.resolve.check</xsl:text>
    </xsl:attribute>
    <echo message="Resolve {$title}"/>
    <java fork="yes">
      <xsl:attribute name="classname">
        <xsl:text>${xslt.class}</xsl:text>
      </xsl:attribute>

      <xsl:attribute name="dir">
        <xsl:text>${src.</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>}</xsl:text>
      </xsl:attribute>
      <arg>
        <xsl:attribute name="line">
          <xsl:text>${xslt.opts} -o ${build.resolve}/${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.resolve.src} ${src.</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>}/${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.main.src} ${xsl-styles.dir}/resolve/${xsl-resolve-</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>}</xsl:text>
          <xsl:if test="$db">
	    <xsl:text> dbname=resolved-</xsl:text>
            <xsl:value-of select="$db"/>
	  </xsl:if>
          <xsl:text> docid=</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text> documentdir=</xsl:text>
          <xsl:value-of select="$dir"/>
          <xsl:text> use.show.indexterms=</xsl:text>
          <xsl:text>${use.show.indexterms}</xsl:text>
          <xsl:text> nisp.image.ext=</xsl:text>
          <xsl:text>${nisp.image.ext}</xsl:text>
          <xsl:text> describe=${describe}</xsl:text>
        </xsl:attribute>
      </arg>

      <classpath refid="lib-saxon-classpath"/>
      <jvmarg><xsl:attribute name="value"><xsl:text>${use.sax}</xsl:text></xsl:attribute></jvmarg>
      <jvmarg><xsl:attribute name="value"><xsl:text>${use.dom}</xsl:text></xsl:attribute></jvmarg>
      <jvmarg><xsl:attribute name="value"><xsl:text>${use.xinc}</xsl:text></xsl:attribute></jvmarg>
    </java>
  </target>


</xsl:template>


<!-- =================================================================== -->
<!-- Create Olink targets                                                -->
<!-- =================================================================== -->

<xsl:template name="makeOLINKS">
  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>
  <xsl:variable name="usedb" select="./resolve/@usedb"/>
  <xsl:variable name="db" select="./resolve/@db"/>

  <target name="{$docid}-olinks.check" depends="init">
    <uptodate property="{$docid}-olinks.notRequired">
      <xsl:attribute name="targetfile">
        <xsl:text>${src.dir}/olinks/</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>-target.db</xsl:text>
      </xsl:attribute>
      <srcfiles>
        <xsl:attribute name="dir"><xsl:text>${build.resolve}</xsl:text></xsl:attribute>
        <xsl:attribute name="includes">
          <xsl:text>${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.resolve.src}</xsl:text>
        </xsl:attribute>
      </srcfiles>
      <xsl:if test="$usedb='yes'">
        <srcfiles>
          <xsl:attribute name="includes">
            <xsl:value-of select="$db"/>
          </xsl:attribute>
          <xsl:attribute name="dir">
            <xsl:text>${src.dir}/standards/</xsl:text>
          </xsl:attribute>
        </srcfiles>
      </xsl:if>
    </uptodate>
  </target>

  <target name="{$docid}.olinks"
          depends="init, {$docid}.resolve, {$docid}-olinks.check"
          unless="{$docid}-olinks.notRequired">
    <mkdir>
      <xsl:attribute name="dir">
        <xsl:text>${build.dir}/</xsl:text>
        <xsl:value-of select="$dir"/>
      </xsl:attribute>
    </mkdir>
    <java fork="yes">
      <xsl:attribute name="classname"><xsl:text>${xslt.class}</xsl:text></xsl:attribute>
      <xsl:attribute name="dir">
        <xsl:text>${build.</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>}</xsl:text>
      </xsl:attribute>
      <arg>
        <xsl:attribute name="line">
          <xsl:text>${build.resolve}/${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.resolve.src} ${xsl-xhtml.dir}/${xsl-chunk} </xsl:text>
          <xsl:text>target.database.document=${src.dir}/olinks/olinksdb.xml current.docid=</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text> collect.xref.targets=only</xsl:text>
        </xsl:attribute>
      </arg>
      <classpath refid="lib-saxon-classpath"/>
    </java>
    <move>
      <xsl:attribute name="file">
        <xsl:text>${build.</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>}/target.db</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="tofile">
        <xsl:text>${src.dir}/olinks/</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>-target.db</xsl:text>
      </xsl:attribute>
    </move>
  </target>
</xsl:template>


<!-- =================================================================== -->
<!-- Create SVG targets                                                  -->
<!-- =================================================================== -->


<xsl:template name="makeSVG">

  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>

  <target name="{$docid}-svg.required">
    <mkdir>
      <xsl:attribute name="dir">
        <xsl:text>${build.dir}/</xsl:text>
        <xsl:value-of select="$dir"/>
        <xsl:text>/figures</xsl:text>
      </xsl:attribute>
    </mkdir>
    <copy preservelastmodified="true">
      <xsl:attribute name="todir">
        <xsl:text>${build.dir}/</xsl:text>
        <xsl:value-of select="$dir"/>
        <xsl:text>/figures</xsl:text>
      </xsl:attribute>
      <fileset>
        <xsl:attribute name="dir">
          <xsl:text>${src.</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>}/figures</xsl:text>
        </xsl:attribute>
        <include name="*.svg"/>
        <exclude name="obsolete/*.svg"/>
      </fileset>
    </copy>

    <uptodate property="{$docid}-svg.notRequired">
      <srcfiles includes="*.svg">
        <xsl:attribute name="dir">
          <xsl:text>${build.dir}/</xsl:text>
          <xsl:value-of select="$dir"/>
          <xsl:text>/figures</xsl:text>
        </xsl:attribute>
      </srcfiles>
      <mapper type="glob" from="*.svg">
        <xsl:attribute name="to">
          <xsl:text>${build.dir}/</xsl:text>
          <xsl:value-of select="$dir"/>
          <xsl:text>/figures/*.${nisp.image.ext}</xsl:text>
        </xsl:attribute>
      </mapper>
    </uptodate>
  </target>

  <target name="{$docid}.svg" depends="init, {$docid}-svg.required"
          unless="{$docid}-svg.notRequired">
    <echo>
      <xsl:attribute name="message">
        <xsl:text>Create </xsl:text>
        <xsl:value-of select="./titles/title"/>
        <xsl:text> figures for HTML (${dpi.raster} dpi)</xsl:text>
      </xsl:attribute>
    </echo>
    <rasterize  quality="0.9">
      <xsl:attribute name="result">
        <xsl:text>${nisp.image.mimetype}</xsl:text>
      </xsl:attribute> 
      <xsl:attribute name="dpi">
        <xsl:text>${dpi.raster}</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="destdir">
        <xsl:text>${build.dir}/</xsl:text>
        <xsl:value-of select="$dir"/>
        <xsl:text>/figures/</xsl:text>
      </xsl:attribute>
      <fileset>
        <xsl:attribute name="dir">
          <xsl:text>${build.dir}/</xsl:text>
          <xsl:value-of select="$dir"/>
          <xsl:text>/figures/</xsl:text>
        </xsl:attribute>
        <include name="*.svg"/>
        <depend>
          <xsl:attribute name="targetdir">
            <xsl:text>${build.dir}/</xsl:text>
            <xsl:value-of select="$dir"/>
            <xsl:text>/figures/</xsl:text>
          </xsl:attribute>
          <mapper type="glob" from="*.svg" to="*.jpg"/>
        </depend>
      </fileset>
    </rasterize>
  </target>

</xsl:template>

<!-- =================================================================== -->
<!-- Get Figures for HTMLHelp target                                     -->
<!-- =================================================================== -->

<xsl:template name="getFIGS">
  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>

  <target name="{$docid}.getfigs" depends="svg">

    <!-- Copy to HTML dir -->
    <mkdir>
      <xsl:attribute name="dir">
        <xsl:text>${build.dir}/</xsl:text>
        <xsl:value-of select="$dir"/>
        <xsl:text>/figures</xsl:text>
      </xsl:attribute>
    </mkdir>
    <copy preservelastmodified="true">
      <xsl:attribute name="todir">
        <xsl:text>${build.dir}/htmlhelp/figures/</xsl:text>
        <xsl:value-of select="$dir"/>
      </xsl:attribute>
      <fileset>
        <xsl:attribute name="dir">
          <xsl:text>${build.dir}/</xsl:text>
          <xsl:value-of select="$dir"/>
          <xsl:text>/figures</xsl:text>
        </xsl:attribute>
        <include>
          <xsl:attribute name="name">
            <xsl:text>*.${nisp.image.ext}</xsl:text>
          </xsl:attribute>
        </include>
      </fileset>
    </copy>
  </target>
</xsl:template>

<!-- =================================================================== -->
<!-- Create HTML5 targets                                                -->
<!-- =================================================================== -->

<xsl:template name="makeHTML">
  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>
  <xsl:variable name="title" select="./titles/title"/>
  <xsl:variable name="pdf.prefix" select="./targets/target[@type='pdf']"/>

  <target name="{$docid}.html.check" depends="init">
    <mkdir>
      <xsl:attribute name="dir">
        <xsl:text>${build.dir}/</xsl:text>
        <xsl:value-of select="$dir"/>
      </xsl:attribute>
    </mkdir>
    <uptodate  property="{$docid}-html.notRequired">
      <xsl:attribute name="targetfile">
        <xsl:text>${build.</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>}/index.html</xsl:text>
      </xsl:attribute>

      <srcfiles>
        <xsl:attribute name="dir">
          <xsl:text>${build.resolve}</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="includes">
          <xsl:text>${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.resolve.src}</xsl:text>
        </xsl:attribute>
      </srcfiles>

      <srcfiles>
        <xsl:attribute name="dir">
          <xsl:text>${xsl-styles.dir}</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="includes">
          <xsl:text>${xsl-all-xhtml}</xsl:text>
        </xsl:attribute>
      </srcfiles>
    </uptodate>
  </target>

  <target name="{$docid}.html" description="* Create {$title} in HTML5"
          depends="svg, {$docid}.resolve, {$docid}.html.check"
          unless="{$docid}-html.notRequired">
    <echo message="Create {$title} as chunked HTML5 pages"/>

    <java fork="yes">
      <xsl:attribute name="classname">
        <xsl:text>${xslt.class}</xsl:text>
      </xsl:attribute>

      <arg>
        <xsl:attribute name="line">
          <xsl:text>${xslt.opts} -o ${build.resolve}/${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.postresolve.src} ${build.resolve}/${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.resolve.src} ${xsl-styles.dir}/resolve/postresolve-html.xsl</xsl:text>
        </xsl:attribute>
      </arg>
      <classpath refid="lib-saxon-classpath"/>
    </java>

    <java fork="yes">
      <xsl:attribute name="classname">
        <xsl:text>${xslt.class}</xsl:text>
      </xsl:attribute>

      <xsl:attribute name="dir">
        <xsl:text>${build.</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>}</xsl:text>
      </xsl:attribute>

      <xsl:if test=".//target[@type='html'][@heapmemory]">
         <xsl:attribute name="maxmemory">
            <xsl:value-of select=".//target[@type='html']/@heapmemory"/>
         </xsl:attribute>
      </xsl:if>

      <xsl:if test=".//target[@type='html'][@stackmemory]">
        <jvmarg>
          <xsl:attribute name="value">
            <xsl:text>-Xss</xsl:text>
            <xsl:value-of select=".//target[@type='html']/@stackmemory"/>
          </xsl:attribute>
        </jvmarg>
      </xsl:if>

      <arg>
        <xsl:attribute name="line">
          <xsl:text>${xslt.opts} ${build.resolve}/${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.postresolve.src} ${xsl-xhtml.dir}/${xsl-chunk} ${nisp.lifecycle.opts}</xsl:text>
          <xsl:text> docid=</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text> pdf.prefix=</xsl:text>
          <xsl:value-of select="$pdf.prefix"/>
          <xsl:text> use.para.numbering=${use.para.numbering}</xsl:text>
          <xsl:text> datestamp=${DSTAMP}</xsl:text>
          <xsl:text> describe=${describe}</xsl:text>
        </xsl:attribute>
      </arg>
      <classpath refid="lib-saxon-classpath"/>
    </java>
  </target>

</xsl:template>




<!-- =================================================================== -->
<!-- Create PDF targets                                                  -->
<!-- =================================================================== -->


<xsl:template name="makePDF">
  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>
  <xsl:variable name="title" select="./titles/title"/>
  <xsl:variable name="ltitle" select="./titles/longtitle"/>
  <xsl:variable name="pdf.prefix" select="./targets/target[@type='pdf']"/>

  <target name="{$docid}.pdf.check" depends="init">
    <uptodate property="{$docid}-pdf.notRequired">
      <xsl:attribute name="targetfile">
        <xsl:text>${build.fo}/${</xsl:text>
        <xsl:value-of select="$docid"/>
        <xsl:text>.pdf.file}</xsl:text>
      </xsl:attribute>

      <srcfiles>
        <xsl:attribute name="dir">
          <xsl:text>${build.resolve}</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="includes">
          <xsl:text>${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.resolve.src}</xsl:text>
        </xsl:attribute>
      </srcfiles>
<!--
      <srcfiles>
        <xsl:attribute name="dir">
          <xsl:text>${build.dir}/figures/</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="includes">
          <xsl:text>*.${nisp.image.ext}</xsl:text>
        </xsl:attribute>
      </srcfiles>
-->
      <srcfiles>
        <xsl:attribute name="dir">
          <xsl:text>${xsl-styles.dir}</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="includes">
          <xsl:text>${xsl-all-fo}</xsl:text>
        </xsl:attribute>
      </srcfiles>
    </uptodate>
  </target>


  <target name="{$docid}.pdf"
          description="* Create {$title} in PDF"
          depends="layout-fo, copy.svg, {$docid}.resolve, {$docid}.pdf.check"
          unless="{$docid}-pdf.notRequired">
    <echo message="Create {$title} print version"/>
    <java fork="yes">
      <xsl:attribute name="classname"><xsl:text>${xslt.class}</xsl:text></xsl:attribute>
      <xsl:attribute name="dir"><xsl:text>${build.fo}</xsl:text></xsl:attribute>
      <xsl:if test=".//target[@type='pdf'][@stackmemory]">
        <jvmarg>
          <xsl:attribute name="value">
            <xsl:text>-Xss</xsl:text>
            <xsl:value-of select=".//target[@type='pdf']/@stackmemory"/>
          </xsl:attribute>
        </jvmarg>
      </xsl:if>
      <arg>
        <xsl:attribute name="line">
          <xsl:text>${xslt.opts} -o </xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.fo ${build.resolve}/${</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.resolve.src} ${xsl-fo.dir}/${xsl-fo} ${nisp.lifecycle.opts}</xsl:text>
          <xsl:text> pdf.prefix=</xsl:text>
          <xsl:value-of select="$pdf.prefix"/>
          <xsl:text> use.para.numbering=${use.para.numbering}</xsl:text>
          <xsl:text> describe=${describe}</xsl:text>
        </xsl:attribute>
      </arg>
      <classpath refid="lib-saxon-classpath"/>
    </java>

    <echo message="Transforming {$title}.fo to PDF"/>

    <xsl:choose>
      <xsl:when test=".//target[@type='pdf'][@heapmemory]">

        <java classname="org.apache.fop.apps.Fop" fork="yes">
<!--

        <java classname="org.apache.fop.cli.Main" fork="yes">
-->
          <xsl:attribute name="dir">
            <xsl:text>${build.fo}</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="maxmemory">
            <xsl:value-of select=".//target[@type='pdf']/@heapmemory"/>
          </xsl:attribute>
          <arg>
            <xsl:attribute name="line">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$docid"/>
              <xsl:text>.fo </xsl:text>
              <xsl:value-of select="$docid"/>
              <xsl:text>.pdf</xsl:text>
            </xsl:attribute>
          </arg>
          <classpath refid="lib-fop-classpath"/>
        </java>
      </xsl:when>
      <xsl:otherwise>
        <fop>
          <xsl:attribute name="basedir"><xsl:text>${build.fo}/</xsl:text></xsl:attribute>
          <xsl:attribute name="fofile">
            <xsl:text>${build.fo}/</xsl:text>
            <xsl:value-of select="$docid"/>
            <xsl:text>.fo</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="outfile">
            <xsl:text>${build.fo}/</xsl:text>
            <xsl:text>${</xsl:text>
            <xsl:value-of select="$docid"/>
            <xsl:text>.pdf.file}</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="format"><xsl:text>application/pdf</xsl:text></xsl:attribute>
          <xsl:attribute name="messagelevel"><xsl:text>${fop.message}</xsl:text></xsl:attribute>
          <xsl:attribute name="userconfig"><xsl:text>${basedir}/lib/fop.xconf</xsl:text></xsl:attribute>
        </fop>
      </xsl:otherwise>
    </xsl:choose>
  </target>
</xsl:template>




<!-- =================================================================== -->
<!-- Create RTF targets                                                  -->
<!-- =================================================================== -->

<!--
<xsl:template name="makeRTF">
  <xsl:variable name="docid" select="./@id"/>
  <xsl:variable name="dir" select="../@dir"/>
  <xsl:variable name="title" select="./titles/title"/>
  <xsl:variable name="ltitle" select="./titles/longtitle"/>
  <xsl:variable name="pdf.prefix" select="./targets/target[@type='pdf']"/>

  <target name="{$docid}.rtf"
          description="* Create {$title} in RTF"
          depends="{$docid}.pdf">
    <echo message="FIX FO version"/>
    <java fork="yes">
      <xsl:attribute name="classname"><xsl:text>${xslt.class}</xsl:text></xsl:attribute>
      <xsl:attribute name="dir"><xsl:text>${build.dir}/rtf/</xsl:text></xsl:attribute>
      <arg>
        <xsl:attribute name="line">
          <xsl:text> -o </xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.fo ${build.fo}/</xsl:text>
          <xsl:value-of select="$docid"/>
          <xsl:text>.fo ${xsl-styles.dir}/rtf-prepare.xsl</xsl:text>
        </xsl:attribute>
      </arg>
      <classpath refid="lib-saxon-classpath"/>
    </java>

    <echo message="Make RTF version"/>
    <xsl:choose>
      <xsl:when test=".//target[@type='pdf'][@heapmemory]">
        <echo message="RTF 1"/>
        <java classname="org.apache.fop.apps.Fop" fork="yes">
          <xsl:attribute name="dir">
            <xsl:text>${build.dir}/rtf/</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="maxmemory">
            <xsl:value-of select=".//target[@type='pdf']/@heapmemory"/>
          </xsl:attribute>
          <arg>
            <xsl:attribute name="line">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$docid"/>
              <xsl:text>.fo -rtf </xsl:text>
              <xsl:text>${</xsl:text>
              <xsl:value-of select="$docid"/>
              <xsl:text>.rtf.file}</xsl:text>
            </xsl:attribute>
          </arg>
          <classpath refid="lib-fop-classpath"/>
        </java>
      </xsl:when>
      <xsl:otherwise>
        <echo message="RTF 2"/>
        <fop>
          <xsl:attribute name="basedir"><xsl:text>${build.dir}/rtf/</xsl:text></xsl:attribute>
          <xsl:attribute name="fofile">
            <xsl:text>${build.dir}/rtf/</xsl:text>
            <xsl:value-of select="$docid"/>
            <xsl:text>.fo</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="outfile">
            <xsl:text>${build.dir}/rtf/</xsl:text>
              <xsl:text>${</xsl:text>
              <xsl:value-of select="$docid"/>
              <xsl:text>.rtf.file}</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="format"><xsl:text>text/rtf</xsl:text></xsl:attribute>
          <xsl:attribute name="messagelevel"><xsl:text>${fop.message}</xsl:text></xsl:attribute>
          <xsl:attribute name="userconfig"><xsl:text>${basedir}/lib/fop.xconf</xsl:text></xsl:attribute>
        </fop>
      </xsl:otherwise>
    </xsl:choose>
  </target>
</xsl:template>
-->


<!-- =================================================================== -->
<!-- Create alldocs targets                                              -->
<!-- =================================================================== -->

<xsl:template name="alldocs">
  <xsl:param name="ext" select="''"/>
  <xsl:param name="dependsOn" select="''"/>
  <xsl:param name="comment" select="''"/>
  <xsl:param name="additionaltarget" select="''"/>

  <target>
    <xsl:attribute name="name"><xsl:value-of select="$ext"/></xsl:attribute>
    <xsl:attribute name="depends">
      <xsl:if test="$dependsOn!=''">
        <xsl:value-of select="$dependsOn"/>
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:for-each select=".//docinfo">
        <xsl:value-of select="./@id"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="$ext"/>
        <xsl:if test="position()!=last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="$additionaltarget != ''">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$additionaltarget"/>
      </xsl:if>
    </xsl:attribute>
    <xsl:if test="$comment != ''">
      <xsl:attribute name="description">
        <xsl:value-of select="$comment"/>
      </xsl:attribute>
    </xsl:if>
  </target>

</xsl:template>


</xsl:stylesheet>
