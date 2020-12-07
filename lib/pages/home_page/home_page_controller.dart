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
  List people = [];
  // final status = Status.loading.obs;
  Box box;

  @override
  Future<void> onInit() async {
    await getAllData();
  }

  // Future<void> getData() async {
  //   status(Status.loading);
  //   this._people = await RestAPIService.instance.getPeople();
  //   print(_people);
  //   status(Status.success);
  //   update();
  // }
  //
  // Future<void> addPeople(Data people) async {
  //   Future<String> response = RestAPIService.instance.addPeople(people);
  //   response.then((String value) => print(value));
  //   update();
  // }
  //
  // Future<void> deletePeople(int userId) {
  //   Future<String> response = RestAPIService.instance.deletePeople(userId);
  //   response.then((String value) => print(value));
  // }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  Future getAllData() async {
    try {
      await openBox();
      this.people = await RestAPIService.instance.getPeople();
      await putData(people); // need
    } catch (SocketException) {
      print('no internet');
    }
    print("box ${box.values}");
    // get data from DB
    // List<Data> myMap = box.toMap().values.toList();
    List<dynamic> myMap = box.toMap().values.toList();
    if (myMap.isEmpty) {
      people.add("empty");
    } else {
      // has data in storage
      people = myMap;
    }
  }

  Future putData(List<Data> data) async {
    await box.clear();
    for (var d in data) {
      box.add(d);
    }
  }

  Future<void> updateData() async {
    try {
      this.people = await RestAPIService.instance.getPeople();
      await putData(people);
    } catch (SocketException) {
      print('no internet');
      Get.snackbar("message", "no internet connection");
    }
  }

}
