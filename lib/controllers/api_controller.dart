import 'package:http/http.dart' as http;
import 'dart:convert';

class APIController {
  Future<Map<String, dynamic>> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final items = jsonResponse['items'] as Map<String, dynamic>;
      return items;
    } else {
      throw Exception(
          'Failed to load data. Status code:: ${response.statusCode}');
    }
  }
}
