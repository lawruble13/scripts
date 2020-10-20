#!/bin/bash

VERSION_FORMAT="v[0-9\.]*"
VERSION_PATTERN='\s*"tag_name":\s*"%v",'
VERSION_COMMAND='curl -s'
VERSION_URL="https://api.github.com/repos/lawruble13/drumbleat/releases/latest"

STORED_ARCHIVE_PATTERN="drumbleat-windows-%v.zip"
ARCHIVE_FOLDER="Zips"

DOWNLOAD_URL="https://github.com/lawruble13/drumbleat/releases/download/%v/drumbleat_windows.zip"
DOWNLOAD_COMMAND="curl --create-dirs"

EXTRACT_COMMAND="unzip"
EXTRACT_LOC_FLAG="-d"
MOVE_ALL_UNDER="drumbleat_windows"

EXEC_FOLDER="Executable"
EXEC_FORMAT="drumbleat.exe"


