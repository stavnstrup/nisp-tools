Generate the missing standards by knocking-off EM-Wiki among other things
=========================================================================

* Edit missing-amn.specification.xml, whic contains the list of standards, which should be fetched

* Generate getRDF.sh by running

~~~
      saxon91 missing-amn-specification.xml makeFetchScript.xsl
~~~

* To fetch the RDF files, run

~~~
      sh getRDF.sh
~~~

* To  generate the standard elements, which can be inserted into the standardsdatabase run

~~~
      saxon91 -o ../missing-amn.xml missing-amn-specification.xml createDBentries.xsl
~~~


 
