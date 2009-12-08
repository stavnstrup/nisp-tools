<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" encoding="UTF-8" indent="yes"/>
  <xsl:preserve-space elements="*"/>

  <!--
    Author: Charbel BITAR
    Version: 1.0.0
    Date: 2003-10-01
    License: GPL (c) Charbel BITAR, 2003-08-01
    Compatibility: Internet Explorer on Microsoft Windows (Use of Windows Script) and all Ant versions.
    Usage: Just add in the buildfile, the reference to this stylesheet:
           <?xml-stylesheet type="text/xsl" href="antprettybuild.xsl"?>
           and preview it inside the browser.
           To build Ant projects directly from your browser, the following environment variables
           may be modified to match the local paths (set them to nothing if your system is ready to run Ant).
           For more information please visit http://antprettybuild.free.fr
  -->

  <!--           -->
  <!-- Variables -->
  <!--           -->

  <!-- Environment Variables -->
  <xsl:variable name="JAVA_HOME">C:/Program Files/Java/j2sdk1.4.2</xsl:variable>
  <xsl:variable name="ANT_HOME">C:/Program Files/Apache Group/Ant</xsl:variable>
  <xsl:variable name="PATH">%PATH%;C:/Program Files/Apache Group/Ant/bin</xsl:variable>

  <!--           -->
  <!-- Templates -->
  <!--           -->

  <!-- / -->
  <xsl:template match="/">
    <html>
      <xsl:call-template name="head"/>
      <xsl:call-template name="body"/>
    </html>
  </xsl:template>

  <!-- head -->
  <xsl:template name="head">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <title>Ant Pretty Build</title>
    </head>
  </xsl:template>

  <!-- body -->
  <xsl:template name="body">
    <body bgcolor="#003366" text="#ffffff">
      <script language="javascript">
        var targetlist = '';
        var targetorder = 0;
        function checkornot(targetbox) {
          var targetbutton = document.getElementById(targetbox.name + 'button');
          if (targetbox.checked) {
            targetlist += ' ' + targetbox.name;
            targetorder++;
            targetbutton.value = targetorder;
          }
          else {
            var pattern = ' ' + targetbox.name;
            var reg = new RegExp(pattern,'g');
            targetlist = targetlist.replace(reg,'');
            for (var i=0;i&lt;document.targetform.elements.length;i++) {
              var e = document.targetform.elements[i];
              if ((e.type=='button') &amp;&amp; (e.value&gt;targetbutton.value)) {
                e.value--;
              }
            }
            targetorder--;
            targetbutton.value = '';
          }
        }
        function runant(java_home,ant_home,path,targetlist) {
          // environment variables
          var setenvvars = '';
          var slash = new RegExp('(/)','g');
          if (java_home!='') setenvvars += '&amp;' + 'set JAVA_HOME=' + java_home.replace(slash,'\\');
          if (ant_home!='') setenvvars += '&amp;' + 'set ANT_HOME=' + ant_home.replace(slash,'\\');
          if (path!='') setenvvars += '&amp;' + 'set PATH=' + path.replace(slash,'\\');
          // buildfile
          var fileurl = (window.location.pathname).substring(1);
          var buildfile = fileurl.replace(new RegExp('(%20)','g'),' ');
          if (buildfile!='') buildfile = '\"' + buildfile + '\"';
          // builddir
          var builddir = buildfile.substring(1,buildfile.lastIndexOf('\\'));
          if (builddir!='') builddir = '\"' + builddir + '\"';
          // runmode
          var runmode = document.runform.modeselect.value;
          if (runmode!='') runmode = '-' + runmode;
          // logger
          var logger = document.runform.loggerselect.value;
          if (logger=='') logger = 'org.apache.tools.ant.DefaultLogger';
          if (logger=='xmllogger') logger = 'org.apache.tools.ant.XmlLogger' + ' -D' + 'ant.XmlLogger.stylesheet.uri=' + '\"' + ant_home + '\\etc\\log.xsl' + '\"';
          logger = '-logger ' + logger;
          // logfile
          var logfile = document.runform.logfileinput.value;
          if (logfile!='') logfile = '-logfile ' + '\"' + logfile + '\"';
          // propertyline
          var propertyline = '';
          for (var i=0;i&lt;document.propertyform.elements.length;i++) {
            var e = document.propertyform.elements[i];
            if ((e.type=='text') &amp;&amp; (e.name.indexOf('propertyname')!=-1) &amp;&amp; (e.value!='')) {
              var pname = e.value;
              var pvalue = document.getElementById('propertyvalue' + e.name.substring(12)).value;
              propertyline += ' -D' + pname + '=' + pvalue;
            }
          }
          // keep or close when done
          var korc = '/c';
          if (!document.runform.closewhendone.checked) korc = '/k';
          // more commandline options
          var more = document.runform.more.value;
          // commandline
          var commandline = 'cd ' + builddir + setenvvars
                + '&amp;' + 'ant' + ' ' + '-buildfile' + ' ' + buildfile + ' ' + targetlist + ' ' + runmode + ' ' + logger + ' ' + logfile + ' ' + propertyline + ' ' + more;
          // WshShell
          var WshShell = new ActiveXObject("WScript.Shell");
          WshShell.Run("%comspec%" + ' ' + korc + ' ' + commandline);
          WshShell.Quit;
        }
      </script>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse; text-align: center">
        <tr>
          <td width="20%"><!-- ASCII Art by Conor MacNeill --><pre>\_/<br/>\(_)/<br/>-(_)-<br/>/(_)\</pre></td>
          <td width="60%"><h1>Ant Pretty Build</h1><h5>&#169; 2003 <a href="mailto:antprettybuild@free.fr" style="color: white; text-decoration: none">Charbel BITAR</a>. All rights reserved.</h5></td>
          <td width="20%"><!-- ASCII Art by Conor MacNeill --><pre>\_/<br/>\(_)/<br/>-(_)-<br/>/(_)\</pre></td>
        </tr>
        <tr>
          <td width="20%"><hr/></td>
          <td width="60%"><hr/></td>
          <td width="20%"><hr/></td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%">&#160;</td>
          <td width="20%">&#160;</td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%"><xsl:call-template name="projects"/></td>
          <td width="20%">&#160;</td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%">&#160;</td>
          <td width="20%">&#160;</td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%"><xsl:call-template name="properties"/></td>
          <td width="20%">&#160;</td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%">&#160;</td>
          <td width="20%">&#160;</td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%"><xsl:call-template name="targets"/></td>
          <td width="20%">&#160;</td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%">&#160;</td>
          <td width="20%">&#160;</td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%"><xsl:call-template name="runant"/></td>
          <td width="20%">&#160;</td>
        </tr>
        <tr>
          <td width="20%">&#160;</td>
          <td width="60%">&#160;</td>
          <td width="20%">&#160;</td>
        </tr>
        <!-- Touch me here -->
        <tr>
          <td width="20%"><hr/></td>
          <td width="60%"><hr/></td>
          <td width="20%"><hr/></td>
        </tr>
      </table>
    </body>
  </xsl:template>

  <!-- projects -->
  <xsl:template name="projects">
    <xsl:apply-templates select="project" mode="project"/>
  </xsl:template>

  <!-- properties -->
  <xsl:template name="properties">
    <p>
      <b>Properties:</b>
    </p>
    <p>
      <form name="propertyform">
        <table id="propertytable" name="propertytable" border="1" cellspacing="0" bgcolor="#003366">
          <tr style="padding:3px;" bgcolor="#336699">
            <th align="center" style="padding:3px;" nowrap="true">Property</th>
            <th align="center" style="padding:3px;" nowrap="true">Value</th>
            <th align="center" style="padding:3px;" nowrap="true">&#160;</th>
          </tr>
          <xsl:if test="project/property">
            <xsl:apply-templates select="project/property" mode="property"/>
          </xsl:if>
          <xsl:if test="project/target/property">
            <xsl:apply-templates select="project/target/property" mode="property"/>
          </xsl:if>
          <tr>
            <td><input type="text" name="propertyname1" size="10" style="border: 0px; background-color: #003366; color: #ffffff; font-weight: bold" value=""/></td>
            <td><input type="text" name="propertyvalue1" size="10" style="border: 0px; background-color: #003366; color: #ffffff" value=""/></td>
            <td>&#160;</td>
          </tr>
          <tr>
            <td><input type="text" name="propertyname2" size="10" style="border: 0px; background-color: #003366; color: #ffffff; font-weight: bold" value=""/></td>
            <td><input type="text" name="propertyvalue2" size="10" style="border: 0px; background-color: #003366; color: #ffffff" value=""/></td>
            <td>&#160;</td>
          </tr>
          <tr>
            <td><input type="text" name="propertyname3" size="10" style="border: 0px; background-color: #003366; color: #ffffff; font-weight: bold" value=""/></td>
            <td><input type="text" name="propertyvalue3" size="10" style="border: 0px; background-color: #003366; color: #ffffff" value=""/></td>
            <td>&#160;</td>
          </tr>
          <!-- more properties here -->
        </table>
      </form>
    </p>
  </xsl:template>

  <!-- targets -->
  <xsl:template name="targets">
    <p>
      <b>Project Targets:</b>
    </p>
    <p>
      <form name="targetform">
        <table id="targettable" name="targettable" border="1" cellspacing="0" bgcolor="#003366">
          <tr style="padding:3px;" bgcolor="#336699">
            <th align="center" nowrap="true">&#160;&#160;&#160;&#160;</th>
            <th align="center" nowrap="true">&#160;&#160;&#160;&#160;</th>
            <th align="center" style="padding:3px;" nowrap="true">Target</th>
            <th align="center" style="padding:3px;" nowrap="true">Description</th>
          </tr>
          <xsl:apply-templates select="project/target" mode="target"/>
        </table>
      </form>
    </p>
  </xsl:template>

  <!-- runant -->
  <xsl:template name="runant">
    <p>
      <form name="runform">
        <table name="runtable" id="runtable">
          <tr>
            <td><b>Logger:&#160;</b></td>
            <td>
              <select name="loggerselect">
                <option value="" selected="true">Default</option>
                <option value="xmllogger">XmlLogger</option>
              </select>
            </td>
          </tr>
          <tr>
            <td><b>Log&#160;File:&#160;</b></td>
            <td>
              <input name="logfileinput" type="text" size="10" value=""/>
              &#160;
              <input name="logfileview" type="button" value="?" onclick="javascript:window.open(document.runform.logfileinput.value,'logfilewin','toolbar=no,menubar=no,location=no,status=no,directories=no,resizable=yes,scrollbars=yes')"/>
            </td>
          </tr>
          <tr>
            <td><b>More:&#160;</b></td>
            <td><input type="text" name="more" size="30" value=""/></td>
          </tr>
          <tr>
            <td><b>Mode:&#160;</b></td>
            <td>
              <select name="modeselect">
                <option value="" selected="true">Default</option>
                <option value="quiet">Quiet</option>
                <option value="verbose">Verbose</option>
                <option value="debug">Debug</option>
              </select>
              &#160;
              <input name="runantbutton" type="button" value="Run" onclick="javascript:runant('{$JAVA_HOME}','{$ANT_HOME}','{$PATH}',targetlist)"/>
            </td>
          </tr>
          <tr>
            <td colspan="2"><input type="checkbox" name="closewhendone" checked="true"/>Close when done</td>
          </tr>
        </table>
      </form>
    </p>
  </xsl:template>

  <!--                -->
  <!-- Build elements -->
  <!--                -->

  <!-- project -->
  <xsl:template name="project" match="project" mode="project">
    <p>
      <b>Project Name:&#160;</b><xsl:value-of select="@name"/>
    </p>
    <xsl:if test="description">
      <p>
        <b>Project Description:&#160;</b><xsl:apply-templates select="description"/>
      </p>
    </xsl:if>
    <xsl:if test="@basedir">
      <p>
        <b>Basedir:&#160;</b><xsl:value-of select="@basedir"/>
      </p>
    </xsl:if>
    <p>
      <b>Default target:&#160;</b><xsl:value-of select="@default"/>
    </p>
  </xsl:template>

  <!-- property -->
  <xsl:template name="property" match="project//property" mode="property">
    <xsl:choose>
      <xsl:when test="@name">
        <tr>
          <td align="center" style="padding:3px;" nowrap="true"><b><xsl:value-of select="@name"/></b></td>
          <td align="left" style="padding:3px;" nowrap="true">
            <xsl:if test="@value">
              <xsl:value-of select="@value"/>
            </xsl:if>
            <xsl:if test="@location">
              <xsl:value-of select="@location"/>
            </xsl:if>
            <xsl:if test="@refid">
              <xsl:value-of select="@refid"/>
            </xsl:if>
          </td>
          <td>&#160;</td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="@resource">
          <tr>
            <td align="center" style="padding:3px;" nowrap="true"><font color="#ffffcc"><b>resource</b></font></td>
            <td align="left" style="padding:3px;" nowrap="true"><xsl:value-of select="@resource"/></td>
            <td align="left" style="padding:3px;" nowrap="true"><input name="resourceview" type="button" value="?" onclick="javascript:window.open('{@resource}')"/></td>
          </tr>
        </xsl:if>
        <xsl:if test="@file">
          <tr>
            <td align="center" style="padding:3px;" nowrap="true"><font color="#ffffcc"><b>file</b></font></td>
            <td align="left" style="padding:3px;" nowrap="true"><xsl:value-of select="@file"/></td>
            <td align="left" style="padding:3px;" nowrap="true"><input name="fileview" type="button" value="?" onclick="javascript:window.open('{@file}')"/></td>
          </tr>
        </xsl:if>
        <xsl:if test="@environment">
          <tr>
            <td align="center" style="padding:3px;" nowrap="true"><font color="#ffffcc"><b>environment</b></font></td>
            <td align="left" style="padding:3px;" nowrap="true"><xsl:value-of select="@environment"/></td>
            <td>&#160;</td>
          </tr>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@classpath">
      <tr>
        <td align="center" style="padding:3px;" nowrap="true"><font color="#ffffcc"><b>classpath</b></font></td>
        <td align="left" style="padding:3px;" nowrap="true"><xsl:value-of select="@classpath"/></td>
        <td>&#160;</td>
      </tr>
    </xsl:if>
    <xsl:if test="@classpathref">
      <tr>
        <td align="center" style="padding:3px;" nowrap="true"><font color="#ffffcc"><b>classpathref</b></font></td>
        <td align="left" style="padding:3px;" nowrap="true"><xsl:value-of select="@classpathref"/></td>
        <td>&#160;</td>
      </tr>
    </xsl:if>
    <xsl:if test="@prefix">
      <tr>
        <td align="center" style="padding:3px;" nowrap="true"><font color="#ffffcc"><b>prefix</b></font></td>
        <td align="left" style="padding:3px;" nowrap="true"><xsl:value-of select="@prefix"/></td>
        <td>&#160;</td>
      </tr>
    </xsl:if>
  </xsl:template>

  <!-- target -->
  <xsl:template name="target" match="project/target" mode="target">
    <tr>
      <td align="center"><input type="checkbox" name="{@name}" title="{@depends}" onclick="javascript:checkornot(this)"/></td>
      <td align="center"><input type="button" name="{@name}button" onclick="javascript:runant('{$JAVA_HOME}','{$ANT_HOME}','{$PATH}','{@name}')"/></td>
      <td align="center" style="padding:3px;" nowrap="true">
        <xsl:choose>
          <xsl:when test="@name=./../@default">
            <font color="#ff0000"><b><xsl:value-of select="@name"/></b></font>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="@description and @description!=''">
                <font color="#ffffcc"><b><xsl:value-of select="@name"/></b></font>
              </xsl:when>
              <xsl:otherwise>
                <font color="#ffffff"><b><xsl:value-of select="@name"/></b></font>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:choose>
        <xsl:when test="@description and @description!=''">
          <td align="left" style="padding:3px;" nowrap="true"><xsl:value-of select="@description"/></td>
        </xsl:when>
        <xsl:otherwise>
          <td align="left" style="padding:3px;" nowrap="true">&#160;</td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
  </xsl:template>

</xsl:stylesheet>