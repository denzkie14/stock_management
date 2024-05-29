import 'package:flutter/material.dart';
import 'package:get/get.dart';

class sidebarModel {
  final String title;
  final Icon icon;
  final Widget page;

  sidebarModel({required this.page, required this.title, required this.icon});
}

class SidebarController extends GetxController {
  var selectedIndex = 0.obs;

  get() => selectedIndex.value;
  set(int index) => selectedIndex.value = index;
}
