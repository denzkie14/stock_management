import 'package:flutter/material.dart';

import '../controllers/sidebar_controller.dart';
import '../views/category/category_page.dart';
import '../views/dashboard/dashboard.dart';
import '../views/product/product_page.dart';
import '../views/stock/deliveries.dart';
import '../views/supplier/supplier_page.dart';

List<sidebarModel> pages = <sidebarModel>[
  sidebarModel(
      title: 'Dashboard',
      icon: const Icon(Icons.dashboard),
      page: const DashboardPage()),
  sidebarModel(
      title: 'Deliveries',
      icon: const Icon(Icons.delivery_dining),
      page: DeliveryPage()),
  sidebarModel(
      title: 'Products',
      icon: const Icon(Icons.shopping_basket),
      page: ProductPage()),
  sidebarModel(
      title: 'Categories',
      icon: const Icon(Icons.shopping_basket),
      page: CategoryPage()),
  sidebarModel(
      title: 'Suppliers', icon: const Icon(Icons.group), page: SupplierPage()),
  sidebarModel(
      title: 'Exit', icon: const Icon(Icons.exit_to_app), page: ProductPage()),
];
