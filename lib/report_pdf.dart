import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFGenerator {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref('Device 01/Day');

  Future<void> generatePDF() async {
    final Map<String, double> totalDurations = {};
    final Map<String, double> downTimes = {};

    DatabaseEvent event = await reference.once();
    DataSnapshot dataSnapshot =
        event.snapshot; // Get DataSnapshot from DatabaseEvent

    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
      Map<dynamic, dynamic> dayData =
          dataSnapshot.value as Map<dynamic, dynamic>;

      dayData.forEach((date, fabricData) {
        double totalDuration = 0.0;

        fabricData.forEach((fabricName, fabricDetails) {
          Map<dynamic, dynamic> details = fabricDetails;
          double duration = (details['Duration'] ?? 0).toDouble();
          totalDuration += duration;
        });

        double downtime = 480 - totalDuration;

        totalDurations[date] = totalDuration;
        downTimes[date] = downtime;
      });

      await _generatePDFDocument(totalDurations, downTimes);
    }
  }

  Future<void> _generatePDFDocument(
      Map<String, double> totalDurations, Map<String, double> downTimes) async {
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);

    grid.headers.add(1);
    grid.headers[0].cells[0].value = 'Date';
    grid.headers[0].cells[1].value = 'Worked Hours';
    grid.headers[0].cells[2].value = 'Downtime';

    int i = 0;
    totalDurations.forEach((date, totalDuration) {
      grid.rows.add();
      grid.rows[i].cells[0].value = date;
      grid.rows[i].cells[1].value = totalDuration.toStringAsFixed(2);

      // Handle potential null value for downTimes[date]
      grid.rows[i].cells[2].value =
          downTimes[date]?.toStringAsFixed(2) ?? 'N/A';
      i++;
    });

    PdfLayoutResult? layoutResult = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 0, page.getClientSize().width, page.getClientSize().height),
    );

    // Use a null check or assertion to handle nullable PdfLayoutResult
    if (layoutResult != null) {
      // Perform actions with layoutResult
    } else {
      // Handle the case where layoutResult is null
    }

    //final String downloadDirectory = await _getDownloadDirectoryPath();
    final String path = '/storage/emulated/0/Download/downtime_data.pdf';
    final File file = File(path);
    final List<int> bytes = await document.save();
    await file.writeAsBytes(bytes);

    document.dispose();
  }

  Future<String> _getDownloadDirectoryPath() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    return directory!.path;
  }
}
