#!/bin/bash
if [ -z "${ECLIPSE_HOME}" ]; then
	echo "Please set ECLIPSE_HOME environment variable to your eclipse installation."
	exit 1;
fi
if [ -z "${1}" ]; then
	echo "Usage: $(basename ${0}) <targetdir>"
        echo "Will clone relevant p2 repositories into subfolders beneath <targetdir>".
	exit 1;
fi

TARGET_DIR="${1}"

if [ ! -d "${TARGET_DIR}" ]; then
	echo "Target dir does not exist. Please create it first!"
	exit 1;
fi

INDIGO_DIR="${TARGET_DIR}/p2repo.indigo"
ORBIT_DIR="${TARGET_DIR}/p2repo.orbit"

[ ! -d "${INDIGO_DIR}" ] && mkdir "${INDIGO_DIR}"
[ ! -d "${ORBIT_DIR}"  ] && mkdir "${ORBIT_DIR}"

echo -n "Beginnig download. This might take a few moments..."
#"${ECLIPSE_HOME}/eclipse" -nosplash -verbose -application org.eclipse.equinox.p2.artifact.repository.mirrorApplication -writeMode clean -source http://download.eclipse.org/releases/indigo -destination "file:${INDIGO_DIR}"
"${ECLIPSE_HOME}/eclipse" -nosplash -verbose -application org.eclipse.equinox.p2.metadata.repository.mirrorApplication -writeMode clean -source http://download.eclipse.org/releases/indigo -destination "file:${INDIGO_DIR}"
#"${ECLIPSE_HOME}/eclipse" -nosplash -verbose -application org.eclipse.equinox.p2.artifact.repository.mirrorApplication -writeMode clean -source http://download.eclipse.org/tools/orbit/downloads/drops/R20120119162704/repository -destination "file:${ORBIT_DIR}"
"${ECLIPSE_HOME}/eclipse" -nosplash -verbose -application org.eclipse.equinox.p2.metadata.repository.mirrorApplication -writeMode clean -source http://download.eclipse.org/tools/orbit/downloads/drops/R20120119162704/repository -destination "file:${ORBIT_DIR}"
echo " done."

cat <<-ENDOFSNIPPET

Put the following snippet into your user's Maven settings.xml,
usually located at   "~/.m2"

--8<--snip--8<--8<--
  <mirror>
    <id>local-indigo</id>
    <mirrorOf>eclipse-indigo</mirrorOf>
    <name>Local Mirror of Eclipse Indigo p2 repository.</name>
    <url>file:/Users/ds/Java/jbehave/p2mirror/p2repo.indigo</url>
    <layout>p2</layout>
    <mirrorOfLayouts>p2</mirrorOfLayouts>
  </mirror>

  <mirror>
    <id>local-orbit</id>
    <mirrorOf>eclipse-orbit</mirrorOf>
    <name>Local Mirror of Eclipse Orbit repository.</name>
    <url>file:/Users/ds/Java/jbehave/p2mirror/p2repo.orbit</url>
    <layout>p2</layout>
    <mirrorOfLayouts>p2</mirrorOfLayouts>
  </mirror>
-->8--snap-->8-->8--

ENDOFSNIPPET


