import 'package:rxdart/rxdart.dart';
import '../models/item_models.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();
  final _itemsFetcher = PublishSubject<int>();

  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel?>>> get items => _itemsOutput.stream;

  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  Future<void> fetchTopIds() async {
    try {
      final ids = await _repository.fetchTopIds();
      _topIds.sink.add(ids);
    } catch (e) {
      // Handle error fetching top IDs
      print('Error fetching top IDs: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      await _repository.clearCache();
    } catch (e) {
      // Handle error clearing cache
      print('Error clearing cache: $e');
    }
  }

 StreamTransformer<int, Map<int, Future<ItemModel?>>> _itemsTransformer() {
  return ScanStreamTransformer<int, Map<int, Future<ItemModel?>>>(
    (cache, id, index) {
      if (id != 0) {
        cache[id] = _repository.fetchItem(id);
      } else {
        // Handle the case of ID 0
        print('Error: Invalid item ID');
        // You might want to skip the fetching or provide a default response.
      }
      return cache;
    },
    <int, Future<ItemModel?>>{},
  );
}


  void dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
