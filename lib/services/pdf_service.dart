import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:event_manager/db/db_helper.dart';

class PdfExportService {
  static Future<void> exportTask() async {

    if (!await Permission.storage.request().isGranted) {
      throw Exception("Storage permission is required to export PDF.");
    }

    final tasks = await DBHelper.fetchAllTasks();
    if (tasks.isEmpty) {
      throw Exception("No tasks available to export.");
    }

    // Load custom font
    final font = await rootBundle.load("fonts/Lato-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    // Create the PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context pdfContext) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(
                "Event Report",
                style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, font: ttf),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Title', 'Category', 'Time', 'Description', 'Location'],
              data: tasks.map((e) => [
                e['date'],
                e['title'],
                e['category'],
                e['startTime'],
                e['description'],
                e['location'],
              ]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.centerLeft,
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "Generated on ${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
              style: pw.TextStyle(font: ttf),
            ),
          ],
        ),
      ),
    );

    try {
      // Save the file to the Downloads folder
      final downloadsDir = Directory('/storage/emulated/0/Download');
      final fileName = "Task_Report_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final outputFile = File("${downloadsDir.path}/$fileName");

      // Write the PDF file
      await outputFile.writeAsBytes(await pdf.save());
    } catch (e) {
      throw Exception("Failed to save PDF: $e");
    }
  }
}
