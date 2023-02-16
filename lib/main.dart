import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wooapp/constants/translations.dart';
import 'package:wooapp/database/entity/filter.dart';
import 'package:wooapp/database/entity/filter_value.dart';
import 'package:wooapp/database/entity/filter_active.dart';
import 'package:wooapp/database/entity/product.dart';
import 'package:wooapp/database/entity/user.dart';
import 'package:wooapp/database/entity/wish_list_cache_item.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/screens/splash/splash.dart';
import 'package:wooapp/database/entity/cart_cache_item.dart';

/// WooApp
/// Flutter WooCommerce online mobile application for customers.
///
/// Commercial usage of this app is not allowed without author official permission.
///
/// Copyright © 2020 - 2023
/// All rights reserved
/// Author: Dmitriy Moroz (ShiftHackZ)
/// dmitriy@moroz.cc
/// https://dmitriy.moroz.cc
///
void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: Translations.languages.map((l) => l.locale).toList(),
      fallbackLocale: Translations.languages[0].locale,
      path: 'assets/translations',
      saveLocale: true,
      child: WooShopApp(),
    ),
  );
}

class WooShopApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WooShopAppState();
}

class _WooShopAppState extends State<WooShopApp> {
  late Future dependencyFuture;

  @override
  void initState() {
    super.initState();
    initHive();
    dependencyFuture = setupDependencies();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: tr('app_name'),
    localizationsDelegates: context.localizationDelegates,
    supportedLocales: context.supportedLocales,
    locale: context.locale,
    debugShowCheckedModeBanner: false,
    home: FutureBuilder(
      future: dependencyFuture,
      builder: (context, snapshot) => SplashScreen(),
    ),
  );

  void initHive() => Hive
    ..initFlutter()
    ..registerAdapter(CartCacheItemAdapter())
    ..registerAdapter(WishListCacheItemAdapter())
    ..registerAdapter(FilterValueAdapter())
    ..registerAdapter(ActiveFilterAdapter())
    ..registerAdapter(FilterAdapter())
    ..registerAdapter(ViewedProductAdapter())
    ..registerAdapter(UserAdapter());
}
