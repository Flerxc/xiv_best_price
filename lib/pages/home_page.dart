import 'package:flutter/material.dart';
import 'package:xiv_best_price/controllers/api_controller.dart';
import 'package:xiv_best_price/controllers/item_controller.dart';
import '../components/api_button.dart';
import '../components/result_dialog.dart';
import '../model/item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ItemController _itemController = ItemController();
  final APIController _apiController = APIController();

  void displayBestItem() {
    _itemController.fetchBestItem(_apiController).then((Item bestItem) {
      showDialog(
          context: context,
          builder: (BuildContext context) => ResultDialog(item: bestItem));
    });
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'Anta',
                ),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/images/Tomestone_Causality.png',
                    fit: BoxFit.cover),
              ),
              APIButton(
                fetchAPI: displayBestItem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
