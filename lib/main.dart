import 'package:algo_trade/firebase/firebase_init.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifcations();

  await GetStorage.init();
  final box = GetStorage();
  box.writeIfNull('theme', 'dark');

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: box.read('theme') == 'dark' ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    ),
  );
}
