import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DownTimeScreen extends StatefulWidget {
  @override
  _DownTimeScreenState createState() => _DownTimeScreenState();
}

class _DownTimeScreenState extends State<DownTimeScreen> {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref('Device 01/Day');
  double maxY = 1000.0; // Initial maxY value
  List<String> dates = [];
  List<Map<String, double>> dataPoints = [];
  Map<String, double> totalDurations = {};
  Map<String, double> downTimes = {}; // Store downtime for each day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        shadowColor: Color.fromARGB(255, 59, 33, 102),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _showTotalDurationList(context);
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 110,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 18, 19, 26),
        title: Row(
          children: [
            Image.asset(
              'assets/images/FabriTrack logo.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 60),
            Flexible(
              child: Container(
                child: Text(
                  'Downtime \n    Chart',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: reference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            if (dataSnapshot.value != null && dataSnapshot.value is Map) {
              Map<dynamic, dynamic> dayData =
                  dataSnapshot.value as Map<dynamic, dynamic>;
              dates = dayData.keys.cast<String>().toList();

              dates.clear();
              dataPoints.clear();
              totalDurations.clear();
              downTimes.clear();

              // Calculate total duration worked and downtime for each day
              double maxTotalDuration = 0.0;
              for (String date in dayData.keys) {
                Map<dynamic, dynamic> fabricData = dayData[date];
                double totalDuration = 0.0;

                // Calculate total duration for each fabric on the day
                fabricData.forEach((fabricName, fabricDetails) {
                  Map<dynamic, dynamic> details = fabricDetails;
                  double duration = (details['Duration'] ?? 0).toDouble();
                  totalDuration += duration;
                });

                // Calculate downtime
                double downtime = 480 - totalDuration;

                dates.add(date);
                totalDurations[date] = totalDuration;
                downTimes[date] = downtime;

                if (totalDuration > maxTotalDuration) {
                  maxTotalDuration = totalDuration;
                }

                dataPoints.add({
                  'x': dates.indexOf(date).toDouble(),
                  'y': downtime,
                });
              }

              maxY = maxTotalDuration + 50;

              return Center(
                child: Container(
                  height: 700, // Set the desired height
                  width: 420, // Set the desired width
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 4,
                            margin: EdgeInsets.all(8),
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Y axis: Downtime (min)',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            margin: EdgeInsets.all(8),
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'X axis: Date',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          primaryYAxis: NumericAxis(
                            maximum: maxY,
                            labelFormat: '{value} ',
                            axisLine: AxisLine(width: 0),
                          ),
                          series: <LineSeries<Map<String, double>, double>>[
                            LineSeries<Map<String, double>, double>(
                              color: Colors.red,
                              dataSource: dataPoints,
                              xValueMapper: (data, _) => data['x']!,
                              yValueMapper: (data, _) => data['y']!,
                            ),
                          ],
                          zoomPanBehavior: ZoomPanBehavior(
                            enablePinching: true,
                            enableDoubleTapZooming: true,
                            enablePanning: true,
                          ),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            header: 'Downtime',
                            duration: 3000,
                            format: 'point.x : point.y min',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('No data available'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _showTotalDurationList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Total Durations and Downtimes'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dates[index]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Duration: ${totalDurations[dates[index]]}'),
                      Text('Downtime: ${downTimes[dates[index]]} min'),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
