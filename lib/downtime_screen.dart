import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

class DownTimeScreen extends StatefulWidget {
  @override
  _DownTimeScreenState createState() => _DownTimeScreenState();
}

class _DownTimeScreenState extends State<DownTimeScreen> {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref('Device 01/Day');
  double maxY = 1000.0; // Initial maxY value
  List<String> dates = [];
  Map<String, double> totalDurations = {};
  Map<String, double> downTimes = {}; // Store downtime for each day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Down Time Chart'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _showTotalDurationList(context);
            },
          ),
        ],
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

              List<FlSpot> dataPoints = [];
              dates.clear();
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
                dataPoints
                    .add(FlSpot(dates.indexOf(date).toDouble(), downtime));
              }

              maxY = maxTotalDuration + 50;
              // Set maxY value for downtime chart

              return LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                    ),
                    bottomTitles: SideTitles(
                      showTitles: false,
                      getTitles: (value) {
                        // Customize the X-axis titles here
                        if (value >= 0 && value < dates.length) {
                          return dates[value.toInt()];
                        }
                        return '';
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                  ),
                  gridData: FlGridData(
                    show: true,
                  ),
                  minX: 0,
                  maxX: (dates.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: false,
                      colors: [Color.fromARGB(255, 243, 5, 5)],
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueAccent,
                      getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                        return lineBarsSpot.map((LineBarSpot spot) {
                          final String date = dates[spot.x.toInt()];
                          final double downtime = downTimes[date] ?? 0.0;

                          return LineTooltipItem(
                            '$date\nDowntime: $downtime min',
                            TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
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
