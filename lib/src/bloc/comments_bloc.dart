import 'dart:async';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CommentsBloc {
  final _commentFetcher = PublishSubject<int>();
  final _commentOutput = BehaviorSubject<Map<int,Future<ItemModel>>>();
  final Repository _repository = new Repository();

  CommentsBloc() {
    _commentFetcher.stream.transform(_commentTransformer()).pipe(_commentOutput);
  }
  //Stream
  Observable<Map<int,Future<ItemModel>>> get itemsWithComments => _commentOutput.stream; 
  Function(int) get fetchItemWithComment => _commentFetcher.sink.add;
  
  _commentTransformer() {
    return ScanStreamTransformer<int,Map<int,Future<ItemModel>>> (
      (cache,int id, index) {
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item) {
        item.kids.forEach((kidsId) => fetchItemWithComment(kidsId));
        });
      },
      <int, Future<ItemModel>> {},
    );
  }
  dispose() {
    _commentFetcher.close();
    _commentOutput.close();
  }
}