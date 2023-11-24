import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refactor_task/controllers/theme_controller.dart';
import 'package:refactor_task/models/item.dart';
import 'package:refactor_task/screens/home_page.dart';
import 'package:refactor_task/screens/test_app.dart';
import 'package:refactor_task/services/items.dart';
import 'package:refactor_task/styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();

  await Hive.initFlutter(dir.path);
  await GetStorage.init();
  Hive.registerAdapter(ItemAdapter());
  Get.put(ThemeController());
  runApp(
    GetMaterialApp(
      themeMode: Get.find<ThemeController>().isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      home: TestApp(),
      navigatorKey: Get.key,
      theme: lightTheme,
      darkTheme: darkTheme,
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
      ],
    ),
  );
}
