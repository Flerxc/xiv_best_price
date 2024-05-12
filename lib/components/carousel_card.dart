import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  final String text;
  final String url;
  const CarouselCard({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Anta',
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset(url, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
