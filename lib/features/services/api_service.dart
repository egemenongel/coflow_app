import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/character_list_model.dart';

class ApiService {
  var baseUrl = "https://breakingbadapi.com/api";
  var characters = "/characters";

  Future getCharacters() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl + characters),
      );
      var jsonResponse = characterFromJson(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        log("${response.statusCode}");
      }
    } catch (e) {
      throw HttpException("$e");
    }
  }
}
