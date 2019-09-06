#!/usr/bin/env bash

set -euxo pipefail

if [[ "$TRAVIS_OS_NAME" == "windows" ]]; then
	git clone --depth=1 https://github.com/Microsoft/vcpkg.git "$VCPKG_ROOT"
	cd "$VCPKG_ROOT"
	curl --retry 5 --connect-timeout 30 --location --remote-header-name --output installed.zip "$VCPKG_CACHE_ZIP_URL"
	unzip -uo installed.zip
	powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '.\bootstrap-vcpkg.bat'"
	./vcpkg.exe integrate install;
	./vcpkg.exe install $VCPKG_LIBS
else
	cd /tmp
	curl --retry 5 --connect-timeout 30 --location --remote-header-name --remote-name https://www.lua.org/ftp/lua-5.3.5.tar.gz
	tar xf lua-5.3.5.tar.gz
	cd lua-5.3.5
	if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
	  make -j2 macosx CC=$CXX
	else
	  make -j2 linux CC=$CXX MYCFLAGS=-fPIC
	fi
	sudo make install
fi