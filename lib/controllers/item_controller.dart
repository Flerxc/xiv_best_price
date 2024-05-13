import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:xiv_best_price/controllers/api_controller.dart';
import 'package:xiv_best_price/model/item.dart';

class ItemController {
  static const List<dynamic> _currencies = [
    {
      'url': "assets/images/Tomestone_Causality.png",
      'text': "Allagan Tomestone of Causality"
    },
    {
      'url': "assets/images/Cracked_Anthocluster.png",
      'text': "Cracked Anthocluster"
    },
    {
      'url': "assets/images/Cracked_Dendrocluster.png",
      'text': "Cracked Dendrocluster"
    },
    {
      'url': "assets/images/Cracked_Stellacluster.png",
      'text': "Cracked Stellacluster"
    },
    {
      'url': "assets/images/Cracked_Planicluster.png",
      'text': "Cracked Planicluster"
    }
  ];

  List<dynamic> get currencies => _currencies;

  Future<dynamic> _readItemFromJson(String uri) async {
    final String response = await rootBundle.loadString(uri);
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

  String _generateUrl(List<dynamic> items) {
    const String baseUrl = "https://universalis.app/api/v2/Jenova/";

    const String endUrl =
        "?listings=1&entries=0&fields=items.itemId,items.listings.pricePerUnit";

    String ids = "";

    for (var i = 0; i < items.length - 1; i++) {
      ids += "${items[i]['itemId']},";
    }

    ids += "${items[items.length - 1]['itemId']}";

    return "$baseUrl$ids$endUrl";
  }

  String _getDataURI(int index) {
    String uri = "assets/data/";
    switch (index) {
      case 0:
        uri += "uncapped_tomestones.json";
      case 1:
        uri += "cracked_anthocluster.json";
      case 2:
        uri += "cracked_dendrocluster.json";
      case 3:
        uri += "cracked_stellacluster.json";
      case 4:
        uri += "cracked_planicluster.json";
    }

    return uri;
  }

  Future<Item> fetchBestItem(APIController apiController, int index) async {
    String dataURI = _getDataURI(index);
    List<dynamic> itemFromJson =
        await _readItemFromJson(dataURI) as List<dynamic>;

    String url = _generateUrl(itemFromJson);

    Map<String, dynamic> items = await apiController.fetchData(url);

    Map<String, String> bestItemIdAndPrice = _findBestItemIdAndPrice(items);
    Map<String, String> bestItemDetails =
        _findItemDetails(itemFromJson, bestItemIdAndPrice);
    Item bestItem = _createItem(bestItemDetails);

    return bestItem;
  }
}
