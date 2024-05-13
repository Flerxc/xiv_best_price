import 'package:flutter/material.dart';
import 'package:xiv_best_price/model/item.dart';

class ResultDialog extends StatelessWidget {
  const ResultDialog({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Best item',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Anta',
            )),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;

          return SizedBox(
            height: height - 450,
            child: Column(
              children: [
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Anta',
                  ),
                ),
                SizedBox(
                    height: 150,
                    width: 150,
                    child: item.price > 0
                        ? Image.asset(item.url, fit: BoxFit.cover)
                        : Icon(
                            Icons.money_off,
                            color: Colors.red[900],
                            size: 150.0,
                          )),
                Text(
                  item.price > 0 ? item.price.toString() : "",
                  style: const TextStyle(
                    fontFamily: 'Anta',
                    fontSize: 24,
                  ),
                )
              ],
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          )
        ]);
  }
}
