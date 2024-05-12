import 'package:http/http.dart' as http;
import 'dart:convert';

class APIController {
  Future<Map<String, dynamic>> fetchData() async {
    const String url =
        'https://universalis.app/api/v2/Jenova/39711,39712,39713,39714,39715,39716?listings=1&entries=0&fields=items.itemId,items.listings.pricePerUnit';

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
