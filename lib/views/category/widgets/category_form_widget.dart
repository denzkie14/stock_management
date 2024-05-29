import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/controllers/category_controller.dart';
import 'package:stock_management/models/model_supplier.dart';
import '../../../controllers/supplier_controller.dart';
import '../../../main.dart';
import '../../../models/model_category.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/confirm_dialog.dart';

class CategoryForm extends StatefulWidget {
  final Category? data;

  const CategoryForm({super.key, this.data});

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    controller.name.text = widget.data?.description ?? '';
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
                  'Category Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: controller.name,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Category name';
                    }
                    return null;
                  },
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
                              Category updatetedRecord = Category(
                                  id: widget.data!.id,
                                  description: controller.name.text);
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
