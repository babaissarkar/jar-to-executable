#!/bin/bash -xe

set -euo pipefail

if [[ -z "${JAVA_HOME:-}" ]]; then
  JAVA_BIN=$(command -v java) || {
    echo "Error: Java not found. Please install JDK or set JAVA_HOME." >&2
    exit 1
  }
  JAVA_HOME=$(dirname "$(dirname "$JAVA_BIN")")
  echo "Detected JAVA_HOME: $JAVA_HOME"
fi

PROGRAM=${PROGRAM:?PROGRAM must be set (e.g. PROGRAM=wml ./build.sh)}
PROGRAM_NAME=${PROGRAM_NAME:-$PROGRAM}
JAR_DIR=${JAR_DIR:-jar}
INPUT=${INPUT:-${JAR_DIR}/${PROGRAM}.jar}
OUTPUT=${OUTPUT:-${PROGRAM_NAME}.AppImage}
PROGRAM_ICON=${PROGRAM_ICON:-${PROGRAM}.png}
PROGRAM_DESKTOP_FILE=${PROGRAM_DESKTOP_FILE:-${PROGRAM}.desktop}
MODULES=$(jdeps --ignore-missing-deps --multi-release 17 --print-module-deps "${INPUT}")
APPIMAGE_DOWNLOAD_URL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
APPRUN_DOWNLOAD_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/AppRun-x86_64"
APPIMAGETOOL="/tmp/appimagetool-x86_64.AppImage"

run_jlink() {
	jlink \
	--module-path "$JAVA_HOME/jmods" \
	--add-modules ${MODULES} \
	--output ${PROGRAM_NAME}.AppDir/usr \
	--strip-debug \
	--no-header-files \
	--no-man-pages
}

# Run jlink to create runtime
run_jlink

# download AppRun
wget -nc --verbose -O AppRun ${APPRUN_DOWNLOAD_URL}

# create directory structure
mkdir -p ${PROGRAM_NAME}.AppDir/usr/share/${PROGRAM}
cp ${INPUT} ${PROGRAM_NAME}.AppDir/usr/share/${PROGRAM}/
cp ${PROGRAM} ${PROGRAM_NAME}.AppDir/usr/bin/
cp AppRun ${PROGRAM_NAME}.AppDir/
cp ${PROGRAM_ICON} ${PROGRAM_NAME}.AppDir/
cp ${PROGRAM_DESKTOP_FILE} ${PROGRAM_NAME}.AppDir/

# download appimagetool
pwd && ls -lh
wget -nc --verbose -O ${APPIMAGETOOL} ${APPIMAGE_DOWNLOAD_URL}
file ${APPIMAGETOOL}
pwd && ls -lh /tmp
chmod +x ${APPIMAGETOOL}
${APPIMAGETOOL} --appimage-extract

# run appimagetool
ARCH=x86_64 squashfs-root/AppRun "${PROGRAM_NAME}.AppDir" ${OUTPUT}

echo "AppImage created successfully! Path: ${OUTPUT}"
