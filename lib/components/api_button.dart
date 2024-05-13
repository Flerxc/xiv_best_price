import 'package:flutter/material.dart';

class APIButton extends StatelessWidget {
  final Function fetchAPI; // Callback function for fetching data

  const APIButton({super.key, required this.fetchAPI});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        height: 75,
        child: TextButton(
          onPressed: () => fetchAPI(),
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.grey),
          ),
          child: const Text(
            'FIND BEST ITEM',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Anta',
            ),
          ),
        ),
      ),
    );
  }
}
