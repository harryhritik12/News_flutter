import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../models/item_models.dart';
import 'dart:async';
import 'repository.dart';

final _root = Uri.parse('https://hacker-news.firebaseio.com/v0');

class NewsApiProvider implements Source {
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    final response = await client.get(Uri.parse('$_root/topstories.json'));
    final ids = json.decode(response.body);

    print('Top IDs fetched: $ids');
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(Uri.parse('$_root/item/$id.json'));
    final parsedJson = json.decode(response.body);

    print('Item fetched for id: $id');
    return ItemModel.fromJson(parsedJson)!;
  }
}
