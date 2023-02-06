# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)
REVISION:=$(shell curl -s -S https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media)
.PHONY: all

all:  clean init
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/proxy
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/chromium

	$(PWD)/bin/Apprepo.AppImage --destination=$(PWD)/build appdir boilerplate \
	    libgdk-pixbuf2.0-0 libatk1.0-0 libatk-bridge2.0-0 libgtk2.0-0 libbotan-2-12 \
	    libreadline8 at-spi2-core libpango-1.0-0 libselinux1 zlib1g \
	    libgtk-3-0 libwayland-cursor0

	echo ''                                                                                     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${APPDIR}/chromium'                              >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${APPDIR}/proxy'                                 >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}'                                           >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '$${APPDIR}/proxy/tor &'                                                               >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''                                                                                     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '$${APPDIR}/chromium/chrome --proxy-server="socks://127.0.0.1:9050" --profile-directory=Thorium $${@}' \
		>> $(PWD)/build/Boilerplate.AppDir/AppRun

	echo ''                                                                                     >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'pkill -P $$$$'                                                                          >> $(PWD)/build/Boilerplate.AppDir/AppRun

	wget --output-document=${PWD}/build/build.zip  https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$(REVISION)%2Fchrome-linux.zip?alt=media
	unzip $(PWD)/build/build.zip -d $(PWD)/build

	wget --output-document=$(PWD)/build/build.tar.xz  https://dist.torproject.org/torbrowser/12.0.2/tor-browser-linux64-12.0.2_ALL.tar.xz
	tar -xJvf $(PWD)/build/build.tar.xz -C $(PWD)/build
	
	cp --force --recursive $(PWD)/build/tor-browser*/Browser/abicheck           $(PWD)/build/Boilerplate.AppDir/proxy
	cp --force --recursive $(PWD)/build/tor-browser*/Browser/TorBrowser/Tor/*   $(PWD)/build/Boilerplate.AppDir/proxy
	cp --force --recursive $(PWD)/build/chrome-*/*                              $(PWD)/build/Boilerplate.AppDir/chromium

	rm -f $(PWD)/build/Boilerplate.AppDir/*.desktop 		     || true
	rm -f $(PWD)/build/Boilerplate.AppDir/*.png 		  	     || true
	rm -f $(PWD)/build/Boilerplate.AppDir/*.svg 		  	     || true
	rm -f $(PWD)/build/Boilerplate.AppDir/lib64/libstdc++.so.6*  || true

	cp --force $(PWD)/AppDir/*.desktop $(PWD)/build/Boilerplate.AppDir/       || true
	cp --force $(PWD)/AppDir/*.png     $(PWD)/build/Boilerplate.AppDir/       || true
	cp --force $(PWD)/AppDir/*.svg     $(PWD)/build/Boilerplate.AppDir/       || true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/Thorium.AppImage
	chmod +x $(PWD)/Thorium.AppImage

init:
	mkdir --parents $(PWD)/bin

	wget https://apprepo.de/appimage/download/apprepo \
		--output-document=$(PWD)/bin/Apprepo.AppImage
	chmod +x $(PWD)/bin/Apprepo.AppImage

	wget https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage \
		--output-document=$(PWD)/bin/appimagetool.AppImage
	chmod +x $(PWD)/bin/appimagetool.AppImage

clean:
	rm -rf $(PWD)/*.AppImage
	rm -rf $(PWD)/bin/*
	rm -rf $(PWD)/build
