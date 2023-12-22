import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_models.dart';

class Repository {
  final List<Source> sources = [
    newsDbProvider,
    NewsApiProvider(),
  ];
  final List<Cache> caches = [
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() => sources[1].fetchTopIds();

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;
    
    for (var source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        for (var cache in caches) {
          if (cache != source) {
            await cache.addItem(item);
          }
        }
        print('Found item: $item');
        return item;
      }
    }

    print('Item with id $id not found');
    return null; // Return null if the item was not found
  }

  Future<void> clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id); // Adjust the return type to nullable
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
