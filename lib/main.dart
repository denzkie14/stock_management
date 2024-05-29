import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/sidebar_controller.dart';
import 'views/dashboard/dashboard.dart';
import 'views/product/product_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final sidebarController = Get.put(SidebarController());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Stock Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}
