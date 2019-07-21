import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDBProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDBProvider,
  ];
  
  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for(source in sources) {
      item = await source.fetchItem(id);
      if(item != null) {
        break;
      }
    }
    // sources[1].fetchItem(id);

    for(var cache in caches) {
      if(source != cache) {
        cache.addItem(item);
      }
    }

    return item;
  }

  clearCache() async {
    for(var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<ItemModel> fetchItem(int id);
  Future<List<int>> fetchTopIds();
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}