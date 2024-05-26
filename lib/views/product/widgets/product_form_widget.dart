import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../models/model_product.dart';
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
  late String _code;
  late String _name;
  late String _unit;
  late int _categoryId;

  @override
  void initState() {
    super.initState();
    _id = widget.product == null ? '' : '';
    //_code = widget.product?.code ?? '';
    _name = widget.product?.name ?? '';
    _unit = widget.product?.unit ?? '';
    _categoryId = widget.product?.categoryId ?? 0;
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
                  initialValue: _id.toString(),
                  decoration: const InputDecoration(labelText: 'ID'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _id = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _code,
                  decoration: const InputDecoration(labelText: 'Code'),
                  onSaved: (value) => _code = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _name,
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
                  initialValue: _unit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  onSaved: (value) => _unit = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a unit';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _categoryId.toString(),
                  decoration: const InputDecoration(labelText: 'Category ID'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _categoryId = int.parse(value!),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category ID';
                    }
                    return null;
                  },
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
                              _id == 0 ? 'Save new product?' : 'Save changes?');
                          if (action) {
                            _formKey.currentState!.save();
                            widget.onSave(Product(
                              id: _id,
                              //   code: _code,
                              name: _name,
                              unit: _unit,
                              categoryId: _categoryId,
                            ));
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
