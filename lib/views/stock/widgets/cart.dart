import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/controllers/delivery_controller.dart';
import 'package:stock_management/models/model_delivery.dart';

class CartWidget extends StatelessWidget {
  CartWidget({
    super.key,
    required this.delivery,
  });
  final Delivery delivery;
  final controller = Get.find<DeliveryController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(delivery.id),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Obx(() {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.itemList.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(controller.itemList[index].name),
                  );
                });
          })
        ],
      ),
    );
  }
}
