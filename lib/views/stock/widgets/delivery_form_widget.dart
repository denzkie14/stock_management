import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stock_management/controllers/delivery_controller.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/models/model_supplier.dart';
import '../../../controllers/supplier_controller.dart';
import '../../../main.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/confirm_dialog.dart';

class DeliveryForm extends StatefulWidget {
  final Delivery? data;

  const DeliveryForm({super.key, this.data});

  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<DeliveryController>();

  @override
  void initState() {
    super.initState();

    controller.id.text = widget.data?.id ?? controller.transactionNumber.value;

    if (widget.data != null) {
      controller.selectedSupplier.value = controller.supplierList
          .firstWhere((s) => s.id == widget.data?.supplierId);

      controller.deliveryDate.text =
          DateFormat('yyyy-MM-dd').format(widget.data!.deliveryDate);
    } else {
      controller.selectedSupplier.value = null;
      generateCode();
      controller.deliveryDate.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    controller.deliveryNumber.text = widget.data?.deliveryNumber ?? '';
  }

  generateCode() async {
    await controller.generateTransactionCode();

    controller.id.text = controller.transactionNumber.value;
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
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Delivery Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  readOnly: true,
                  controller: controller.id,
                  decoration: const InputDecoration(labelText: 'Transaction #'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Transaction number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Supplier?>(
                  value: controller.selectedSupplier.value,
                  hint: const Text('Select Supplier'),
                  //  icon: Icon(Icons.arrow_downward),
                  //   iconSize: 24,
                  //  elevation: 16,
                  // style: TextStyle(color: Colors.deepPurple),
                  // underline: Container(
                  //   height: 2,
                  //   color: Colors.deepPurpleAccent,
                  // ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select supplier';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.selectedSupplier.value = value;
                  },
                  items: controller.supplierList
                      .map<DropdownMenuItem<Supplier>>((Supplier item) {
                    return DropdownMenuItem<Supplier>(
                      value: item,
                      child: Text(item.name),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: controller.deliveryNumber,
                  decoration:
                      const InputDecoration(labelText: 'Delivery Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a delivery number';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: controller.deliveryDate,
                        decoration:
                            const InputDecoration(labelText: 'Delivery Date'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a delivery date';
                          }
                          return null;
                        },
                      ),
                    )),
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
                          final action = await showConfirmDialog(
                              navigatorKey.currentContext!,
                              'Save',
                              'Save changes?');
                          if (action) {
                            if (widget.data == null) {
                              await controller.insertRecord();
                            } else {
                              Delivery updatetedRecord = Delivery(
                                  id: widget.data!.id,
                                  supplierId: controller
                                      .selectedSupplier.value?.id as int,
                                  deliveryDate: DateTime.parse(
                                      controller.deliveryDate.text),
                                  deliveryNumber:
                                      controller.deliveryNumber.text,
                                  createdBy: '1',
                                  isDeleted: false);
                              await controller.updateRecord(updatetedRecord);
                            }
                            Navigator.of(
                              navigatorKey.currentContext!,
                            ).pop();
                            showAlertDialog(
                                navigatorKey.currentContext!,
                                controller.hasError ? 'Error!' : 'Success!',
                                controller.resultMessage);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                      ),
                      child: Text(
                        widget.data == null ? 'Add' : 'Update',
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
