import 'package:dio/dio.dart';
import 'package:flutter_offline_mode/shared/models/people.dart';

class RestAPIService {
  String baseUrl = "https://peopleinfoapi.herokuapp.com/api/people";
  final _defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };
  final _dio = Dio();
  RestAPIService._internal();
  static RestAPIService _instance = RestAPIService._internal();
  static RestAPIService get instance => _instance;
  Future getPeople() async {
    final response = await _dio.get(baseUrl);
    return (response.data['data'] as List)
        .map((e) => Data.fromJson(e))
        .toList();
  }

  Future<String> addPeople(Data person) async {
    try {
      final response = await _dio.post(baseUrl,
          options: Options(headers: _defaultHeaders), data: person.toJson());
      if (response.statusCode == 201) {
        print(response.statusCode);
        return response.statusCode.toString();
      } else {
        return response.statusCode.toString();
      }
    } catch (ex) {
      return ex.toString();
    }
  }

  Future<String> deletePeople(int userId) async {
    String resStatusCode;
    try {
      final response = await _dio.delete("$baseUrl/$userId ");
      resStatusCode = response.statusCode.toString();
      return resStatusCode;
    } catch (ex) {
      print(ex);
      return resStatusCode;
    }
  }
}
