import 'package:flutter_offline_mode/pages/home_page/home_page_controller.dart';
import 'package:flutter_offline_mode/shared/models/people.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomePage extends GetWidget<HomePageController> {
  // List data = [];
  // Box box;
  //
  // Future openBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('data');
  //   return;
  // }
  //
  // Future<bool> getAllData() async {
  //   await openBox();
  //   String url = "https://peopleinfoapi.herokuapp.com/api/people";
  //   try {
  //     var response = await http.get(url);
  //     var _jsonDecode = jsonDecode(response.body)['data'];
  //     // print(_jsonDecode);
  //     await putData(_jsonDecode); // need
  //   } catch (SocketException) {
  //     print('no internet');
  //   }
  //   print("box ${box.values}");
  //   // get data from DB
  //   var myMap = box.toMap().values.toList();
  //   if (myMap.isEmpty) {
  //     data.add('empty');
  //   } else {
  //     // has data in storage
  //     data = myMap;
  //   }
  //   return Future.value(true);
  // }
  //
  // Future putData(data) async {
  //   await box.clear();
  //   for (var d in data) {
  //     box.add(d);
  //   }
  // }
  //
  // Future<void> updateData() async {
  //   String url = "https://peopleinfoapi.herokuapp.com/api/people";
  //   try {
  //     var response = await http.get(url);
  //     var _jsonDecode = jsonDecode(response.body)['data'];
  //     await putData(_jsonDecode);
  //     setState(() {});
  //   } catch (SocketException) {
  //     print('no internet');
  //     Toast.show("No internet Connection", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List People"),
      ),
      body: Center(
          child: GetBuilder<HomePageController>(
              init: HomePageController(),
              builder: (homeClr) {
                if (controller.people.isNotEmpty) {
                  if (controller.people.contains('empty')) {
                    return Text('No data');
                  } else {
                    return Column(
                      children: [
                        Expanded(
                            child: RefreshIndicator(
                          onRefresh: homeClr.updateData,
                          child: ListView.builder(
                              itemCount: controller.people.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                        '${controller.people[index].firstName}'),
                                  ),
                                );
                              }),
                        )),
                      ],
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              })),
    );
  }
}
