import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MaintenanceReportScreen extends StatefulWidget {
  const MaintenanceReportScreen({Key? key}) : super(key: key);

  @override
  _MaintenanceReportScreenState createState() =>
      _MaintenanceReportScreenState();
}

class _MaintenanceReportScreenState extends State<MaintenanceReportScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 20,
          shadowColor: Color.fromARGB(255, 59, 33, 102),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          toolbarHeight: 110,
          backgroundColor: const Color.fromARGB(255, 18, 19, 26),
          foregroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset(
                'assets/images/FabriTrack logo.png',
                width: 90,
                height: 90,
              ),
              const SizedBox(width: 60),
              Text(
                'Maintenance \n     Report',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.deepPurple,
            ),
            indicatorColor: Color.fromARGB(255, 123, 36, 210),
            indicatorSize: TabBarIndicatorSize.tab,
            splashBorderRadius: BorderRadius.circular(30),
            tabs: [
              Tab(text: 'Motor Repair'),
              Tab(text: 'Belt Repair'),
              Tab(text: 'Roll Repair'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(166, 171, 184, 244),
            automaticIndicatorColorAdjustment: false,
          ),
        ),
        body: const TabBarView(
          children: [
            MaintenanceCategory(collectionName: 'motorrepair'),
            MaintenanceCategory(collectionName: 'beltrepair'),
            MaintenanceCategory(collectionName: 'rollrepair'),
          ],
        ),
      ),
    );
  }
}

class MaintenanceCategory extends StatefulWidget {
  final String collectionName;

  const MaintenanceCategory({Key? key, required this.collectionName})
      : super(key: key);

  @override
  _MaintenanceCategoryState createState() => _MaintenanceCategoryState();
}

class _MaintenanceCategoryState extends State<MaintenanceCategory> {
  late List<Map<String, dynamic>> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchDataAndCalculateIssues();
  }

  Future<void> fetchDataAndCalculateIssues() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(widget.collectionName)
        .get();

    final docs = querySnapshot.docs;

    Map<String, int> machineIssues = {};

    for (final doc in docs) {
      final issueData = doc.data() as Map<String, dynamic>;
      final machine = issueData['machine'] ?? '';
      //final issue = issueData['issue'] ?? '';

      machineIssues[machine] = (machineIssues[machine] ?? 0) + 1;
    }

    List<Map<String, dynamic>> data = [];

    machineIssues.forEach((machine, totalIssues) {
      data.add({'machine': machine, 'totalIssues': totalIssues});
    });

    setState(() {
      chartData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> color = <Color>[];
    color.add(Colors.purple);
    color.add(const Color.fromARGB(255, 185, 64, 255));
    color.add(Color.fromARGB(255, 120, 55, 172));

    final List<double> stops = <double>[];
    stops.add(0.5);
    stops.add(5.0);
    stops.add(0.1);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          // Add your chart here
          chartData != true
              ? SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelIntersectAction: AxisLabelIntersectAction.rotate45,
                    title: AxisTitle(text: 'Machine Number'),
                  ),
                  primaryYAxis: NumericAxis(
                    // Change Y-axis labels (total number of issues)
                    labelFormat:
                        '{value}', // Customize the label format as needed
                    title: AxisTitle(text: 'Total Issues'),
                  ),
                  series: <ChartSeries<Map<String, dynamic>, String>>[
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: chartData,
                      xValueMapper: (Map<String, dynamic> data, _) =>
                          data['machine'],
                      yValueMapper: (Map<String, dynamic> data, _) =>
                          data['totalIssues'],
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      sortingOrder: SortingOrder.descending,
                      sortFieldValueMapper: (Map<String, dynamic> data, _) =>
                          data['totalIssues'],
                      trackBorderColor: const Color.fromARGB(255, 54, 39, 57),
                      color: Colors.purple,
                      borderColor: Color.fromARGB(255, 121, 0, 213),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      gradient: gradientColors,
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),

          // Your list of maintenance items
          if (chartData != true && chartData.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: chartData.length,
                itemBuilder: (context, index) {
                  final data = chartData[index];
                  return ListTile(
                    title: Text('Machine No: ${data['machine'] ?? ''}'),
                    subtitle:
                        Text('Total Issues: ${data['totalIssues'] ?? ''}'),
                  );
                },
              ),
            )
          else
            const Center(child: Text('No issues available.')),
        ],
      ),
    );
  }
}
