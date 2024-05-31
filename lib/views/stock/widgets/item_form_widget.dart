import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stock_management/controllers/delivery_controller.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/models/model_item.dart';
import 'package:stock_management/models/model_product.dart';
import 'package:stock_management/models/model_supplier.dart';
import '../../../main.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/confirm_dialog.dart';

class ItemForm extends StatefulWidget {
  final Product data;

  const ItemForm({super.key, required this.data});

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<DeliveryController>();

  final basePrice = TextEditingController();
  final quantity = TextEditingController();
  final totalAmount = TextEditingController();

  @override
  void initState() {
    super.initState();

    // controller.id.text = widget.data?.id ?? controller.transactionNumber.value;

    // if (widget.data != null) {
    //   controller.selectedSupplier.value = controller.supplierList
    //       .firstWhere((s) => s.id == widget.data?.supplierId);

    //   controller.deliveryDate.text =
    //       DateFormat('yyyy-MM-dd').format(widget.data!.deliveryDate);
    // } else {
    //   controller.selectedSupplier.value = null;
    //   generateCode();
    //   controller.deliveryDate.text =
    //       DateFormat('yyyy-MM-dd').format(DateTime.now());
    // }
    // controller.deliveryNumber.text = widget.data?.deliveryNumber ?? '';
  }

  compute() async {
    try {
      num _quantity = num.parse(quantity.text);
      num _basePrice = num.parse(quantity.text);
      num total = _quantity * _basePrice;
      totalAmount.text = NumberFormat('#,##0.00').format(total);
    } catch (e) {}
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.deliveryDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${widget.data.id} - ${widget.data.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: basePrice,
                  decoration: const InputDecoration(labelText: 'Base Price'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onFieldSubmitted: (value) {
                    compute();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a base price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: quantity,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onFieldSubmitted: (value) {
                    compute();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                ),
                Visibility(
                  visible: false,
                  child: TextFormField(
                    readOnly: true,
                    controller: totalAmount,
                    decoration:
                        const InputDecoration(labelText: 'Total Amount'),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter a total amount';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Item _item = Item(
                              productId: widget.data.id,
                              name: widget.data.name,
                              id: 0,
                              unit: widget.data.unit,
                              quantity: num.parse(quantity.text),
                              unitPrice: num.parse(basePrice.text),
                              stockOnHand: 0,
                              deliveryId: '0000',
                              expirationDate: DateTime.now());

                          int index = controller.itemList
                              .indexWhere((i) => i.productId == widget.data.id);

                          if (controller.itemList.indexWhere(
                                  (i) => i.productId == widget.data.id) ==
                              -1) {
                            controller.itemList.add(_item);
                          } else {
                            Item newItem = controller.itemList[index];
                            newItem.unitPrice = num.parse(basePrice.text);
                            newItem.quantity = num.parse(basePrice.text);

                            controller.itemList.removeAt(index);
                            controller.itemList.insert(index, newItem);
                          }

                          Navigator.of(
                            navigatorKey.currentContext!,
                          ).pop();
                          // final action = await showConfirmDialog(
                          //     navigatorKey.currentContext!,
                          //     'Save',
                          //     'Save changes?');
                          // if (action) {
                          //   if (widget.data == null) {
                          //     await controller.insertRecord();
                          //   } else {
                          //     Delivery updatetedRecord = Delivery(
                          //         id: widget.data!.id,
                          //         supplierId: controller
                          //             .selectedSupplier.value?.id as int,
                          //         deliveryDate: DateTime.parse(
                          //             controller.deliveryDate.text),
                          //         deliveryNumber:
                          //             controller.deliveryNumber.text,
                          //         createdBy: '1',
                          //         isDeleted: false);
                          //     await controller.updateRecord(updatetedRecord);
                          //   }
                          //   Navigator.of(
                          //     navigatorKey.currentContext!,
                          //   ).pop();
                          //   showAlertDialog(
                          //       navigatorKey.currentContext!,
                          //       controller.hasError ? 'Error!' : 'Success!',
                          //       controller.resultMessage);
                          // }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                      ),
                      child: Text(
                        widget.data == null ? 'Add' : 'Add',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
