import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/api_button.dart';
import '../model/item.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Item? _currentItem;
  List _items = [];

  // Callback to change the item to display

  void updateItem(Item newItem) {
    setState(() {
      _currentItem = newItem;
    });
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/uncapped_tomestones.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
    });
  }

  Item calculateBestItem(Map<String, dynamic> items) {
    // find item id and price
    var sorted = items.entries.toList()
      ..sort((a, b) => -a.value['listings'][0]['pricePerUnit']
          .compareTo(b.value['listings'][0]['pricePerUnit']));

    var bestPrice = sorted[0].value['listings'][0]['pricePerUnit'];

    String id = '';

    for (final item in items.entries) {
      if (item.value['listings'][0]['pricePerUnit'] == bestPrice) {
        id = item.key;
      }
    }

    // find item in data

    String url = '';

    String name = '';
    for (final item in _items) {
      if (item['itemId'] == id) {
        url = 'assets/images/${item['itemImageName']}';
        name = item['itemName'];
      }
    }

    // create item

    return Item(name: name, id: id, price: bestPrice, url: url);
  }

  Future<void> fetchAPI() async {
    const String url =
        'https://universalis.app/api/v2/Jenova/39711,39712,39713,39714,39715,39716?listings=1&entries=0&fields=items.itemId,items.listings.pricePerUnit';

    try {
      readJson();

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final items = jsonResponse['items'] as Map<String, dynamic>;

        Item item = calculateBestItem(items);
        updateItem(item);
      } else {
        throw Exception(
            'failed to load data. Status code:: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: const Center(
            child: Text(
          "XIV BEST PRICE",
          style: TextStyle(
            fontFamily: 'Anta',
            color: Colors.white,
          ),
        )),
        backgroundColor: Colors.red[900],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Allagan Tomestone of Causality",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/images/Tomestone_Causality.png',
                    fit: BoxFit.cover),
              ),
              APIButton(
                fetchAPI: fetchAPI,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
