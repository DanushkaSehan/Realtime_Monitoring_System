import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkedHourScreen extends StatefulWidget {
  @override
  _WorkedHourScreenState createState() => _WorkedHourScreenState();
}

class _WorkedHourScreenState extends State<WorkedHourScreen> {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref('Device 01/Day');
  double maxY = 1000.0; // Initial maxY value
  List<String> dates = [];
  Map<String, double> totalDurations = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worked Hours Chart'),
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

              // Calculate total duration worked for each day and update maxY
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

                dates.add(date);
                totalDurations[date] = totalDuration;

                if (totalDuration > maxTotalDuration) {
                  maxTotalDuration = totalDuration;
                }
                dataPoints
                    .add(FlSpot(dates.indexOf(date).toDouble(), totalDuration));
              }

              maxY = maxTotalDuration + 50;

              return LineChart(
                LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            // Display the date as X-axis labels
                            if (value >= 0 && value < dates.length) {
                              return Text(dates[value.toInt()]);
                            }
                            return Text('');
                          },
                        ),
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
                        color: Colors.blue,
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
                            final double totalDuration =
                                totalDurations[date] ?? 0.0;

                            return LineTooltipItem(
                              '$date\nTotal Time: $totalDuration',
                              TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                    )),
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
          title: Text('Total Durations'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dates[index]),
                  subtitle:
                      Text('Total Duration: ${totalDurations[dates[index]]}'),
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
