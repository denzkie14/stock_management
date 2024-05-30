import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/widgets/sidebar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../controllers/dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = Get.put(DashboardController());
  String _selectedRange = 'No range selected';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _showDateRangePicker(context);
            },
            child: Text('Show Selected Range'),
          ),
        ],
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    final result = await showDialog<PickerDateRange>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date Range'),
          content: SizedBox(
            height: 300, // Adjust height as needed
            width: 420,
            child: SfDateRangePicker(
              showActionButtons: true,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  //Navigator.pop(context, args.value);
                }
              },
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: (object) {
                //  print('selected range: ${object}');
                Navigator.pop(context, object);
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedRange =
            'Selected range: ${result.startDate?.toLocal()} - ${result.endDate?.toLocal() ?? result.startDate?.toLocal()}';
        print(_selectedRange);
      });
    }
  }
}
