#!/bin/bash

set JIRA_USER=${1}
set JIRA_PASSWORD=${2}
set WIKI_USER=${3}
set WIKI_PASSWORD=${4}
set ISSUE_PROJECT=${5}
set ISSUE_FIX_VERSION=${6}
set SPRINT_NUMBER=${7}
set CREATED_AFTER=${8}
set BUILD_VERSION=${9}
set SINCE_VERSION=${10}

cd ../../../
call mvn exec:java -Dexec.mainClass="ReleaseNotesUpdate" -Dexec.args="${JIRA_USER} ${JIRA_PASSWORD} ${WIKI_USER} ${WIKI_PASSWORD} ${ISSUE_PROJECT} ${ISSUE_FIX_VERSION} ${SPRINT_NUMBER} ${CREATED_AFTER} ${BUILD_VERSION} ${SINCE_VERSION}"