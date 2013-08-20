% nisp-install
% Jens Stavnstrup \<stavnstrup@mil.dk\>
% December 19, 2009


Name
====

nisp-install - Installation of NISP tools and sources


Description
===========

Working with DocBook XML files, requires quite a bit of
software. However, the number of packages necessary, depends on the
requirements of the user. To simplify things, most of the tools have
been bundled in the nisp-tools package. In order e.g. to generate a
HTML version of the NISP, the users only have to install Java, the
nisp tools distribution and the sources for the XML version of the
NISP.
<!--
A detailed description of all the different tools
included in this package can be found in the [NISP software](nisp-software.html) manual.
-->

All software packages can in principle be installed anywhere, but
everything should work without a glitch, if some of the packages are
installed in a couple of predefined places.

<!-- ASCIIDOC Sidebar
.File paths in archives
*********************************************************************
The user should be aware, that some distributions are archived
inside a sub directory, and some are not., e.g. the NISP tools
distribution is unpacked into the sub directory
nisp-tools-{nisptools}, where all the files in the NISP tools
distribution are located. It is up to the user to ensure this issue is
resolved properly. So if the installation instructions recommends that
the NISP package should be installed under Windows in the directory
`c:\nisp-tools`, the path to the
`README` file from the NISP tools distribution,
should be the file `c:\nisp-tools\README` and
not the file path `c:\nisp-tools\nisp-tools-{nispversion};\README`.
**********************************************************************
-->

Installation of Java
--------------------

The installation of the Java is straight forward. The Java 2 Software
Development Kit or the Java 2 Run-time environment comes as an
archived executable, and is by default installed under windows at
`c:\jdk1.6`. If the user prefers to use another version of
java, please consult the installation instruction of the programs
Xerces, Saxon, Batik, Fop, Sun catalog resolver and Ant to identify
the system requirements for these tools.


The user *must* always add the directory,
where Java executable are located to the `PATH`
environment variable. Typical values for `PATH`
are:


*Java 2 Software Development Kit*

~~~
   c:\jdk1.6\bin            (Win32)

   /usr/java/jdk1.6/bin     (Unix)
~~~



*Java 2 Runtime Environment*

~~~

   c:\Program Files\JavaSoft\JRE\1.6\bin     (Win32)

   /usr/java/jdk1.6/bin                      (Unix)
~~~



The user should also set the environment variable
`JAVA_HOME`. Although normally not required by Java 1.6, the
Ant program requires this variable set for reasons of backward
compatibility. Typical values for `JAVA_HOME` are:



*Java 2 Software Development Kit*

~~~
   c:\jdk1.6            (Win32)

   /usr/java/jdk1.6     (Unix)
~~~



*Java 2 Runtime Environment*

~~~
   c:\Program Files\JavaSoft\JRE\1.6     (Win32)

   /usr/java/jdk1.6                      (Unix)
~~~


Installation of the NISP tools and sources
------------------------------------------

Today the NISP tool and the sources are stored in a subversion from where it can be installed on the users machine using the command

~~~
svn checkout http://tide.act.nato.int/svn/nisp/trunk/nisp-tools
~~~

or you can check a copy of the repository using a graphical subversion client.


### Manual installation of the tools and sources

Originaly the NISP sources and the tools used to transform the sources
from DocBook to HTML5 and PDF were distributed in two separate
packages. Whenever we release an official version, we save a copy of
the both the tool package and the source, so installation can be done
offline.

The NISP tools packege coms as a zip file and can be unpacked anywhere on your machine.

The user should set the environment variable `NISP_HOME` to the
directory, where the NISP tools package, was installed. Typical values
for `NISP_HOME` are:

~~~
   c:\nisp-tools-6.0            (Win32)

   ~/nisp-tools-6.0/            (Unix)
~~~


The NISP XML sources `nisp-src-X.Y.zip` *must* be unpacked
in the empty src directory in the tools distribution.



<!--
.Using a generic root name
****************************************************************************************
Since the NISP tool package may be released frequently, the
user could rename the tools directory to e.g. `c:\nisp-tools`, and of course set the
`NISP_HOME` environment variable accordingly.
****************************************************************************************
-->

Installation of the HTMLHELP compiler
-------------------------------------

The current web version of the NISP also comes with a HTML Help
version.  This requires installation of the Microsoft's HTML Help
compiler, which due to license restrictions can not be included in the
NISP tools package. The user is required to download this distribution
from the Microsoft's website. Search for "html help downloads".

A configuration file with default user definable properties is located in the root
of the tools distribution contains the property `hcc`, which must point
to the location of the HTML Help Compiler. See here

When you use the default installation using the file "htmlhelp.exe"
distributed by Microsoft, the HTML Help Workshop will be installed in
`C:\Program Files\HTML Help Workshop`. The HTML Help Workshop also
includes the HTML Help Compiler. The default setting of the property
`hcc` in the file "user.properties" therefore is:

~~~
hcc = C:\\Program Files\\HTML Help Workshop\\hhc.exe
~~~


Change the value of this parameter, if your version of the HTML Help
Compiler is located in a different directory.

Please note that the file `hcc.exe` itself is not sufficient to be able
to compile a HTML Help project. At least the following three files,
which are included in the Microsoft distribution of the HTML Help
Workshop, are required to be able to compile a HTML Help project:


* *hhc.exe* - Default this file is installed in `C:\Program Files\HTML Help Workshop`.
* *itcc.dll* - Default this file is installed in `C:\Program Files\HTML Help Workshop`.
* *hha.dll* - Default this file is installed in `C:\Windows\System32` (on WindowsXP).


If you do not have sufficient privileges to install the HTML Help
Workshop, you can copy these files to the same folder, e.g.
`D:\Tools\NISP\HTMLHelp` and change the `hcc` property in the file
"user.properties" to e.g. `hcc=D:\\Tools\\NISP\\HTMLHelp`. Now it is
possible to invoke the HTML Help compiler and generate the ".chm"-file.


~~~
hcc=D:\\Tools\\NISP\\HTMLHelp
~~~


This approach has one problem: the index will not be generated
correctly. You must register the file `itcc.dll` to be able to generate
a correct index as well. If you have sufficient privileges, you can
perform this action using the command:

~~~
    regsvr32 itcc.dll
~~~


User defined configuration
--------------------------

A configuration file with default values for the build process is
located in the root folder with the name "user.properties". Since this
file might be updated whenever the user syncronizes with the
subversion repository, this file should never been modified. Instead
the user should make a copy of this file and call it
"local.user.properties" and edit the appropiate properties.








