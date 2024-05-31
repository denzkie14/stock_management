import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stock_management/controllers/delivery_controller.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/models/model_item.dart';
import 'package:stock_management/widgets/confirm_dialog.dart';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(delivery.id,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Obx(() {
            return Expanded(
              flex: 10,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.itemList.length,
                  itemBuilder: (_, index) {
                    num totalAmount = controller.itemList[index].quantity *
                        controller.itemList[index].unitPrice;
                    return Card(
                      child: ListTile(
                        leading: IconButton(
                            onPressed: () async {
                              var action = await showConfirmDialog(
                                  context,
                                  'Remove Item',
                                  'Are you sure you want to remove Item: ${controller.itemList[index].name}');

                              if (action) {
                                if (controller.itemList[index].id == 0) {
                                  controller.itemList.removeWhere((e) =>
                                      e.productId ==
                                      controller.itemList[index].productId);
                                } else {
                                  controller.delteItem(
                                      delivery, controller.itemList[index]);

                                  controller.itemList.removeWhere((e) =>
                                      e.productId ==
                                      controller.itemList[index].productId);
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                        title: Text(
                            '${controller.itemList[index].productId} - ${controller.itemList[index].name}'),
                        trailing: Text(
                          '₱ ${NumberFormat('#,##0.00').format(totalAmount)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                            '${NumberFormat('#,##0.00').format(controller.itemList[index].quantity)} @ ₱ ${NumberFormat('#,##0.00').format(controller.itemList[index].unitPrice)} ${controller.itemList[index].unit}'),
                      ),
                    );
                  }),
            );
          }),
          const Divider(),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Obx(() {
                      double totalAmount =
                          controller.itemList.fold(0.0, (sum, item) {
                        return sum + (item.quantity * item.unitPrice);
                      });
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount: ₱',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(NumberFormat('#,##0.00').format(totalAmount),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              var action = await showConfirmDialog(
                                  context,
                                  'Clear Cart',
                                  'Are you sure you want to remove all items in your cart?');

                              if (action) {
                                for (Item i in controller.itemList) {
                                  if (i.id == 0) {
                                    // controller.itemList.removeWhere(
                                    //     (e) => e.productId == i.productId);
                                  } else {
                                    controller.delteItem(delivery, i);
                                  }
                                }
                                controller.itemList.clear();
                              }
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.red),
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              var action = await showConfirmDialog(
                                  context, 'Save Items', 'Save changes?');

                              if (action) {
                                await controller.insertItems(delivery);
                                controller.loadItems(delivery);
                              }
                            },
                            child: const Text('Save',
                                style: TextStyle(color: Colors.green))),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
