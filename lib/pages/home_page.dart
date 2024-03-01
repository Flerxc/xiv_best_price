import 'package:flutter/material.dart';
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
  Item? currentItem;

  // Callback to change the item to display

  void updateItem(Item newItem) {
    setState(() {
      currentItem = newItem;
    });
  }

  Future<void> fetchAPI() async {
    const String url =
        'https://universalis.app/api/v2/Jenova/39711,39712,39713,39714,39715,39716?listings=1&entries=0&fields=items.itemId,items.listings.pricePerUnit';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final items = jsonResponse['items'] as Map<String, dynamic>;

        items.forEach((key, value) {
          final listings = value['listings'] as List;
          for (var listing in listings) {
            print('Item ID: $key, Price per unit: ${listing['pricePerUnit']}');
          }
        });
      } else {
        print('failed to load data. Status code:: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
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
