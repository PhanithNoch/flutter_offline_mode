import 'dart:convert';

import 'package:flutter_offline_mode/shared/models/people.dart';
import 'package:flutter_offline_mode/shared/services/rest_api_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class HomePageController extends GetxController {
  List data = [];
  Box box;

  @override
  void onInit() async {
    await getAllData();

    super.onInit();
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
  }

  Future putData(data) async {
    await box.clear();
    for (var d in data) {
      box.add(d);
    }
  }

  Future<void> deleteData(int id) async {
    print(id);

 try{
   String url = "https://peopleinfoapi.herokuapp.com/api/people/$id";
   print(url);
   var response = await http.delete("$url}",headers: {
     "Content-Type": "application/json",
     "Accept": "application/json"
   });
   print(response.statusCode);
 }catch(ex)
    {
      print(ex);
    }
    update();
  }

  Future<void> updateData() async {
    String url = "https://peopleinfoapi.herokuapp.com/api/people";
    try {
      var response = await http.get(url);
      var _jsonDecode = jsonDecode(response.body)['data'];

      await putData(_jsonDecode);
    } catch (SocketException) {
      print('no internet');
    }
    update();
  }

  Future<void> getAllData() async {
    await openBox();
    String url = "https://peopleinfoapi.herokuapp.com/api/people";

    try {
      var response = await http.get(url);
      print("status $response");
      var _jsonDecode = jsonDecode(response.body)['data'];

      await putData(_jsonDecode);
      update();
    } catch (SocketException) {
      print('no internet');
    }
    // get data from DB
    var myMap = box.toMap().values.toList();
    if (myMap.isEmpty) {
      data.add('empty');
    } else {
      data = myMap;
      update();
    }
  }
}
