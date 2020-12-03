import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data = [];
  Box box;
  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  Future<bool> getAllData() async {
    await openBox();
    String url = "https://peopleinfoapi.herokuapp.com/api/people";

    try {
      var response = await http.get(url);
      var _jsonDecode = jsonDecode(response.body)['data'];
      print(_jsonDecode);
      await putData(_jsonDecode);
    } catch (SocketException) {
      print('no internet');
    }
    // get data from DB
    var myMap = box.toMap().values.toList();
    if (myMap.isEmpty) {
      data.add('empty');
    } else {
      data = myMap;
    }

    return Future.value(true);
  }

  Future putData(data) async {
    await box.clear();
    for (var d in data) {
      box.add(d);
    }
  }

  Future<void> updateData() async {
    String url = "https://peopleinfoapi.herokuapp.com/api/people";

    try {
      var response = await http.get(url);
      var _jsonDecode = jsonDecode(response.body)['data'];
      await putData(_jsonDecode);
      setState(() {});
    } catch (SocketException) {
      print('no internet');
      Toast.show("No internet Connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder(
              future: getAllData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (data.contains('empty')) {
                    return Text('No data');
                  } else {
                    return Column(
                      children: [
                        Expanded(
                            child: RefreshIndicator(
                          onRefresh: updateData,
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (ctxt, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text('${data[index]['first_name']}'),
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
