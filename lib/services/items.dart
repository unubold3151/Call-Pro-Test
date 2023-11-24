import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:refactor_task/models/item.dart';

class ItemService {
  Future<List<Item>> fetchAndStoreItems() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      List<Item> itemList = (json.decode(response.body) as List).map((i) => Item.fromJson(i)).toList();
      return itemList;
    } else {
      return [];
    }
  }
}
