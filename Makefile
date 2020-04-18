DESTINATION_BROWSER="chrome-linux.zip"

SOURCE="https://dist.torproject.org/torbrowser/9.0.9/tor-browser-linux64-9.0.9_en-US.tar.xz"
DESTINATION_PROXY="build.tar.xz"
OUTPUT="Tor-Chromium.AppImage"


all: tor-proxy tor-browser

	chmod +x AppDir/AppRun
	export ARCH=x86_64 && bin/appimagetool.AppImage AppDir $(OUTPUT)
	chmod +x $(OUTPUT)

	echo "Done: $(OUTPUT)"

	rm -rf AppDir/opt

	
tor-proxy:
	echo "Building: $(OUTPUT)"
	wget -O $(DESTINATION_PROXY) -c $(SOURCE)

	tar -xJvf $(DESTINATION_PROXY)

	rm -rf AppDir/opt/tor-proxy
	mkdir --parents AppDir/opt/tor-proxy
	
	cp -r tor-browser_en-US/Browser/abicheck AppDir/opt/tor-proxy
	cp -r tor-browser_en-US/Browser/TorBrowser/Tor/* AppDir/opt/tor-proxy
	
	rm -rf $(DESTINATION_PROXY)
	rm -rf tor-browser*
	
	
tor-browser:
	scripts/latest.sh
	unzip $(DESTINATION_BROWSER)

	rm -rf AppDir/opt/tor-browser
	mkdir --parents AppDir/opt/tor-browser
	
	cp -r chrome-linux/* AppDir/opt/tor-browser
	rm -f AppDir/opt/tor-browser/product_logo_48.png
	cp AppDir/icon.svg AppDir/opt/tor-browser/product_logo_48.svg
	rm -rf chrome-linux
