import 'package:flutter/material.dart';
import 'package:stock_management/widgets/sidebar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
