#!/bin/bash
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
LOGLEVEL=5

source "${SCRIPT_DIR}/version.sh"

function init() {
    LOGLEVEL_TEXT[0]="Panic"
    LOGLEVEL_TEXT[1]="Fatal"
    LOGLEVEL_TEXT[2]="Error"
    LOGLEVEL_TEXT[3]="Warning"
    LOGLEVEL_TEXT[4]="Info"
    LOGLEVEL_TEXT[5]="Debug"
    LOGLEVEL=4
    RPMBUILD_DIR="$(dirname "${SCRIPT_DIR}")"
    SPECS_DIR="${RPMBUILD_DIR}/SPECS"
    RPMS_DIR="${RPMBUILD_DIR}/RPMS"
    SRPMS_DIR="${RPMBUILD_DIR}/SRPMS"
    BUILD_DIR="${RPMBUILD_DIR}/BUILD"
    SOURCES_DIR="${RPMBUILD_DIR}/SOURCES"

    for DIR in "${SPECS_DIR}" "${RPMS_DIR}" "${SRPMS_DIR}" "${BUILD_DIR}" "${SOURCES_DIR}"; do
        if [ ! -d "${DIR}" ]; then
            echo "$DIR not found. Creating it."
            mkdir -p "${DIR}"
        fi
    done
}

function log() {
    local LEVEL=$1
    if [ ${LEVEL} -le ${LOGLEVEL} ]; then
        shift 1
        local DATE=$(date +"%Y-%m-%d %H:%M:%S")
        printf "%s %s %s\n" "${DATE}" "${LOGLEVEL_TEXT[${LEVEL}]}" "$@"
    fi
}

function get_archive() {
    local URL="$1"
    local APP="$2"
    local VERSION="$3"
    local TARGET_DIR="$4"
    if [ -z "${URL}" ]; then
            echo "get_archive: No URL provided"
            exit 1
    fi
    if [ -z "${APP}" ]; then
            echo "get_archive: No application provided"
            exit 1
    fi
    if [ -z "${VERSION}" ]; then
            echo "get_archive: No version provided"
            exit 1
    fi
    if [ -n "${TARGET_DIR}" ]; then
        cd "${TARGET_DIR}"
    fi
    log 4 "Downloading ${APP}-${VERSION}.tar.gz into ${TARGET_DIR}"
    curl -sSkjL "${URL}" -o "${APP}-${VERSION}.tar.gz"
    RESULT=$?
    local SIZE=$(cat "${APP}-${VERSION}.tar.gz"|wc -c)
    if [ $SIZE -le 512 ]; then
        # 112 is the size of a tar.gz with an empty file in it, the average bitbucket error is around 150 bytes
        log 2 "Download of ${APP}-${VERSION}.tar.gz failed or is damaged: File too small."
        exit 1
    fi
    return ${RESULT}
}

function build() {
    local APP="$1"
    local VERSION="$2"
    local RELEASE="$3"
    local ARCH="$4"

    cp "${SCRIPT_DIR}/${APP}.spec" "${SPECS_DIR}/"
    cd "${RPMBUILD_DIR}"
    log 4 "Building ${APP} ${VERSION}-${RELEASE}"
    rpmbuild --define="_topdir ${RPMBUILD_DIR}" \
             --define="version ${VERSION}" \
             --define="release ${RELEASE}" \
             --define="app ${APP}" \
             --define="arch ${ARCH}" \
             -ba "${SPECS_DIR}/${APP}.spec"
    local RESULT=$?
    if [ ${RESULT} -ne 0 ]; then
        log 2 "Building the RPM failed"
        return ${RESULT}
    fi
    log 4 "${APP} RPM built successfully"
    return 0
}

init
get_archive "${URL}" "${APP}" "${VERSION}" "${SOURCES_DIR}"
if [ $? -ne 0 ]; then
    exit 1
fi
build "${APP}" "${VERSION}" "${RELEASE}" "${ARCH}"
exit $?
