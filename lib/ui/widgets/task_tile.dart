

import 'dart:io';

import 'package:event_manager/models/task.dart';
import 'package:event_manager/ui/theme.dart';
import 'package:event_manager/ui/vdo_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';


class TaskTile extends StatelessWidget {
  final Task? task;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task?.color ?? 0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    task?.title ?? "",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Time Range
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${task?.startTime ?? 'N/A'} - ${task?.endTime ?? 'N/A'}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 14, color: Colors.grey[100]),
                        ),
                      ),
                    ],
                  ),

                  // Description and Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          task?.description ?? "",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 14, color: Colors.grey[100]),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),

                          Icon(
                            Icons.location_on,
                            color: Colors.grey[200],
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            task?.location ?? "No location",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13, color: Colors.grey[100]),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      SizedBox(width: 8),
                      Icon(
                            Icons.category,
                            color: Colors.grey[200],
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            task?.category ?? "No category",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 13, color: Colors.grey[100]),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                    ],
                  ),

                  SizedBox(height: 8),

                  // Media Display
                  if (task?.photoPath != null && task!.photoPath != "No Image Found!")
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(task!.photoPath!),
                        fit: BoxFit.cover,
                        height: 160,
                        width: double.infinity,
                      ),
                    ),
                  if (task?.videoPath != null && task!.videoPath != "No Video Found!")
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: VideoPlayerWidget(videoPath: task!.videoPath!),
                    ),

                  if (task?.filePath != null && task!.filePath != "No File Found!")
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: Colors.grey[200],
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                OpenFilex.open(task!.filePath!);
                              },
                              child: Text(
                                task!.filePath!.split('/').last,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[200], // Indicate it's clickable

                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      // Share Button
                      IconButton(
                        onPressed: _shareTaskDetails,
                        icon: Icon(Icons.share_outlined, color: Colors.grey[200]),
                      ),

                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 100,
              width: 1,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task!.isCompleted == 1 ? "COMPLETED" : "EVENT",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),

      ),

    );
  }


  // Background color based on task color index
  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }

// Share Task Details
  void _shareTaskDetails() async {
    final taskDetails = '''
Event Details:
Title: ${task?.title ?? "No Title"}
Date: ${task?.date ?? "No Date"}
Time: ${task?.startTime ?? "N/A"} - ${task?.endTime ?? "N/A"}
Description: ${task?.description ?? "No Description"}
Location: ${task?.location ?? "No Location"}
Category: ${task?.category ?? "No Category"}
  ''';

    List<XFile> filesToShare = [];

    // Add image if exists
    if (task?.photoPath != null && task!.photoPath != "No Image Found!") {
      File imageFile = File(task!.photoPath!);
      if (await imageFile.exists()) {
        filesToShare.add(XFile(imageFile.path));
      }
    }

    // Add video if exists
    if (task?.videoPath != null && task!.videoPath != "No Video Found!") {
      File videoFile = File(task!.videoPath!);
      if (await videoFile.exists()) {
        filesToShare.add(XFile(videoFile.path));
      }
    }

    // Add file if exists
    if (task?.filePath != null && task!.filePath!.isNotEmpty) {
      File file = File(task!.filePath!);
      if (await file.exists()) {
        filesToShare.add(XFile(file.path));
      } else {
        print("File does not exist: ${task!.filePath}");
      }
    }

    // Share media and text together
    if (filesToShare.isNotEmpty) {
      await Share.shareXFiles(
        filesToShare,
        text: taskDetails,
      );
    } else {
      // If no media, just share text
      await Share.share(taskDetails);
    }
  }

}
