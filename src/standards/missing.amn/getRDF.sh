#!/bin/sh
username='stavnstrup'
password=$1
if $1 == ''
then
  echo "Error: Password missing"
  echo ""
  exit 2
fi
wget -c -O RFC_0950.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_0950
wget -c -O RFC_1997.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_1997
wget -c -O RFC_3618.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_3618
wget -c -O RFC_4601.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_4601
wget -c -O RFC_3411.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_3411
wget -c -O RFC_3412.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_3412
wget -c -O RFC_3413.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_3413
wget -c -O RFC_3414.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_3414
wget -c -O RFC_3415.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_3415
wget -c -O RFC_6120.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_6120
wget -c -O RFC_6121.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_6121
wget -c -O REC-ws-policy-attach-20070904.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/W3C_Recommendation_-_Web_Services_Policy_1.5_-_Attachment
wget -c -O NOTE-ws-policy-guidelines-20071112.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/W3C_Recommendation_-_Web_Services_Policy_1.5_-_Guidelines_for_Policy_Assertion_Authors
wget -c -O NOTE-ws-policy-primer-20071112.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/W3C_Recommendation_-_Web_Services_Policy_1.5_-_Primer
wget -c -O RFC_2396.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/RFC_2396
wget -c -O REC-ws-addr-core-20060509.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/W3C_Recommendation_-_Web_Services_Addressing_1.0_-_Core
wget -c -O REC-ws-addr-metadata-20070904.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/W3C_Recommendation_-_Web_Services_Addressing_1.0_-_Metadata
wget -c -O REC-ws-addr-soap-20060509.rdf --user=$username --password=$password http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/W3C_Recommendation_-_Web_Services_Addressing_1.0_-_SOAP_Binding


OGC ,  v.1.1


  


ANSI/NIST ITL 1-2007 Part 1
We do have ANSI/NIST-ITL Data Format for the Interchange of Fingerprint, Facial, and Scar Mark and Tattoo (SMT) Information from 2008


  