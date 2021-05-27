import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(var url) async {
    http.Response respone = await http.get(Uri.parse(url));

    try {
      if (respone.statusCode == 200) {
        String data = respone.body;
        var decodeData = jsonDecode(data);
        return decodeData;
      } else {
        return "failed ";
      }
    } catch (err) {
      return "failed";
    }
  }
}
