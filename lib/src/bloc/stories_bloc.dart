import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';


class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemOutputs = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemFetcher = PublishSubject<int>();

  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int,Future<ItemModel>>> get items => _itemOutputs.stream;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  Function(int) get fetchItem => _itemFetcher.sink.add;

  StoriesBloc() {
    _itemFetcher.stream.transform(_itemTransformer()).pipe(_itemOutputs);
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Map<int,Future<ItemModel>> cache, int id, index) {
        // print(index); 
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{}, 
    );
  }

  clearCache() {
    return _repository.clearCache();
  }

  dispose() {
    _topIds.close();
    _itemOutputs.close();
    _itemFetcher.close();
  }

}