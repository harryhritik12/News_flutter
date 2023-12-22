import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_models.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();

  // Streams
  Stream<Map<int, Future<ItemModel?>>> get itemWithComments =>
      _commentsOutput.stream;

  // Sink
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  StreamTransformer<int, Map<int, Future<ItemModel?>>> _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel?>>>(
      (cache, id, index) {
        _repository.fetchItem(id).then((ItemModel? item) {
          if (item != null) {
            cache[id] = Future.value(item);
            item.kids.forEach((kidId) => fetchItemWithComments(kidId));
          } else {
            // Handle the scenario where fetching item failed
            // For instance, you could add an error placeholder or log the error
            print('Error: Item with id $id not fetched');
          }
        }).catchError((error) {
          // Handle any error during fetching, log it or handle accordingly
          print('Error: $error');
        });

        return cache;
      },
      <int, Future<ItemModel?>>{},
    );
  }

  void dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }

  void debugPrint(String message) {
    print('Debug: $message');
  }
}
