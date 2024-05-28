import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/product_controller.dart';
import '../../../main.dart';
import '../../../models/model_category.dart';
import '../../../models/model_product.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/confirm_dialog.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  ProductForm({this.product, required this.onSave});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  //late String _code;
  late String _name;
  late String _unit;
  late int _categoryId;
  final controller = Get.find<ProductController>();
  @override
  void initState() {
    super.initState();
    controller.code.text = widget.product == null ? '' : '';
    //_code = widget.product?.code ?? '';
    controller.name.text = widget.product?.name ?? '';
    controller.unit.text = widget.product?.unit ?? '';

    if (widget.product != null) {
      controller.selectedCategory.value = controller.categoryList
          .firstWhere((e) => e.id == widget.product?.categoryId);
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
                TextFormField(
                  controller: controller.code,
                  decoration: const InputDecoration(labelText: 'Product Code'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _id = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an Product Code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => _name = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.unit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  onSaved: (value) => _unit = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a unit';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Category?>(
                  value: controller.selectedCategory.value,
                  hint: const Text('Select Category'),
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
                      return 'Please select category';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.selectedCategory.value = value;
                  },
                  items: controller.categoryList
                      .map<DropdownMenuItem<Category>>((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.description),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
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
                            await controller.insertProduct();

                            showAlertDialog(
                                context,
                                controller.hasError ? 'Error!' : 'Success!',
                                controller.resultMessage);
                            //   _formKey.currentState!.save();
                            //   widget.onSave(Product(
                            //     id: _id,
                            //     //   code: _code,
                            //     name: _name,
                            //     unit: _unit,
                            //     categoryId: _categoryId,
                            //   ));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
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
