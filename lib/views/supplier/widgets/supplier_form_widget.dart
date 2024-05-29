import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/models/model_supplier.dart';
import '../../../controllers/supplier_controller.dart';
import '../../../main.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/confirm_dialog.dart';

class SupplierForm extends StatefulWidget {
  final Supplier? data;

  const SupplierForm({super.key, this.data});

  @override
  _SupplierFormState createState() => _SupplierFormState();
}

class _SupplierFormState extends State<SupplierForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<SupplierController>();

  @override
  void initState() {
    super.initState();
    controller.name.text = widget.data?.name ?? '';
    controller.contactNumber.text = widget.data?.contactNumber ?? '';
    controller.address.text = widget.data?.address ?? '';
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
                  'Supplier Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: controller.name,
                  decoration: const InputDecoration(labelText: 'Supplier Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a supplier name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.address,
                  decoration: const InputDecoration(labelText: 'Address'),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter an address';
                  //   }
                  //   return null;
                  // },
                ),
                TextFormField(
                  controller: controller.contactNumber,
                  decoration:
                      const InputDecoration(labelText: 'Contact Number'),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter a contact number';
                  //   }
                  //   return null;
                  // },
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
                          final action = await showConfirmDialog(
                              navigatorKey.currentContext!,
                              'Save',
                              'Save changes?');
                          if (action) {
                            if (widget.data == null) {
                              await controller.insertRecord();
                            } else {
                              Supplier updatetedRecord = Supplier(
                                id: widget.data!.id,
                                name: controller.name.text,
                                address: controller.address.text,
                                contactNumber: controller.contactNumber.text,
                              );
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
