class Item {
  final String name;
  final String id;
  final int price;
  final String url;

  Item(
      {required this.name,
      required this.id,
      required this.price,
      required this.url});

  @override
  String toString() {
    return 'Name: $name, Id: $id, Price: $price, URL: $url';
  }
}
