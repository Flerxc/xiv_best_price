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
            'CALCULATE',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ),
    );
  }
}

//class _APIButtonState extends State<APIButton> {
  /*
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
          listings.forEach((listing) {
            print('Item ID: $key, Price per unit: ${listing['pricePerUnit']}');
          });
        });
      } else {
        print('failed to load data. Status code:: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }
  final Function onFetch; // Callback function for fetching data

  MyWidget({required this.onFetch});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: 350,
          height: 75,
          child: TextButton(
            onPressed: fetchAPI,
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.grey),
            ),
            child: const Text(
              'CALCULATE',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
*/