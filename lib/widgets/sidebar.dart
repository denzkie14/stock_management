import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/constants/sidebar_menu.dart';
import 'package:stock_management/main.dart';
import 'package:stock_management/widgets/confirm_dialog.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          child: Text(
            'Stock Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Obx(() => ListTile(
                    selectedColor: Colors.redAccent,
                    selected: sidebarController.selectedIndex.value == index,
                    leading: pages[index].icon,
                    title: Text(pages[index].title),
                    onTap: () async {
                      sidebarController.selectedIndex(index);
                      Navigator.pop(context); // Close the drawer
                      if (pages[index].title == 'Exit') {
                        var action = await showConfirmDialog(context, 'Exit',
                            'Are you sure you want to exit the application?');

                        if (action) {
                          exit(0);
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => pages[index].page),
                        );
                      }
                    },
                  ));
            })
      ],
    ));
  }
}
