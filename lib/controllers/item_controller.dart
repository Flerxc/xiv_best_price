import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:xiv_best_price/controllers/api_controller.dart';
import 'package:xiv_best_price/model/item.dart';

class ItemController {
  static const List<dynamic> _currencies = [
    {
      'url': "assets/images/Tomestone_Aesthetics.png",
      'text': "Allagan Tomestone of Aesthetics"
    },
    {
      'url': "assets/images/Cracked_Novacluster.png",
      'text': "Cracked Novacluster"
    },
    {
      'url': "assets/images/Cracked_Prismaticluster.png",
      'text': "Cracked Prismaticluster"
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
      'url': "assets/images/DoW_DoM.png",
      'text': "Ventures\n(Disciple of War/Magic)"
    },
    {'url': "assets/images/btn.png", 'text': "Ventures\n(Botanist)"}
  ];

  List<dynamic> get currencies => _currencies;

  String _getDataURI(int index) {
    String uri = "assets/data/";
    switch (index) {
      case 0:
        uri += "uncapped_tomestones.json";
      case 1:
        uri += "cracked_novacluster.json";
      case 2:
        uri += "cracked_prismaticluster.json";
      case 3:
        uri += "cracked_anthocluster.json";
      case 4:
        uri += "cracked_dendrocluster.json";
      case 5:
        uri += "dow_dom_ventures.json";
      case 6:
        uri += "btn_ventures.json";
    }

    return uri;
  }

  Future<dynamic> _readItemsFromJson(String uri) async {
    final String response = await rootBundle.loadString(uri);
    final data = await json.decode(response);

    return data["items"];
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

  int _findMinimumPrice(String id, List<dynamic> items) {
    int minimumPrice = 0;

    for (var item in items) {
      if (id == item["itemId"]) {
        minimumPrice = int.parse(item["sellPrice"]);
      }
    }

    return minimumPrice;
  }

  Map<String, String>? _findBestItemIdAndPrice(
      Map<String, dynamic> items, List<dynamic> itemsFromJson) {
    var sorted = items.entries.toList()
      ..sort((a, b) => -a.value['listings'][0]['pricePerUnit']
          .compareTo(b.value['listings'][0]['pricePerUnit']));

    for (final item in sorted) {
      int minimumPrice = _findMinimumPrice(item.key, itemsFromJson);
      if (item.value['listings'][0]['pricePerUnit'] > minimumPrice) {
        return {
          'id': item.key,
          'price': item.value['listings'][0]['pricePerUnit'].toString()
        };
      }
    }

    return null;
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

  Future<Item?> fetchBestItem(APIController apiController, int index) async {
    String dataURI = _getDataURI(index);
    List<dynamic> itemsFromJson =
        await _readItemsFromJson(dataURI) as List<dynamic>;

    String url = _generateUrl(itemsFromJson);

    Map<String, dynamic> items = await apiController.fetchData(url);

    Map<String, String>? bestItemIdAndPrice =
        _findBestItemIdAndPrice(items, itemsFromJson);

    if (bestItemIdAndPrice == null) {
      return null;
    }

    Map<String, String> bestItemDetails =
        _findItemDetails(itemsFromJson, bestItemIdAndPrice);
    Item bestItem = _createItem(bestItemDetails);

    return bestItem;
  }
}
