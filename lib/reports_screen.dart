import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'background_widget.dart';
import 'downtime_screen.dart';
import 'efficiency_screen.dart';
import 'maintenancereport_screen.dart';
import 'workedhours_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 18, 19, 26),
      appBar: AppBar(
        elevation: 20,
        shadowColor: Color.fromARGB(255, 59, 33, 102),
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
            const SizedBox(width: 130),
            Flexible(
              child: Container(
                child: Text(
                  'Reports'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        //title: Text('Filtered Day Wise Data'),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 150),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 80),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DownTimeScreen()),
                    );
                  },
                  icon: const Icon(Icons.area_chart_outlined),
                  label: Text('Down Time'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 80),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkedHourScreen()),
                    );
                  },
                  icon: const Icon(Icons.analytics_outlined),
                  label: Text('Worked Hours'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 80),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EfficiencyScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_chart),
                  label: Text('Efficiency'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 80),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 35, 28, 75),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MaintenanceReportScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_ic_call),
                  label: Text('Maintenance Report'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: Stack(
      //   alignment:
      //       Alignment.topRight, // Align the switch to the top-right corner
      //   children: [
      //     Positioned(
      //       top: 180, // Adjust the top position as needed
      //       right: 0, // Adjust the right position as needed

      //       child: SizedBox(
      //         height: 30,
      //         child: FloatingActionButton(
      //           backgroundColor: const Color.fromARGB(255, 141, 84, 177),
      //           onPressed: () async{
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => PDFGenerator()));
      //           },
      //           tooltip: 'Action 2',
      //           child: Icon(Icons.picture_as_pdf_outlined),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      floatingActionButton: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            top: 180,
            right: 0,
            child: SizedBox(
              height: 30,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 141, 84, 177),
                onPressed: () async {
                  PDFGenerator pdfGenerator = PDFGenerator();
                  await pdfGenerator
                      .generatePDF(); // Call the generatePDF method
                  // Show a dialog or perform any other action after PDF generation
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('PDF Generated'),
                        content: Text('PDF file created successfully!'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                tooltip: 'Generate PDF',
                child: Icon(Icons.picture_as_pdf_outlined),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PDFGenerator {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref('Device 01/Day');

  Future<void> generatePDF() async {
    final Map<String, Map<String, double>> rowData = {};

    DatabaseEvent event = await reference.once();
    DataSnapshot dataSnapshot =
        event.snapshot; // Get DataSnapshot from DatabaseEvent

    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
      Map<dynamic, dynamic> dayData =
          dataSnapshot.value as Map<dynamic, dynamic>;

      dayData.forEach((date, fabricData) {
        double totalDuration = 0.0;
        double encoder1Data =
            0.0; // Sample initialization, replace with actual data
        double encoder2Data =
            0.0; // Sample initialization, replace with actual data

        fabricData.forEach((fabricName, fabricDetails) {
          Map<dynamic, dynamic> details = fabricDetails;
          double duration = (details['Duration'] ?? 0).toDouble();
          double encoder1 = (details['Input'] ?? 0)
              .toDouble(); // Replace 'Encoder1Data' with your field name
          double encoder2 = (details['Output'] ?? 0)
              .toDouble(); // Replace 'Encoder2Data' with your field name

          totalDuration += duration;
          encoder1Data += encoder1;
          encoder2Data += encoder2;
        });

        double downtime = 480 - totalDuration;

        rowData[date] = {
          'TotalDuration': totalDuration,
          'Encoder1Data': encoder1Data,
          'Encoder2Data': encoder2Data,
          'Downtime': downtime,
        };
      });

      await _generatePDFDocument(rowData);
    }
  }

  Future<void> _generatePDFDocument(
      Map<String, Map<String, double>> rowData) async {
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    final PdfGrid grid = PdfGrid();
    grid.columns
        .add(count: 5); // Adjust the count according to the number of columns

    grid.headers.add(1);
    grid.headers[0].cells[0].value = 'Date';
    grid.headers[0].cells[1].value = 'Total Duration';
    grid.headers[0].cells[2].value = 'Total Input Length';
    grid.headers[0].cells[3].value = 'Total Output Length';
    grid.headers[0].cells[4].value = 'Downtime';

    int i = 0;
    rowData.forEach((date, data) {
      grid.rows.add();
      grid.rows[i].cells[0].value = date;
      grid.rows[i].cells[1].value =
          data['TotalDuration']?.toStringAsFixed(2) ?? 'N/A';
      grid.rows[i].cells[2].value =
          data['Encoder1Data']?.toStringAsFixed(2) ?? 'N/A';
      grid.rows[i].cells[3].value =
          data['Encoder2Data']?.toStringAsFixed(2) ?? 'N/A';
      grid.rows[i].cells[4].value =
          data['Downtime']?.toStringAsFixed(2) ?? 'N/A';
      i++;
    });

    PdfLayoutResult? layoutResult = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 0, page.getClientSize().width, page.getClientSize().height),
    );

    final String path = '/storage/emulated/0/Download/downtime_data.pdf';
    final File file = File(path);
    final List<int> bytes = await document.save();
    await file.writeAsBytes(bytes);

    document.dispose();
  }
}
