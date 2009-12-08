#!/bin/sh

if [ "$NISP_HOME" = "" ] ; then
  NISP_HOME=`pwd`
fi

chmod u+x $NISP_HOME/bin/antRun
chmod u+x $NISP_HOME/bin/ant


export CP=$CLASSPATH
unset CLASSPATH

cd "$NISP_HOME"

ANT_HOME=$NISP_HOME

LIBPATH="$NISP_HOME/lib/xml-apis-1.3.03.jar:$NISP_HOME/lib/xercesImpl-2.8.1.jar:$NISP_HOME/lib/resolver-1.1.jar"
#LIBPATH="$NISP_HOME/lib/xml-apis.jar:$NISP_HOME/lib/xercesImpl-cvs-20041102.jar"

"$NISP_HOME"/bin/ant -lib $LIBPATH   -logger org.apache.tools.ant.NoBannerLogger -emacs $@ 

export CLASSPATH=$CP
