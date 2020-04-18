SOURCE="https://dist.torproject.org/torbrowser/9.0.9/tor-browser-linux64-9.0.9_en-US.tar.xz"
DESTINATION="build.tar.xz"
OUTPUT="Tor-Browser.AppImage"


all:
	echo "Building: $(OUTPUT)"
	wget -O $(DESTINATION) -c $(SOURCE)

# 	tar -xJf $(DESTINATION)
	# tar -xJvf $(DESTINATION)

	# rm -rf AppDir/opt

	mkdir --parents AppDir/opt/application
	# cp -r tor-browser_en-US/Browser/* AppDir/opt/application

	chmod +x AppDir/AppRun

	export ARCH=x86_64 && bin/appimagetool.AppImage AppDir $(OUTPUT)

	chmod +x $(OUTPUT)

	#rm -f $(DESTINATION)
	#rm -rf AppDir/opt
	#rm -rf firefox
