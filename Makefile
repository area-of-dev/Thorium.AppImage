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
LATEST="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media"
DESTINATION="build.zip"
REVISION=$(shell curl -s -S $(LATEST))


all: clean
	mkdir --parents $(PWD)/build
	mkdir --parents $(PWD)/build/AppDir	
	mkdir --parents $(PWD)/build/AppDir/chromium
	mkdir --parents $(PWD)/build/AppDir/proxy
	mkdir --parents $(PWD)/build/AppDir/share

	wget --output-document=${PWD}/build/build.zip  https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$(REVISION)%2Fchrome-linux.zip?alt=media
	unzip ${PWD}/build/build.zip -d ${PWD}/build

	wget --output-document=$(PWD)/build/build.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/zlib-1.2.11-16.el8_2.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/gtk3-3.22.30-5.el8.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatk-1_0-0-2.34.1-lp152.1.7.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatk-bridge-2_0-0-2.34.1-lp152.1.5.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatspi0-2.34.0-lp152.2.4.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --output-document=${PWD}/build/build.tar.xz  https://dist.torproject.org/torbrowser/10.0.5/tor-browser-linux64-10.0.5_en-US.tar.xz
	tar -xJvf ${PWD}/build/build.tar.xz -C ${PWD}/build
	
	cp --force --recursive ${PWD}/build/tor-browser*/Browser/abicheck $(PWD)/build/AppDir/proxy
	cp --force --recursive ${PWD}/build/tor-browser*/Browser/TorBrowser/Tor/* $(PWD)/build/AppDir/proxy	

	cp --force --recursive ${PWD}/build/chrome-*/* $(PWD)/build/AppDir/chromium
	cp --force --recursive $(PWD)/build/usr/* $(PWD)/build/AppDir/
	cp --force --recursive $(PWD)/AppDir/* $(PWD)/build/AppDir

	chmod +x $(PWD)/build/AppDir/AppRun
	chmod +x $(PWD)/build/AppDir/*.desktop

	export ARCH=x86_64 && bin/appimagetool.AppImage $(PWD)/build/AppDir $(PWD)/Tor-Chromium.AppImage
	chmod +x $(PWD)/Tor-Chromium.AppImage

clean:
	rm -rf 	$(PWD)/build