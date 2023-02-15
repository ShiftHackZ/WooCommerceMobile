import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wooapp/database/cart_cache_item.dart';
import 'package:wooapp/database/filter.dart';
import 'package:wooapp/database/filter_value.dart';
import 'package:wooapp/database/filter_active.dart';
import 'package:wooapp/database/product.dart';
import 'package:wooapp/database/user.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/screens/splash/splash.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('uk'),
        Locale('ru'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      saveLocale: true,
      child: WooShopApp(),
    )
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

  void initHive() async {
    Hive
      ..initFlutter()
      ..registerAdapter(CartCacheItemAdapter())
      ..registerAdapter(FilterValueAdapter())
      ..registerAdapter(ActiveFilterAdapter())
      ..registerAdapter(FilterAdapter())
      ..registerAdapter(ViewedProductAdapter())
      ..registerAdapter(UserAdapter());
  }
}
