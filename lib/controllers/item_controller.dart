import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:xiv_best_price/controllers/api_controller.dart';
import 'package:xiv_best_price/model/item.dart';

class ItemController {
  Future<dynamic> _readItemFromJson(String url) async {
    final String response = await rootBundle.loadString(url);
    final data = await json.decode(response);

    return data["items"];
  }

  Map<String, String> _findBestItemIdAndPrice(Map<String, dynamic> items) {
    var sorted = items.entries.toList()
      ..sort((a, b) => -a.value['listings'][0]['pricePerUnit']
          .compareTo(b.value['listings'][0]['pricePerUnit']));

    return {
      'id': sorted.first.key,
      'price': sorted.first.value['listings'][0]['pricePerUnit'].toString()
    };
  }

  Map<String, String> _findItemDetails(
      List items, Map<String, String> idAndPrice) {
    String url = '';
    String id = idAndPrice['id']!;
    String name = '';
    for (final item in items) {
      if (item['itemId'] == id) {
        name = item['itemName'];
        url = 'assets/images/${item['itemImageName']}';
      }
    }
    return {'name': name, 'url': url, 'price': idAndPrice['price']!, 'id': id};
  }

  Item _createItem(Map<String, String> details) {
    return Item(
        name: details['name']!,
        id: details['id']!,
        price: int.parse(details['price']!),
        url: details['url']!);
  }

  Future<Item> fetchBestItem(APIController apiController) async {
    Map<String, dynamic> items = await apiController.fetchData();

    List<dynamic> itemFromJson =
        await _readItemFromJson('assets/data/uncapped_tomestones.json')
            as List<dynamic>;

    Map<String, String> bestItemIdAndPrice = _findBestItemIdAndPrice(items);
    Map<String, String> bestItemDetails =
        _findItemDetails(itemFromJson, bestItemIdAndPrice);
    Item bestItem = _createItem(bestItemDetails);
    return bestItem;
  }
}
