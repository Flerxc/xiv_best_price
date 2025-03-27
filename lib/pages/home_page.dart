import 'package:flutter/material.dart';
import 'package:xiv_best_price/controllers/api_controller.dart';
import 'package:xiv_best_price/controllers/item_controller.dart';
import '../components/api_button.dart';
import '../components/carousel_card.dart';
import '../components/result_dialog.dart';
import '../model/item.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ItemController _itemController = ItemController();
  final APIController _apiController = APIController();

  int _carouselIndex = 0;

  void displayBestItem() {
    _itemController
        .fetchBestItem(_apiController, _carouselIndex)
        .then((Item? bestItem) {
      bestItem ??= Item(
          name: "No item is worth selling. Come back later!",
          id: "-1",
          price: -1,
          url: "");

      showDialog(
          context: context,
          builder: (BuildContext context) => ResultDialog(item: bestItem!));
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
              CarouselSlider(
                  items: [
                    for (var i = 0; i < _itemController.currencies.length; i++)
                      i
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CarouselCard(
                          text: _itemController.currencies[i]["text"],
                          url: _itemController.currencies[i]["url"],
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 300.0,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _carouselIndex = index;
                      });
                    },
                  )),
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
