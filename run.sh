#!/bin/sh

#user_configuration

#: About AIR application packaging
#: http://livedocs.adobe.com/flex/3/html/help.html?content=CommandLineTools_5.html#1035959
#: http://livedocs.adobe.com/flex/3/html/distributing_apps_4.html#1037515

#: NOTICE: all paths are relative to project root

#: Your certificate information
CERT_NAME="RapidTweet"
CERT_PASS=fd
CERT_FILE="bat\RapidTweet.p12"
#SIGNING_OPTIONS=-storetype pkcs12 -keystore %CERT_FILE% -storepass %CERT_PASS%

#:: Application descriptor
APP_XML=application.xml

#:: Files to package
APP_DIR=bin
#FILE_OR_DIR=-C %APP_DIR% .

#:: Your application ID (must match <id> of Application descriptor)
APP_ID=RapidTweet

#:: Output
AIR_PATH=air
AIR_NAME=RapidTweet


#:validation
#find /C "<id>%APP_ID%</id>" "%APP_XML%" > NUL
#if errorlevel 1 goto badid
#goto end

#:badid
#echo.
#echo ERROR: 
#echo   Application ID in 'bat\SetupApplication.bat' (APP_ID) 
#echo   does NOT match Application descriptor '%APP_XML%' (id)
#echo.
#if %PAUSE_ERRORS%==1 pause
#exit

#:end
adl "$APP_XML" "$APP_DIR" -nodebug
