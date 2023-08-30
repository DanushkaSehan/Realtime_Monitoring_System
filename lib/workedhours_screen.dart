// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class SalesData {
//   SalesData(this.day, this.totalWorkedHours);
//   final String day;
//   final double totalWorkedHours;
// }

// class WorkedhourScreen extends StatefulWidget {
//   @override
//   _WorkedhourScreenState createState() => _WorkedhourScreenState();
// }

// class _WorkedhourScreenState extends State<WorkedhourScreen> {
//   late TooltipBehavior _tooltipBehavior;
//   List<SalesData> chartData = [];

//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     loadDataFromFirebase();
//     super.initState();
//   }

//   void loadDataFromFirebase() {
//     _databaseReference.child('Day').once().then((event) {
//       if (event.snapshot.value != null) {
//         Map<String, dynamic> snapshotValue =
//             event.snapshot.value as Map<String, dynamic>;
//         snapshotValue.forEach((dayKey, dayValue) {
//           double totalWorkedHours = 0;
//           if (dayValue != null && dayValue is Map<String, dynamic>) {
//             dayValue.forEach((fabricKey, fabricValue) {
//               if (fabricValue.containsKey('Duration')) {
//                 double duration =
//                     double.parse(fabricValue['Duration'].toString());
//                 totalWorkedHours += duration;
//               }
//             });
//             chartData.add(SalesData(dayKey, totalWorkedHours));
//           }
//         });
//         setState(() {});
//       }
//     });
//   }

import 'package:firebase_database/firebase_database.dart';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Worked Hours Chart'),
//       ),
//       body: Center(
//         child: Container(
//           child: SfCartesianChart(
//             primaryXAxis: CategoryAxis(),
//             title: ChartTitle(text: 'Daily Worked Hours'),
//             tooltipBehavior: _tooltipBehavior,
//             series: <LineSeries<SalesData, String>>[
//               LineSeries<SalesData, String>(
//                 dataSource: chartData,
//                 xValueMapper: (SalesData sales, _) => sales.day,
//                 yValueMapper: (SalesData sales, _) => sales.totalWorkedHours,
//                 dataLabelSettings: DataLabelSettings(isVisible: true),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.day, this.totalWorkedHours);
  final String day;
  final double totalWorkedHours;
}

class WorkedhourScreen extends StatefulWidget {
  const WorkedhourScreen({super.key});

  @override
  _WorkedhourScreenState createState() => _WorkedhourScreenState();
}

class _WorkedhourScreenState extends State<WorkedhourScreen> {
  late TooltipBehavior _tooltipBehavior;
  List<SalesData> chartData = [];

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Device 01/Day/new');

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    loadDataFromFirebase();
    super.initState();
  }

  void loadDataFromFirebase() {
    _databaseReference.once().then((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> snapshotValue =
            event.snapshot.value as Map<String, dynamic>;
        snapshotValue.forEach((dayKey, dayValue) {
          double totalWorkedHours = 0;
          if (dayValue != null && dayValue is Map<String, dynamic>) {
            dayValue.forEach((fabricKey, fabricValue) {
              if (fabricValue is Map<String, dynamic> &&
                  fabricValue.containsKey('Duration')) {
                double duration =
                    double.parse(fabricValue['Duration'].toString());
                totalWorkedHours += duration;
              }
            });
            chartData.add(SalesData(dayKey, totalWorkedHours));
          }
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worked Hours Chart'),
      ),
      body: Center(
        child: Container(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Daily Worked Hours'),
            tooltipBehavior: _tooltipBehavior,
            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                dataSource: chartData,
                xValueMapper: (SalesData sales, _) => sales.day,
                yValueMapper: (SalesData sales, _) => sales.totalWorkedHours,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: WorkedhourScreen(),
  ));
}
