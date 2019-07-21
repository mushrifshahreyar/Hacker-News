import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model.dart';
import '../resources/repository.dart';
class NewsApiProvider implements Source {

  Client client = Client();
  String _domain  = 'https://hacker-news.firebaseio.com/v0';

  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_domain/topstories.json');
    final ids = json.decode(response.body);
    return  ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_domain/item/$id.json');
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJSON(parsedJson);
  }

}