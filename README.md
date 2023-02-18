# WooCommerceMobile

[![Version](https://img.shields.io/badge/Version-0.0.1-green)](https://github.com/ShiftHackZ/WooCommerceMobile/releases)

Flutter mobile WooCommerce application for your customers.

## Server requirements

`//ToDo: add requirements`

## Build instructions

In order to build the app, you need to create the `.env` file in project root directory, with the necessary variables.

Here is the example of `.env` file: 

```.env
# Base URL for the WooCommerce REST API 
WOO_BASE_URL = https://woocommerce.store/wp-json/wc/v3/

# Base URL for the CoCart REST API
CO_CART_BASE_URL = https://woocommerce.store/wp-json/cocart/v2/

# Base URL for the WordPress REST API 
WP_BASE_URL = https://woocommerce.store/wp-json/

# WooCommerce API Public token
AUTH_PUBLIC_TOKEN = (( SOME TOKEN STRING HERE ))

# WooCommerce API Secret token
AUTH_SECRET_TOKEN = (( SOME TOKEN STRING HERE ))

# CoCart API Public token
CO_CART_PUBLIC_TOKEN = (( SOME TOKEN STRING HERE ))

# CoCart API Secret token
CO_CART_SECRET_TOKEN = (( SOME TOKEN STRING HERE ))

```

For the security reasons do not commit or share with anyone content of this file. For this repo `.env` file is added to `.gitignore`. 

After that you can build the app using your local flutter environment (Android Studio, VS Code, or just execute `flutter build` / `flutter run` in console). 

## Available languages

User interface of the app is translated for languages listed below:

- English
- Українська
- Русский

Any contributions to the translations are welcome.

## License 

This license of the software is opensource, but contains some restrictions. 

- The software is provided `as is` and may contain some issues.
- Commercial usage of this app and any fork that is based on this app is not allowed without author permission.
- Distribution of this app and any fork that is based on this app to any public store (like Google Play, App Store, F-Droid) is not allowed without author permission.
- Every fork that is based on this app should contain original copyright UI section.

Full license agreement is available [here](https://1.cc).

## Maintainers

- Dmitriy Moroz / dmitriy@moroz.cc
