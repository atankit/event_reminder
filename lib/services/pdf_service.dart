import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfExportService {
  static Future<void> exportTask() async {
    // Request storage permission
    if (!await Permission.storage.request().isGranted) {
      throw Exception("Storage permission is required to export PDF.");
    }

    try {
      // Get current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not logged in.");
      }

      // Fetch tasks from nested collection: tasks/userId/userTasks
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(currentUser.uid)
          .collection('userTasks')
          .get();

      print("Current User ID: ${currentUser.uid}");
      print("Fetched ${snapshot.docs.length} task(s).");

      final tasks = snapshot.docs.map((doc) => doc.data()).toList();

      if (tasks.isEmpty) {
        throw Exception("No tasks available for this user.");
      }

      // Load custom font
      final font = await rootBundle.load("fonts/Lato-Regular.ttf");
      final ttf = pw.Font.ttf(font);

      // Create PDF
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
                data: tasks.map((task) => [
                  task['date'] ?? '',
                  task['title'] ?? '',
                  task['category'] ?? '',
                  task['startTime'] ?? '',
                  task['description'] ?? '',
                  task['location'] ?? '',
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

      // Save to Downloads folder
      final downloadsDir = Directory('/storage/emulated/0/Download');
      final random = Random().nextInt(100000);
      final fileName = "Task_Report_$random.pdf";
      final outputFile = File("${downloadsDir.path}/$fileName");

      await outputFile.writeAsBytes(await pdf.save());
      print("PDF saved to ${outputFile.path}");
    } catch (e) {
      throw Exception("Failed to generate PDF: $e");
    }
  }
}


