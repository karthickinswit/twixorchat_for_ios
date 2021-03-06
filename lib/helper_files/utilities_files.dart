// ignore_for_file: deprecated_member_use, non_constant_identifier_names, avoid_print

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';

var httpClient = HttpClient();

String MainPageTitle = "";
late ThemeData customTheme; //= ThemeData();

class ThemeClass {
  late String MainPageTitile;
  var customObject = {};
  //ThemeClass();
}

bool attachmentProgress = true;

ContentReturnType(String s) {
  List k = [
    {
      "IMAGE": ["image/jpeg", "image/jpg", "image/png"]
    },
    {
      "VIDEO": ["video/mp4"]
    },
    {
      "AUDIO": [
        "audio/aac",
        "audio/x-m4a",
        "audio/mp3",
        "audio/amr",
        "audio/ogg"
      ]
    },
    {
      "DOC": [
        "application/pdf",
        "application/doc",
        "application/docx",
        "application/ppt",
        "application/pptx",
        "application/xls",
        "application/xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/vnd.ms-excel",
        "text/csv"
      ]
    }
  ];
  var temp = "";
  k.asMap().forEach((i, value) {
    // print("I $i -> ${value.toString()}");
    for (var v in value.values) {
      // print("V - ${v.toString()}");
      if (v.contains(s)) {
        // print("RESULT ${k[i].keys}");
        k[i].forEach((key, value) {
          // print('key: $key, value: $value');
          temp = key;
        });
        break;
      }
    }
  });
  return temp;
}

String ConvertTime(String time) {
  // print(time);
  // var temp = DateTime.parse(time);
  // print(temp); //DateFormat('d/M/yyyy').parse(time);

  // return DateFormat('dd,  yy s:s').format(temp).toString();

  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var now;
  try {
    now = DateTime.parse(time).toLocal();
  } catch (Exception) {
    now = DateTime.fromMillisecondsSinceEpoch(int.parse(time)).toLocal();
  }

  // now = now.add(const Duration(hours: 5, minutes: 30));

  var day = now.day.toString().padLeft(2, '0');
  String formattedTime = DateFormat('h:mm a').format(now);
  //print(formattedTime);
  // print(formattedDate);
  return '${months[now.month - 1]} $day, ${now.year} ' + ' ' + formattedTime;
}

StoredtoFile(String url, String filename) async {
  if (await Permission.storage.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    const folderName = "twixor_customer";
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    final path = Directory('$dir/$folderName');
    //print(path.path);
    File file = File(path.path + '/$filename');
    //print(file);
    //await file.writeAsBytes(bytes);
    if ((await path.exists())) {
      print("exist");
      //print(file.toString());
      await file.writeAsBytes(bytes);
      return file.uri.path;
    } else {
      print("not exist");
      path.create();
      print("created");
      print(file.toString());
      await file.writeAsBytes(bytes);
      return file.uri.path.toString();
    }
  } else {
// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }
}

ErrorAlert(BuildContext context, String msg) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: Color.fromARGB(255, 137, 164, 186),
    duration: const Duration(seconds: 1),
  ));
  // ScaffoldMessenger.of(context).widget
  return false;
}
