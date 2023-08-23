# taxigo

Flutter version to build: Flutter 3.13.0 • channel stable

## Setting up the API Key

To get started, follow these steps to set up your API key:

For Android: 

1. Create a file named `key.properties` in the **android** folder of your project.

2. Open the `key.properties` file and add your Yandex MapKit API key like this:

   ```properties
   MAPS_API_KEY=yandex_mapkit_mobile_sdk_key

For iOS:

1. Create a file named `keys.plist` in the **ios** folder of your project.

2. Open the `keys.plist` file and add your Yandex MapKit API key like this:

   ```keys
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
	   <key>MAPS_API_KEY</key>
	   <string>YOUR_API_KEY</string>
   </dict>
   </plist>

For Flutter:
3. Create a file named `.env` in the root directory of your project.

2. Open the `.env` file and add your API keys like this:

   ```env
   ORG_SEARCH_API_KEY=yandex_javascript_api_and_geocoder_http_api_key
   YANDEX_GEOCODER_API_KEY=yandex_places_http_api_key

These keys can be obtained from here: https://developer.tech.yandex.ru/services/


##
##
## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
